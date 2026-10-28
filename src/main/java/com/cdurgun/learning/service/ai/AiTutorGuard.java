package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.AiFeature;
import com.cdurgun.learning.domain.AiUsageLog;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.AiCostCalculator.CostEstimate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Objects;
import java.util.Optional;
import java.util.function.Supplier;

/**
 * AI Tutor'un sağlayıcıya giden her isteğinin önündeki kapı (bkz. plan §10). Sırasıyla:
 * kimlik (girişli + {@code app_user.role = ADMIN}), yapılandırma (geçerli, bayrak açık, anahtar
 * var), ardından {@link AiReservationStore}'da TEK bir kilitli transaction içinde kullanıcının
 * açık isteği, saatlik limiti, günlük ve aylık bütçe -- ve hepsi geçerse en kötü durum tutarıyla
 * bir rezervasyon. Yalnızca {@link Allowed} bir {@link Reservation} taşır; sağlayıcıya ancak onunla
 * gidilir. Reddedilen hiçbir istek rezervasyon oluşturmaz.
 *
 * <p><b>Maliyet politikası (sonuç yazma):</b> sağlayıcı kullanımı bildirdiyse tahmin o token'larla;
 * bildirmediyse -- zaman aşımı, bağlantı kopması, 400/401/402/422/429 dahil HER hata -- en kötü
 * durum tutarı yazılır. Hata yanıtlarının ücretsiz olduğu resmî belgeyle doğrulanmadıkça
 * varsayılmaz. Yalnızca sağlayıcıya kesinlikle gidilmemiş istekler ({@link AiErrorCategory#DISABLED})
 * rezervasyonu bırakır. Rezervasyon tutarı ({@code ai_tutor_reservation.reserved_usd}) ile
 * harcama tahmini ({@code ai_usage_log.estimated_cost_usd}) ayrı yerlerde tutulur.</p>
 *
 * <p>Sonuç yazılamazsa (DB hatası) rezervasyon ACTIVE kalır, süresi dolunca EXPIRED olur ve
 * en kötü durum tutarıyla bütçede sayılmaya devam eder: hata bütçeyi hiçbir zaman gevşetmez.</p>
 *
 * <p>Hiçbir log satırına API anahtarı, kullanıcı mesajı ya da ders içeriği yazılmaz; yalnızca
 * sayılar ve istisna sınıf adları.</p>
 */
@Service
public class AiTutorGuard {

    private static final Logger log = LoggerFactory.getLogger(AiTutorGuard.class);

    /** Rezervasyonun ACTIVE kaldığı süre = bağlantı + toplam zaman aşımı + bu pay. */
    static final Duration EXPIRY_MARGIN = Duration.ofSeconds(60);

    private final AiTutorSettings settings;
    private final AiCostCalculator calculator;
    private final UserRepository userRepository;
    private final AiReservationStore store;
    private final AiUsageRecorder recorder;
    private final TransactionTemplate transactions;
    private final Clock clock;

    @Autowired
    public AiTutorGuard(AiTutorSettings settings, UserRepository userRepository, AiReservationStore store,
                        AiUsageRecorder recorder, PlatformTransactionManager transactionManager) {
        this(settings, userRepository, store, recorder, transactionManager, Clock.systemUTC());
    }

    AiTutorGuard(AiTutorSettings settings, UserRepository userRepository, AiReservationStore store,
                 AiUsageRecorder recorder, PlatformTransactionManager transactionManager, Clock clock) {
        this.settings = settings;
        this.calculator = settings.properties().map(AiCostCalculator::new).orElse(null);
        this.userRepository = userRepository;
        this.store = store;
        this.recorder = recorder;
        this.transactions = new TransactionTemplate(transactionManager);
        this.clock = clock;
    }

    public enum DenialReason {
        NOT_AUTHENTICATED,
        /** Girişli ama ADMIN değil. */
        FORBIDDEN,
        /** Yapılandırma geçersiz: AI Tutor güvenli biçimde kapalı. */
        INVALID_CONFIGURATION,
        DISABLED,
        MISSING_API_KEY,
        REQUEST_IN_FLIGHT,
        HOURLY_LIMIT_REACHED,
        DAILY_BUDGET_EXHAUSTED,
        MONTHLY_BUDGET_EXHAUSTED,
        /** Kontroller yapılamadı (DB hatası, kilit zaman aşımı): istek gönderilmez. */
        GUARD_UNAVAILABLE
    }

    /** Kabul edilmiş bir istek. {@code reserved} her zaman en kötü durum tahminidir. */
    public record Reservation(long id, long userId, Instant createdAt, int inputChars, CostEstimate reserved) {
    }

    public sealed interface Decision permits Allowed, Denied {
    }

    public record Allowed(Reservation reservation) implements Decision {
    }

    public record Denied(DenialReason reason) implements Decision {
    }

    /** Kullanım kaydı için isteğin içeriksiz bilgileri; ders yoksa slug/dil/bağlam {@code null}. */
    public record CallInfo(String topicSlug, Language language, Integer contextChars) {
    }

    public sealed interface Outcome permits Rejected, Completed, Failed {
    }

    /** Sağlayıcıya gidilmedi, rezervasyon yok. */
    public record Rejected(DenialReason reason) implements Outcome {
    }

    /** {@code usageLog == null}: sonuç yazılamadı, rezervasyon en kötü durumla sayılmaya devam ediyor. */
    public record Completed(TutorCompletion completion, AiUsageLog usageLog) implements Outcome {
    }

    /** {@code usageLog == null}: gidilmedi (DISABLED, rezervasyon bırakıldı) ya da sonuç yazılamadı. */
    public record Failed(AiProviderException failure, AiUsageLog usageLog) implements Outcome {
    }

    /**
     * Rezervasyon YAPMADAN yalnızca "kim" ve "açık mı" kontrolleri: girişli ADMIN mi, yapılandırma
     * geçerli, tutor açık ve API anahtarı var mı. Boşsa erişim var. {@link #reserve} aynı kontrolü
     * yeniden yapar; bu, isteğin geri kalanı (ders bağlamı, konuşma) işlenmeden ÖNCE reddetmek için.
     */
    public Optional<DenialReason> checkAccess(Authentication authentication) {
        Access access = access(authentication);
        return access.denied() == null ? Optional.empty() : Optional.of(access.denied().reason());
    }

    /**
     * Kontrolleri yapar ve izin verilirse rezervasyonu ayırır. {@code inputChars}: modele gidecek
     * tüm mesajların toplam karakter sayısı (yerel doğrulamadan SONRA); en kötü durum bundan hesaplanır.
     */
    public Decision reserve(Authentication authentication, int inputChars) {
        if (inputChars < 0) {
            throw new IllegalArgumentException("inputChars must not be negative");
        }
        Access access = access(authentication);
        if (access.denied() != null) {
            return access.denied();
        }
        User user = access.user();
        AiTutorProperties properties = access.properties();

        CostEstimate worstCase = calculator.worstCase(inputChars);
        Instant now = clock.instant();
        AiReservationStore.Outcome outcome;
        try {
            outcome = store.reserve(new AiReservationStore.Request(user.getId(), now, inputChars,
                    worstCase.usd(), worstCase.pricingVersion(), reservationTtl(properties),
                    properties.limits().requestsPerUserPerHour(),
                    properties.budget().dailyUsd(), properties.budget().monthlyUsd()));
        } catch (RuntimeException e) {
            return unavailable("reservation", e);
        }
        if (!outcome.reserved()) {
            return new Denied(outcome.rejection());
        }
        warnIfCrossingAlert("daily", outcome.dayCommitted(), worstCase.usd(), properties.budget().dailyUsd(),
                properties.budget().alertRatio());
        warnIfCrossingAlert("monthly", outcome.monthCommitted(), worstCase.usd(), properties.budget().monthlyUsd(),
                properties.budget().alertRatio());
        return new Allowed(new Reservation(outcome.reservationId(), user.getId(), now, inputChars, worstCase));
    }

    /**
     * Rezervasyon -> çağrı -> sonuç yazma. {@code providerCall} YALNIZCA rezervasyon başarılıysa
     * çağrılır. {@link AiProviderException} dışındaki bir istisna, isteğin gidip gitmediği bilinmediği
     * için en kötü durumla yazılır ve yeniden fırlatılır.
     */
    public Outcome execute(Authentication authentication, int inputChars, CallInfo info,
                           Supplier<TutorCompletion> providerCall) {
        Objects.requireNonNull(info, "info");
        Objects.requireNonNull(providerCall, "providerCall");
        Decision decision = reserve(authentication, inputChars);
        if (decision instanceof Denied denied) {
            return new Rejected(denied.reason());
        }
        Reservation reservation = ((Allowed) decision).reservation();

        long started = System.nanoTime();
        TutorCompletion completion;
        try {
            completion = providerCall.get();
        } catch (AiProviderException failure) {
            Duration duration = Duration.ofNanos(System.nanoTime() - started);
            return new Failed(failure, settleQuietly(reservation,
                    () -> settleFailure(reservation, info, duration, failure).orElse(null)));
        } catch (RuntimeException unexpected) {
            Duration duration = Duration.ofNanos(System.nanoTime() - started);
            AiProviderException unknown = new AiProviderException(AiErrorCategory.PROVIDER_ERROR, null, null, unexpected);
            settleQuietly(reservation, () -> settleFailure(reservation, info, duration, unknown).orElse(null));
            throw unexpected;
        }
        Duration duration = Duration.ofNanos(System.nanoTime() - started);
        return new Completed(completion, settleQuietly(reservation,
                () -> settleSuccess(reservation, info, duration, completion)));
    }

    /** Sağlayıcı kullanımı bildirdiyse gerçek tahmin, bildirmediyse en kötü durum yazılır. */
    public AiUsageLog settleSuccess(Reservation reservation, CallInfo info, Duration duration,
                                    TutorCompletion completion) {
        Objects.requireNonNull(completion, "completion");
        AiUsageRecorder.Call call = call(reservation, info, duration);
        CostEstimate cost = requireCalculator().forCall(completion.usage(), reservation.inputChars(), reservation.createdAt());
        return settle(reservation, () -> recorder.recordSuccess(call, completion, cost));
    }

    /**
     * Kullanım yoksa en kötü durum (hangi HTTP durumu olursa olsun). {@link AiErrorCategory#DISABLED}
     * sağlayıcıya hiç gidilmediği anlamına gelir: hiçbir şey yazılmaz, rezervasyon bırakılır.
     */
    public Optional<AiUsageLog> settleFailure(Reservation reservation, CallInfo info, Duration duration,
                                              AiProviderException failure) {
        Objects.requireNonNull(failure, "failure");
        if (failure.getCategory() == AiErrorCategory.DISABLED) {
            release(reservation);
            return Optional.empty();
        }
        AiUsageRecorder.Call call = call(reservation, info, duration);
        CostEstimate cost = requireCalculator().forCall(failure.getUsage(), reservation.inputChars(), reservation.createdAt());
        return Optional.of(settle(reservation, () -> recorder.recordFailure(call, failure, cost)));
    }

    /** Yalnızca istek sağlayıcıya KESİNLİKLE gönderilmediyse. Zaten kapanmışsa {@code false}. */
    public boolean release(Reservation reservation) {
        return store.release(reservation.id(), reservation.userId(), clock.instant());
    }

    // Log satırı ve rezervasyonun kapanması aynı transaction'da, bütçe kilidi altında: bütçe
    // toplamı hiçbir anda ikisini birden ya da hiçbirini görmez.
    private AiUsageLog settle(Reservation reservation, Supplier<AiUsageLog> write) {
        return transactions.execute(status -> {
            store.lockInCurrentTransaction();
            AiUsageLog usageLog = write.get();
            if (!store.markSettled(reservation.id(), reservation.userId(), usageLog.getId(), clock.instant())) {
                throw new IllegalStateException("reservation " + reservation.id() + " is already closed");
            }
            return usageLog;
        });
    }

    private AiUsageLog settleQuietly(Reservation reservation, Supplier<AiUsageLog> settlement) {
        try {
            return settlement.get();
        } catch (RuntimeException e) {
            log.warn("AI Tutor usage could not be recorded ({}); reservation {} stays counted at its worst case",
                    e.getClass().getSimpleName(), reservation.id());
            return null;
        }
    }

    private AiUsageRecorder.Call call(Reservation reservation, CallInfo info, Duration duration) {
        Objects.requireNonNull(reservation, "reservation");
        Objects.requireNonNull(info, "info");
        String model = settings.properties().orElseThrow(() -> new IllegalStateException("AI Tutor is not configured"))
                .model();
        // startedAt = rezervasyon anı: log satırı rezervasyonla aynı bütçe gününe/ayına düşer.
        return new AiUsageRecorder.Call(reservation.userId(), AiFeature.TUTOR, model, info.topicSlug(),
                info.language(), reservation.createdAt(), duration, reservation.inputChars(), info.contextChars());
    }

    private AiCostCalculator requireCalculator() {
        if (calculator == null) {
            throw new IllegalStateException("AI Tutor is not configured");
        }
        return calculator;
    }

    /** {@code denied} doluysa diğer iki alan {@code null}. */
    private record Access(User user, AiTutorProperties properties, Denied denied) {

        static Access deniedFor(DenialReason reason) {
            return new Access(null, null, new Denied(reason));
        }
    }

    private Access access(Authentication authentication) {
        Optional<User> user;
        try {
            user = authenticatedUser(authentication);
        } catch (RuntimeException e) {
            return new Access(null, null, unavailable("user lookup", e));
        }
        if (user.isEmpty()) {
            return Access.deniedFor(DenialReason.NOT_AUTHENTICATED);
        }
        if (user.get().getRole() != Role.ADMIN) {
            return Access.deniedFor(DenialReason.FORBIDDEN);
        }

        Optional<AiTutorProperties> configured = settings.properties();
        if (configured.isEmpty() || calculator == null) {
            return Access.deniedFor(DenialReason.INVALID_CONFIGURATION);
        }
        AiTutorProperties properties = configured.get();
        if (!properties.enabled()) {
            return Access.deniedFor(DenialReason.DISABLED);
        }
        if (!properties.hasApiKey()) {
            return Access.deniedFor(DenialReason.MISSING_API_KEY);
        }
        return new Access(user.get(), properties, null);
    }

    // principal adı her giriş yolunda yerel e-postadır, rol yalnızca app_user.role'den gelir.
    private Optional<User> authenticatedUser(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken) {
            return Optional.empty();
        }
        String email = authentication.getName();
        if (email == null || email.isBlank()) {
            return Optional.empty();
        }
        return userRepository.findByEmail(email);
    }

    private static Duration reservationTtl(AiTutorProperties properties) {
        return properties.timeouts().connect().plus(properties.timeouts().total()).plus(EXPIRY_MARGIN);
    }

    private Denied unavailable(String step, RuntimeException e) {
        log.warn("AI Tutor guard {} failed ({}); request refused", step, e.getClass().getSimpleName());
        return new Denied(DenialReason.GUARD_UNAVAILABLE);
    }

    private static void warnIfCrossingAlert(String period, BigDecimal before, BigDecimal amount,
                                            BigDecimal budget, BigDecimal ratio) {
        if (budget.signum() <= 0) {
            return;
        }
        BigDecimal threshold = budget.multiply(ratio);
        BigDecimal after = before.add(amount);
        if (before.compareTo(threshold) < 0 && after.compareTo(threshold) >= 0) {
            log.warn("AI Tutor {} budget reached {} of {} USD (estimate incl. reservations)",
                    period, after.toPlainString(), budget.toPlainString());
        }
    }
}

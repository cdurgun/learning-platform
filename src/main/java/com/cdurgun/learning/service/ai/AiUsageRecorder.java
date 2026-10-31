package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.domain.AiFeature;
import com.cdurgun.learning.domain.AiUsageLog;
import com.cdurgun.learning.domain.AiUsageOutcome;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.repository.AiUsageLogRepository;
import com.cdurgun.learning.service.ai.AiCostCalculator.CostEstimate;
import com.cdurgun.learning.service.ai.AiCostCalculator.PricingPeriod;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Objects;

/**
 * Sağlayıcıya yapılan her çağrı için tek bir {@link AiUsageLog} satırı yazar. Maliyeti KENDİSİ
 * HESAPLAMAZ: {@link AiCostCalculator}'ın verdiği {@link CostEstimate}'i alır ve yalnızca
 * kullanım verisiyle tutarlı olduğunu doğrular. Tutarsız bir giriş bir programlama hatasıdır,
 * {@link IllegalArgumentException} fırlatır ve hiçbir satır yazılmaz.
 *
 * <p>Kurallar: token sayıları yalnızca maliyet "bildirilmiş kullanım"dan hesaplandıysa yazılır;
 * kullanım bilinmiyorsa token kolonları boş kalır ve tutar en kötü durumdur -- asla sıfır
 * değil. Soru, cevap, ders içeriği ve API anahtarı bu sınıfa hiç gelmez; yalnızca boyutlar.
 * Hangi hataların ücretlendirileceği (en kötü durum mu) burada değil, maliyeti hesaplayan
 * çağıranda kararlaştırılır.</p>
 *
 * <p>Sağlayıcı pozitif {@code reasoning_tokens} bildirirse yalnızca sayılarla bir uyarı yazılır:
 * her istek thinking'i kapatıyor, yani bu beklenmedik bir sağlayıcı davranışıdır. Maliyet yine
 * yalnızca {@code completion_tokens}'tan hesaplanır (bkz. {@link AiCostCalculator}).</p>
 *
 * <p>Kullanım bildirilmediği ya da güvenilir okunamadığı için en kötü durum tahminiyle yazılan
 * her satır için de çağrı başına tek bir uyarı yazılır: sonuç, hata kategorisi, tutar ve girdi
 * boyutu -- içerik yok.</p>
 */
@Service
public class AiUsageRecorder {

    private static final Logger log = LoggerFactory.getLogger(AiUsageRecorder.class);

    private final AiUsageLogRepository repository;

    public AiUsageRecorder(AiUsageLogRepository repository) {
        this.repository = repository;
    }

    /**
     * Bir çağrının sağlayıcıdan bağımsız bilgileri.
     *
     * @param startedAt isteğin gönderildiği an; {@code created_at}'e UTC olarak yazılır
     * @param inputChars modele gönderilen tüm mesajların toplam karakter sayısı
     * @param contextChars kesildikten sonraki ders bağlamı boyutu; ders yoksa {@code null}
     */
    public record Call(Long userId,
                       AiFeature feature,
                       String model,
                       String topicSlug,
                       Language language,
                       Instant startedAt,
                       Duration duration,
                       int inputChars,
                       Integer contextChars) {

        public Call {
            Objects.requireNonNull(userId, "userId");
            Objects.requireNonNull(feature, "feature");
            Objects.requireNonNull(startedAt, "startedAt");
            Objects.requireNonNull(duration, "duration");
            if (model == null || model.isBlank()) {
                throw new IllegalArgumentException("model must not be blank");
            }
            if (duration.isNegative() || duration.toMillis() > Integer.MAX_VALUE) {
                throw new IllegalArgumentException("duration out of range");
            }
            if (inputChars < 0 || (contextChars != null && contextChars < 0)) {
                throw new IllegalArgumentException("sizes must not be negative");
            }
        }
    }

    public AiUsageLog recordSuccess(Call call, TutorCompletion completion, CostEstimate cost) {
        Objects.requireNonNull(completion, "completion");
        return save(call, AiUsageOutcome.SUCCESS, null, completion.truncated(), completion.usage(), cost);
    }

    /**
     * {@link AiErrorCategory#DISABLED} kaydedilmez: o durumda sağlayıcıya hiç istek gitmemiştir,
     * kaydetmek var olmayan bir harcama yazmak olurdu.
     */
    public AiUsageLog recordFailure(Call call, AiProviderException failure, CostEstimate cost) {
        Objects.requireNonNull(failure, "failure");
        if (failure.getCategory() == AiErrorCategory.DISABLED) {
            throw new IllegalArgumentException("DISABLED means no provider call was made; nothing to record");
        }
        return save(call, AiUsageOutcome.ERROR, failure.getCategory().name(), false, failure.getUsage(), cost);
    }

    private AiUsageLog save(Call call, AiUsageOutcome outcome, String errorCategory, boolean truncated,
                            TutorUsage usage, CostEstimate cost) {
        Objects.requireNonNull(call, "call");
        BigDecimal usd = checkedCost(cost, usage);

        AiUsageLog.AiUsageLogBuilder log = AiUsageLog.builder()
                .userId(call.userId())
                .feature(call.feature())
                .model(call.model())
                .topicSlug(call.topicSlug())
                .language(call.language())
                .createdAt(LocalDateTime.ofInstant(call.startedAt(), ZoneOffset.UTC))
                .durationMs((int) call.duration().toMillis())
                .outcome(outcome)
                .errorCategory(errorCategory)
                .truncated(truncated)
                .inputChars(call.inputChars())
                .contextChars(call.contextChars())
                .usageReported(cost.usageReported())
                .estimatedCostUsd(usd)
                .pricingPeriod(cost.period().name())
                .pricingVersion(cost.pricingVersion());

        if (cost.usageReported()) {
            log.promptCacheHitTokens(usage.promptCacheHitTokens())
                    .promptCacheMissTokens(usage.promptCacheMissTokens())
                    .completionTokens(usage.completionTokens())
                    .reasoningTokens(usage.reasoningTokens());
        }
        AiUsageLog saved = repository.save(log.build());
        warnIfReasoningReported(usage);
        warnIfRecordedAtWorstCase(outcome, errorCategory, call.inputChars(), usd, cost);
        return saved;
    }

    // Yalnızca kategori ve sayılar: hangi çağrının, kimin ya da hangi dersin olduğu yazılmaz.
    private static void warnIfRecordedAtWorstCase(AiUsageOutcome outcome, String errorCategory, int inputChars,
                                                  BigDecimal usd, CostEstimate cost) {
        if (!cost.usageReported()) {
            log.warn("AI Tutor provider usage was not reported (outcome {}, category {}); "
                    + "recorded at the worst-case estimate of {} USD for {} input chars",
                    outcome, errorCategory == null ? "none" : errorCategory, usd.toPlainString(), inputChars);
        }
    }

    // Yalnızca sayılar: soru, cevap, konu ya da kullanıcı bilgisi bu satıra girmez.
    private static void warnIfReasoningReported(TutorUsage usage) {
        if (usage != null && usage.reasoningTokens() != null && usage.reasoningTokens() > 0) {
            log.warn("AI Tutor provider reported {} reasoning tokens ({} completion tokens) "
                    + "although thinking is disabled; cost is still priced from completion tokens only",
                    usage.reasoningTokens(), usage.completionTokens());
        }
    }

    /** Tahminin kendi içinde ve kullanım verisiyle tutarlı olduğunu doğrular; 6 ondalıklı tutarı döndürür. */
    private static BigDecimal checkedCost(CostEstimate cost, TutorUsage usage) {
        Objects.requireNonNull(cost, "cost");
        if (cost.usd() == null || cost.usd().signum() < 0) {
            throw new IllegalArgumentException("cost must be a non-negative amount");
        }
        if (cost.period() == null || cost.pricingVersion() == null || cost.pricingVersion().isBlank()) {
            throw new IllegalArgumentException("cost must carry its pricing period and version");
        }
        if (cost.usageReported()) {
            if (!AiCostCalculator.isValid(usage)) {
                throw new IllegalArgumentException("cost claims reported usage but usage is missing or invalid");
            }
            if (cost.period() == PricingPeriod.WORST_CASE) {
                throw new IllegalArgumentException("a reported-usage cost cannot be a worst-case estimate");
            }
        } else if (cost.period() != PricingPeriod.WORST_CASE) {
            throw new IllegalArgumentException("unknown usage must be recorded at the worst-case estimate");
        }
        try {
            // NUMERIC(12,6): daha fazla ondalık sessizce kırpılmasın.
            return cost.usd().setScale(AiCostCalculator.SCALE);
        } catch (ArithmeticException e) {
            throw new IllegalArgumentException("cost has more than " + AiCostCalculator.SCALE + " decimals");
        }
    }
}

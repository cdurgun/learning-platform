package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.service.ai.AiTutorGuard.DenialReason;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.temporal.TemporalAdjusters;
import java.util.Map;
import java.util.Objects;

/**
 * {@code ai_tutor_reservation} tablosu ve bütçe toplamları (V1151). Tüm bütçe/limit kararları
 * PostgreSQL'de, tek bir global transaction-seviyesi advisory lock altında verilir: kaç uygulama
 * örneği (Railway instance) çalışırsa çalışsın aynı veritabanını gördükleri için kontrol + yazma
 * adımları birbirine karışamaz. Bellekte hiçbir sayaç ya da kilit tutulmaz.
 *
 * <p>Kilit {@code pg_advisory_xact_lock}: transaction bitince (commit/rollback) Postgres onu
 * kendisi bırakır, bağlantı havuzuna kilitli bir bağlantı geri dönemez. Kilit altında yalnızca
 * birkaç kısa sorgu çalışır; sağlayıcı çağrısı ASLA bu transaction'ın içinde değildir.
 * {@code lock_timeout}/{@code statement_timeout} bir takılmanın istek iş parçacıklarını
 * süresiz bekletmesini önler; aşılırsa istek reddedilir (asla izin verilmez).</p>
 *
 * <p>Bütçe toplamı = {@code ai_usage_log}'daki tahminler + sonucu yazılmamış (ACTIVE ya da
 * EXPIRED) rezervasyonlar; ikisi TEK bir SQL ifadesiyle, aynı anlık görüntüden okunur. Pencereler
 * UTC gün ve ay başından itibarendir, üst sınır yoktur (saat farkı yüzünden "ileride" görünen bir
 * satır da sayılır: tahmin yüksek tarafta kalır).</p>
 */
@Component
public class AiReservationStore {

    /** "LFXAITUR": bu projede başka hiçbir advisory lock yok; anahtar yalnızca bütçe içindir. */
    static final long BUDGET_LOCK_KEY = 0x4C46_5841_4954_5552L;

    private static final String LOCK_TIMEOUT = "5s";
    private static final String STATEMENT_TIMEOUT = "10s";

    private final JdbcTemplate jdbc;
    private final TransactionTemplate transactions;

    public AiReservationStore(JdbcTemplate jdbc, PlatformTransactionManager transactionManager) {
        this.jdbc = jdbc;
        this.transactions = new TransactionTemplate(transactionManager);
    }

    /**
     * @param amount en kötü durum tutarı; bütçe kontrolü ve satır bu tutarla yapılır
     * @param ttl    satırın ACTIVE sayılacağı süre (sağlayıcı zaman aşımının üstünde)
     */
    public record Request(long userId,
                          Instant now,
                          int inputChars,
                          BigDecimal amount,
                          String pricingVersion,
                          Duration ttl,
                          int hourlyLimit,
                          BigDecimal dailyBudget,
                          BigDecimal monthlyBudget) {

        public Request {
            Objects.requireNonNull(now, "now");
            Objects.requireNonNull(amount, "amount");
            Objects.requireNonNull(pricingVersion, "pricingVersion");
            Objects.requireNonNull(ttl, "ttl");
            Objects.requireNonNull(dailyBudget, "dailyBudget");
            Objects.requireNonNull(monthlyBudget, "monthlyBudget");
            if (inputChars < 0 || amount.signum() < 0 || !ttl.isPositive() || hourlyLimit < 0) {
                throw new IllegalArgumentException("invalid reservation request");
            }
        }
    }

    /**
     * {@code reservationId != null} ise ayrıldı; {@code dayCommitted}/{@code monthCommitted} bu
     * isteğin tutarı EKLENMEDEN önceki toplamlardır (uyarı eşiği için). Değilse {@code rejection}.
     */
    public record Outcome(Long reservationId, DenialReason rejection,
                          BigDecimal dayCommitted, BigDecimal monthCommitted) {

        static Outcome rejected(DenialReason reason) {
            return new Outcome(null, reason, null, null);
        }

        public boolean reserved() {
            return reservationId != null;
        }
    }

    public Outcome reserve(Request request) {
        try {
            return transactions.execute(status -> reserveLocked(request));
        } catch (DuplicateKeyException e) {
            // Kilit altında olamaz; yine de kısmi indeks son savunma hattıdır.
            return Outcome.rejected(DenialReason.REQUEST_IN_FLIGHT);
        }
    }

    private Outcome reserveLocked(Request request) {
        lockInCurrentTransaction();
        LocalDateTime now = utc(request.now());

        // Süresi geçen açık rezervasyonlar EXPIRED olur: kullanıcının kilidi bırakılır ama tutarı
        // bütçede kalmaya devam eder (çağrı ücretlendirilmiş olabilir).
        jdbc.update("UPDATE ai_tutor_reservation SET status = 'EXPIRED', closed_at = ? "
                + "WHERE status = 'ACTIVE' AND expires_at <= ?", now, now);

        Integer active = jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation "
                + "WHERE user_id = ? AND status = 'ACTIVE'", Integer.class, request.userId());
        if (active != null && active > 0) {
            return Outcome.rejected(DenialReason.REQUEST_IN_FLIGHT);
        }

        Integer lastHour = jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation "
                        + "WHERE user_id = ? AND created_at > ? AND status <> 'RELEASED'",
                Integer.class, request.userId(), now.minusHours(1));
        if (lastHour == null || lastHour >= request.hourlyLimit()) {
            return Outcome.rejected(DenialReason.HOURLY_LIMIT_REACHED);
        }

        LocalDateTime dayStart = now.toLocalDate().atStartOfDay();
        LocalDateTime monthStart = now.toLocalDate().with(TemporalAdjusters.firstDayOfMonth()).atStartOfDay();
        Map<String, Object> totals = jdbc.queryForMap("""
                SELECT (SELECT COALESCE(SUM(estimated_cost_usd), 0) FROM ai_usage_log WHERE created_at >= ?)
                     + (SELECT COALESCE(SUM(reserved_usd), 0) FROM ai_tutor_reservation
                        WHERE created_at >= ? AND status IN ('ACTIVE', 'EXPIRED')) AS day_total,
                       (SELECT COALESCE(SUM(estimated_cost_usd), 0) FROM ai_usage_log WHERE created_at >= ?)
                     + (SELECT COALESCE(SUM(reserved_usd), 0) FROM ai_tutor_reservation
                        WHERE created_at >= ? AND status IN ('ACTIVE', 'EXPIRED')) AS month_total""",
                dayStart, dayStart, monthStart, monthStart);
        BigDecimal day = (BigDecimal) totals.get("day_total");
        BigDecimal month = (BigDecimal) totals.get("month_total");
        if (day.add(request.amount()).compareTo(request.dailyBudget()) > 0) {
            return Outcome.rejected(DenialReason.DAILY_BUDGET_EXHAUSTED);
        }
        if (month.add(request.amount()).compareTo(request.monthlyBudget()) > 0) {
            return Outcome.rejected(DenialReason.MONTHLY_BUDGET_EXHAUSTED);
        }

        Long id = jdbc.queryForObject("""
                INSERT INTO ai_tutor_reservation
                    (user_id, created_at, expires_at, input_chars, reserved_usd, pricing_version, status)
                VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE') RETURNING id""", Long.class,
                request.userId(), now, now.plus(request.ttl()), request.inputChars(), request.amount(),
                request.pricingVersion());
        return new Outcome(id, null, day, month);
    }

    /**
     * Çağıranın AÇIK transaction'ında bütçe kilidini alır (sonuç yazma, aynı kilit altında
     * yapılır). Transaction dışında çağrılırsa kilit hemen bırakılır, bu yüzden yalnızca bir
     * transaction içinden kullanılmalıdır.
     */
    void lockInCurrentTransaction() {
        jdbc.execute("SET LOCAL lock_timeout = '" + LOCK_TIMEOUT + "'");
        jdbc.execute("SET LOCAL statement_timeout = '" + STATEMENT_TIMEOUT + "'");
        jdbc.queryForObject("SELECT 1 FROM (SELECT pg_advisory_xact_lock(?)) AS budget_lock",
                Integer.class, BUDGET_LOCK_KEY);
    }

    /**
     * ACTIVE ya da EXPIRED bir rezervasyonu SETTLED yapar ve log satırına bağlar. Satır zaten
     * kapanmışsa (SETTLED/RELEASED) ya da başka bir kullanıcınınsa {@code false}.
     */
    boolean markSettled(long reservationId, long userId, long usageLogId, Instant now) {
        return jdbc.update("UPDATE ai_tutor_reservation SET status = 'SETTLED', closed_at = ?, usage_log_id = ? "
                        + "WHERE id = ? AND user_id = ? AND status IN ('ACTIVE', 'EXPIRED')",
                utc(now), usageLogId, reservationId, userId) == 1;
    }

    /** Sağlayıcıya KESİNLİKLE gönderilmemiş bir isteğin rezervasyonunu bırakır. */
    public boolean release(long reservationId, long userId, Instant now) {
        Boolean released = transactions.execute(status -> {
            lockInCurrentTransaction();
            return jdbc.update("UPDATE ai_tutor_reservation SET status = 'RELEASED', closed_at = ? "
                            + "WHERE id = ? AND user_id = ? AND status IN ('ACTIVE', 'EXPIRED')",
                    utc(now), reservationId, userId) == 1;
        });
        return Boolean.TRUE.equals(released);
    }

    private static LocalDateTime utc(Instant instant) {
        return LocalDateTime.ofInstant(instant, ZoneOffset.UTC);
    }
}

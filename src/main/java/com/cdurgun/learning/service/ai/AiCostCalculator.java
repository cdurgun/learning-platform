package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;

/**
 * Bir AI Tutor çağrısının TAHMİNİ maliyeti (USD). Sağlayıcının faturası DEĞİL: DeepSeek yanıtta
 * maliyet döndürmüyor, yalnızca token sayıları. Fiyatların tek kaynağı yapılandırmadır
 * ({@code ai.tutor.pricing.*}); burada hiçbir fiyat yazılı değil.
 *
 * <p><b>Para birimi ve yuvarlama:</b> USD. Bileşenler {@link BigDecimal} ile tam hesaplanır,
 * toplam bir kez {@link #SCALE} (6) ondalığa {@link RoundingMode#UP} ile yuvarlanır -- tahmin
 * hiçbir zaman aşağı yuvarlanmaz.</p>
 *
 * <p><b>Bilinmeyen maliyet asla sıfır değildir:</b> kullanım verisi yoksa ya da geçersizse
 * {@link #forCall} isteğin en kötü durum maliyetini döndürür ({@link #worstCase}).</p>
 *
 * <p><b>Yoğun saat:</b> yapılandırmadaki {@code peak-days} + {@code peak-hours-utc} pencereleri,
 * UTC. Çin resmî tatilleri yapılandırmada olmadığı için modellenmez (o günler yoğun sayılır,
 * tahmin yüksek kalır). Reasoning token'ları ayrıca fiyatlandırılmaz: fiyat sayfasında ayrı bir
 * kalemleri yok, faturalanan çıktı {@code completion_tokens}'tır.</p>
 */
public class AiCostCalculator {

    public static final String CURRENCY = "USD";
    public static final int SCALE = 6;

    private static final BigDecimal ONE_MILLION = BigDecimal.valueOf(1_000_000);

    private final AiTutorProperties.Pricing pricing;
    private final BigDecimal worstCaseTokensPerChar;
    private final int maxOutputTokens;

    public AiCostCalculator(AiTutorProperties properties) {
        this.pricing = properties.pricing();
        this.worstCaseTokensPerChar = properties.budget().worstCaseTokensPerChar();
        this.maxOutputTokens = properties.limits().maxOutputTokens();
    }

    /**
     * Tamamlanan (ya da başarısız olan) bir çağrının maliyeti. Kullanım verisi geçerliyse
     * sağlayıcının token sayılarıyla, {@code at} anının fiyat dönemine göre; değilse
     * {@code inputChars} için en kötü durum.
     *
     * @param at isteğin gönderildiği an
     * @param inputChars modele gönderilen tüm mesajların toplam karakter sayısı
     */
    public CostEstimate forCall(TutorUsage usage, int inputChars, Instant at) {
        if (!isValid(usage)) {
            return worstCase(inputChars);
        }
        PricingPeriod period = isPeak(at) ? PricingPeriod.PEAK : PricingPeriod.OFF_PEAK;
        AiTutorProperties.Rates rates = period == PricingPeriod.PEAK ? pricing.peak() : pricing.offPeak();

        BigDecimal cost = perMillion(usage.promptCacheHitTokens(), rates.cacheHitUsdPerMillion())
                .add(perMillion(usage.promptCacheMissTokens(), rates.cacheMissUsdPerMillion()))
                .add(perMillion(usage.completionTokens(), rates.outputUsdPerMillion()));
        return new CostEstimate(round(cost), true, period, pricing.version());
    }

    /**
     * Kullanımı bilinmeyen bir isteğin üst sınırı: girdinin tamamı önbellek dışı, çıktı
     * {@code max-output-tokens}'ın tamamı, her kalem için iki dönemin PAHALI olanının fiyatıyla.
     * Karakter -> token çevirisi {@code worst-case-tokens-per-char} ile yapılır ve yukarı yuvarlanır.
     */
    public CostEstimate worstCase(int inputChars) {
        if (inputChars < 0) {
            throw new IllegalArgumentException("inputChars must not be negative");
        }
        BigDecimal inputTokens = worstCaseTokensPerChar.multiply(BigDecimal.valueOf(inputChars))
                .setScale(0, RoundingMode.UP);
        BigDecimal missRate = pricing.peak().cacheMissUsdPerMillion().max(pricing.offPeak().cacheMissUsdPerMillion());
        BigDecimal outputRate = pricing.peak().outputUsdPerMillion().max(pricing.offPeak().outputUsdPerMillion());

        BigDecimal cost = inputTokens.multiply(missRate).divide(ONE_MILLION)
                .add(perMillion(maxOutputTokens, outputRate));
        return new CostEstimate(round(cost), false, PricingPeriod.WORST_CASE, pricing.version());
    }

    /** {@code at} anı UTC'de yapılandırılmış bir yoğun gün + saat penceresine düşüyor mu ({@code [start, end)}). */
    public boolean isPeak(Instant at) {
        ZonedDateTime utc = at.atZone(ZoneOffset.UTC);
        if (!pricing.peakDays().contains(utc.getDayOfWeek())) {
            return false;
        }
        int hour = utc.getHour();
        return pricing.peakHoursUtc().stream().anyMatch(w -> hour >= w.start() && hour < w.end());
    }

    /** Negatif sayılar sağlayıcı verisi olarak güvenilmez; böyle bir kullanım "bilinmiyor" sayılır. */
    static boolean isValid(TutorUsage usage) {
        return usage != null
                && usage.promptCacheHitTokens() >= 0
                && usage.promptCacheMissTokens() >= 0
                && usage.completionTokens() >= 0
                && (usage.reasoningTokens() == null || usage.reasoningTokens() >= 0);
    }

    private static BigDecimal perMillion(long tokens, BigDecimal usdPerMillion) {
        // Bölüm ONE_MILLION'a olduğu için ondalık açılımı her zaman sonludur: kesin, yuvarlamasız.
        return BigDecimal.valueOf(tokens).multiply(usdPerMillion).divide(ONE_MILLION);
    }

    private static BigDecimal round(BigDecimal usd) {
        return usd.setScale(SCALE, RoundingMode.UP);
    }

    public enum PricingPeriod {
        OFF_PEAK, PEAK, WORST_CASE
    }

    /**
     * @param usd tahmini maliyet, USD, {@value #SCALE} ondalık
     * @param usageReported {@code false}: token sayıları bilinmiyordu, {@code usd} en kötü durumdur
     * @param pricingVersion hesapta kullanılan {@code pricing.version}
     */
    public record CostEstimate(BigDecimal usd, boolean usageReported, PricingPeriod period, String pricingVersion) {
    }
}

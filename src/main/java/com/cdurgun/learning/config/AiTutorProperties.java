package com.cdurgun.learning.config;

import jakarta.validation.Valid;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import org.hibernate.validator.constraints.time.DurationMax;
import org.hibernate.validator.constraints.time.DurationMin;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.Duration;
import java.util.List;

/**
 * DeepSeek AI Tutor ayarları ({@code ai.tutor.*}, bkz. {@code docs/deepseek-ai-tutor-plan.md}).
 * Tüm limitler, bütçeler ve fiyatlar burada -- iş mantığında hiçbir sayı sabit yazılmaz.
 *
 * <p><b>Varsayılan KAPALI:</b> özellik yalnızca {@code enabled=true} VE bir API anahtarı
 * verildiğinde kullanılabilir ({@link #isUsable()}); bu bir yetki DEĞİL, yalnızca "açık mı"
 * kararıdır -- kimin kullanabileceği hâlâ ADMIN rolüyle belirlenir. Anahtar eksikse uygulama
 * yine açılır (sitenin geri kalanı tutora bağımlı olmamalı), özellik yalnızca devre dışı kalır.</p>
 *
 * <p><b>Bilerek bir {@code @ConfigurationProperties} bean'i DEĞİL:</b> o yol, doğrulama hatasında
 * TÜM uygulama bağlamını düşürür. Bunun yerine {@link AiTutorSettings#load} yalnızca
 * {@code ai.tutor} önekini aynı Binder + Bean Validation ile bağlar; geçersiz bir değer
 * LearnForgeX'i durdurmaz, yalnızca tutoru kapalı tutar (fail closed). Bu sınıfa
 * {@code @ConfigurationProperties} eklenmemeli, {@code @ConfigurationPropertiesScan} ile de
 * taranmamalı.</p>
 *
 * <p>API anahtarı {@link #toString()}'te asla görünmez. Fiyatlar DeepSeek'in kendi fiyat
 * sayfasından (USD / 1M token) yapılandırmaya kopyalanır; sayfa değişirse yalnızca
 * yapılandırma ve {@code pricing.version} güncellenir.</p>
 */
public record AiTutorProperties(
        boolean enabled,
        String apiKey,
        // Üretimde yalnızca https; düz http yalnızca testlerin yerel sahte sunucusu için.
        @NotBlank @Pattern(regexp = "https://\\S+|http://(localhost|127\\.0\\.0\\.1)(:\\d+)?(/\\S*)?")
        String baseUrl,
        @NotBlank String model,
        @NotNull @Valid Timeouts timeouts,
        @NotNull @Valid Limits limits,
        @NotNull @Valid Budget budget,
        @NotNull @Valid Pricing pricing) {

    public boolean hasApiKey() {
        return apiKey != null && !apiKey.isBlank();
    }

    /** Bayrak açık VE anahtar var. Yalnızca o zaman sağlayıcıya istek gönderilebilir. */
    public boolean isUsable() {
        return enabled && hasApiKey();
    }

    @Override
    public String toString() {
        return "AiTutorProperties[enabled=" + enabled
                + ", apiKey=" + (hasApiKey() ? "****" : "<none>")
                + ", baseUrl=" + baseUrl
                + ", model=" + model
                + ", timeouts=" + timeouts
                + ", limits=" + limits
                + ", budget=" + budget
                + ", pricing=" + pricing + "]";
    }

    /**
     * {@code total}, isteğin TAMAMI için üst sınırdır, yalnızca bir okuma beklemesi değil:
     * DeepSeek yük altında bağlantıyı boş satırlar göndererek 10 dakikaya kadar açık tutabiliyor.
     */
    public record Timeouts(
            @NotNull @DurationMin(millis = 1) Duration connect,
            @NotNull @DurationMin(millis = 1) @DurationMax(minutes = 5) Duration total) {
    }

    /**
     * {@code maxOutputTokens} bilinçli olarak 8192 ile sınırlı (DeepSeek 393216'ya izin veriyor):
     * yanlış bir değerin tek bir istekte maliyeti katlamasını engeller.
     *
     * <p>Karakter sınırları Java {@code String} uzunluğudur, token DEĞİL. {@code maxHistoryChars}
     * bir konuşmanın session'da tutulan tüm soru + cevap metinlerinin toplamıdır; en az bir tam
     * turun (en uzun soru + saklanan en uzun cevap) sığması zorunludur.</p>
     */
    public record Limits(
            @Min(1) @Max(8192) int maxOutputTokens,
            @Min(1) int maxMessageChars,
            @Min(0) int maxContextChars,
            @Min(1) int maxAnswerCharsStored,
            @Min(1) int historyTurns,
            @Min(1) int maxConversationsPerSession,
            @Min(1) int requestsPerUserPerHour,
            @Min(1) int maxHistoryChars) {

        @AssertTrue(message = "max-history-chars must hold at least one full turn "
                + "(max-message-chars + max-answer-chars-stored)")
        public boolean isHistoryHoldingOneTurn() {
            return (long) maxHistoryChars >= (long) maxMessageChars + maxAnswerCharsStored;
        }
    }

    /**
     * Uygulama seviyesindeki bütçe, sağlayıcının faturası DEĞİL, kendi tahminimizdir.
     * {@code worstCaseTokensPerChar}, bir isteğin en kötü durum maliyeti ayrılırken karakter
     * sayısını token'a çevirmek için kullanılan, bilerek yüksek tutulan oran.
     */
    public record Budget(
            @NotNull @DecimalMin("0.00") BigDecimal dailyUsd,
            @NotNull @DecimalMin("0.00") BigDecimal monthlyUsd,
            @NotNull @DecimalMin("0.00") @DecimalMax("1.00") BigDecimal alertRatio,
            @NotNull @DecimalMin(value = "0.00", inclusive = false) @DecimalMax("4.00")
            BigDecimal worstCaseTokensPerChar) {

        @AssertTrue(message = "daily-usd must not exceed monthly-usd")
        public boolean isDailyWithinMonthly() {
            return dailyUsd == null || monthlyUsd == null || dailyUsd.compareTo(monthlyUsd) <= 0;
        }
    }

    /** Peak saatleri UTC'dir; Çin resmî tatilleri modellenmez (tahmin yüksek tarafta kalır). */
    public record Pricing(
            @NotBlank String version,
            @NotNull @Valid Rates offPeak,
            @NotNull @Valid Rates peak,
            @NotNull List<DayOfWeek> peakDays,
            @NotNull List<@Valid HourWindow> peakHoursUtc) {
    }

    /** USD / 1M token. */
    public record Rates(
            @NotNull @DecimalMin("0.00") BigDecimal cacheHitUsdPerMillion,
            @NotNull @DecimalMin("0.00") BigDecimal cacheMissUsdPerMillion,
            @NotNull @DecimalMin("0.00") BigDecimal outputUsdPerMillion) {
    }

    /** Tam saat aralığı, {@code [start, end)}: 1-4, 01:00'dan 04:00'e kadar demektir. */
    public record HourWindow(@Min(0) @Max(23) int start, @Min(1) @Max(24) int end) {

        @AssertTrue(message = "peak hour window start must be before end")
        public boolean isOrdered() {
            return start < end;
        }
    }
}

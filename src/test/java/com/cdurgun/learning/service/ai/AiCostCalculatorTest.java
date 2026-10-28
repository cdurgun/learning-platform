package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import com.cdurgun.learning.service.ai.AiCostCalculator.CostEstimate;
import com.cdurgun.learning.service.ai.AiCostCalculator.PricingPeriod;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * {@link AiCostCalculator}. Fiyatlar {@code application.yml}'deki varsayılanlarla aynı
 * (deepseek-flash, 2026-10-27); beklenen tutarlar elle hesaplanmış kesin değerlerdir.
 * 2026-10-26 Pazartesi, 2026-10-30 Cuma, 2026-10-31 Cumartesi.
 */
class AiCostCalculatorTest {

    private static final AiTutorProperties.Rates OFF_PEAK = rates("0.003", "0.15", "0.60");
    private static final AiTutorProperties.Rates PEAK = rates("0.006", "0.30", "1.20");
    private static final List<AiTutorProperties.HourWindow> PEAK_HOURS = List.of(
            new AiTutorProperties.HourWindow(1, 4), new AiTutorProperties.HourWindow(6, 10));
    private static final List<DayOfWeek> WEEKDAYS = List.of(DayOfWeek.MONDAY, DayOfWeek.TUESDAY,
            DayOfWeek.WEDNESDAY, DayOfWeek.THURSDAY, DayOfWeek.FRIDAY);

    private static final Instant MONDAY_NOON = Instant.parse("2026-10-26T12:00:00Z");
    private static final Instant MONDAY_PEAK = Instant.parse("2026-10-26T07:00:00Z");

    private final AiCostCalculator calculator = calculator("v-test", OFF_PEAK, PEAK, WEEKDAYS, PEAK_HOURS);

    private static AiTutorProperties.Rates rates(String hit, String miss, String output) {
        return new AiTutorProperties.Rates(new BigDecimal(hit), new BigDecimal(miss), new BigDecimal(output));
    }

    private static AiCostCalculator calculator(String version, AiTutorProperties.Rates offPeak,
                                               AiTutorProperties.Rates peak, List<DayOfWeek> days,
                                               List<AiTutorProperties.HourWindow> hours) {
        return new AiCostCalculator(new AiTutorProperties(false, null, "https://api.deepseek.com", "deepseek-flash",
                new AiTutorProperties.Timeouts(Duration.ofSeconds(5), Duration.ofSeconds(60)),
                new AiTutorProperties.Limits(1500, 4000, 60000, 8000, 6, 5, 30, 24000),
                new AiTutorProperties.Budget(new BigDecimal("1.00"), new BigDecimal("10.00"),
                        new BigDecimal("0.80"), new BigDecimal("0.5")),
                new AiTutorProperties.Pricing(version, offPeak, peak, days, hours)));
    }

    private static TutorUsage usage(int hit, int miss, int completion) {
        return new TutorUsage(hit, miss, completion, 0);
    }

    // --- reported usage ---

    @Test
    void reportedUsageOffPeakIsPricedPerComponent() {
        // 4000 x 0.003 + 8000 x 0.15 + 1000 x 0.60, per 1M = 0.000012 + 0.0012 + 0.0006
        CostEstimate estimate = calculator.forCall(usage(4000, 8000, 1000), 50_000, MONDAY_NOON);

        assertThat(estimate.usd()).isEqualTo(new BigDecimal("0.001812"));
        assertThat(estimate.usageReported()).isTrue();
        assertThat(estimate.period()).isEqualTo(PricingPeriod.OFF_PEAK);
        assertThat(estimate.pricingVersion()).isEqualTo("v-test");
    }

    @Test
    void reportedUsageAtPeakUsesPeakRates() {
        // 4000 x 0.006 + 8000 x 0.30 + 1000 x 1.20, per 1M = 0.000024 + 0.0024 + 0.0012
        CostEstimate estimate = calculator.forCall(usage(4000, 8000, 1000), 50_000, MONDAY_PEAK);

        assertThat(estimate.usd()).isEqualTo(new BigDecimal("0.003624"));
        assertThat(estimate.period()).isEqualTo(PricingPeriod.PEAK);
    }

    @Test
    void cacheHitsAndMissesArePricedSeparately() {
        assertThat(calculator.forCall(usage(1_000_000, 0, 0), 0, MONDAY_NOON).usd())
                .isEqualTo(new BigDecimal("0.003000"));
        assertThat(calculator.forCall(usage(0, 1_000_000, 0), 0, MONDAY_NOON).usd())
                .isEqualTo(new BigDecimal("0.150000"));
        assertThat(calculator.forCall(usage(0, 0, 1_000_000), 0, MONDAY_NOON).usd())
                .isEqualTo(new BigDecimal("0.600000"));
    }

    @Test
    void reasoningTokensAreNotPricedOnTopOfCompletionTokens() {
        TutorUsage withReasoning = new TutorUsage(0, 1000, 1000, 400);
        assertThat(calculator.forCall(withReasoning, 0, MONDAY_NOON).usd())
                .isEqualTo(calculator.forCall(usage(0, 1000, 1000), 0, MONDAY_NOON).usd());
    }

    @Test
    void reportedZeroTokensCostZero() {
        CostEstimate estimate = calculator.forCall(usage(0, 0, 0), 10_000, MONDAY_NOON);
        assertThat(estimate.usd()).isEqualTo(new BigDecimal("0.000000"));
        assertThat(estimate.usageReported()).isTrue();
    }

    @Test
    void veryLargeTokenCountsDoNotOverflow() {
        int max = Integer.MAX_VALUE;
        assertThat(calculator.forCall(usage(max, max, max), 0, MONDAY_PEAK).usd())
                .isEqualTo(new BigDecimal("3234.110373"));
        assertThat(calculator.forCall(usage(max, max, max), 0, MONDAY_NOON).usd())
                .isEqualTo(new BigDecimal("1617.055187"));
    }

    // --- rounding ---

    @Test
    void resultsAlwaysHaveSixDecimalsInUsd() {
        assertThat(AiCostCalculator.CURRENCY).isEqualTo("USD");
        assertThat(calculator.forCall(usage(1, 2, 3), 0, MONDAY_NOON).usd().scale()).isEqualTo(6);
        assertThat(calculator.worstCase(7).usd().scale()).isEqualTo(6);
    }

    @Test
    void fractionsOfAMicroDollarRoundUpNeverDown() {
        // 1 x 0.003 / 1M = 0.000000003 USD
        assertThat(calculator.forCall(usage(1, 0, 0), 0, MONDAY_NOON).usd()).isEqualTo(new BigDecimal("0.000001"));
        // 1001 x 0.60 / 1M = 0.0006006 USD
        assertThat(calculator.forCall(usage(0, 0, 1001), 0, MONDAY_NOON).usd()).isEqualTo(new BigDecimal("0.000601"));
    }

    @Test
    void exactValuesAreNotInflatedByRounding() {
        // 2000 x 0.60 / 1M = 0.0012 exactly
        assertThat(calculator.forCall(usage(0, 0, 2000), 0, MONDAY_NOON).usd()).isEqualTo(new BigDecimal("0.001200"));
    }

    // --- peak windows (as configured: Mon-Fri, 01-04 and 06-10 UTC, end exclusive) ---

    @ParameterizedTest
    @CsvSource({
            "2026-10-26T00:59:59Z, false",
            "2026-10-26T01:00:00Z, true",
            "2026-10-26T03:59:59Z, true",
            "2026-10-26T04:00:00Z, false",
            "2026-10-26T05:59:59Z, false",
            "2026-10-26T06:00:00Z, true",
            "2026-10-26T09:59:59Z, true",
            "2026-10-26T10:00:00Z, false",
            "2026-10-30T07:00:00Z, true",
            "2026-10-31T07:00:00Z, false",
            "2026-11-01T02:00:00Z, false"
    })
    void peakWindowsFollowTheConfigurationInUtc(String at, boolean peak) {
        assertThat(calculator.isPeak(Instant.parse(at))).isEqualTo(peak);
    }

    @Test
    void localTimeZonesDoNotMatterOnlyTheInstant() {
        // 09:30 in Istanbul (UTC+3) is 06:30 UTC: peak.
        assertThat(calculator.isPeak(Instant.parse("2026-10-26T09:30:00+03:00"))).isTrue();
    }

    @Test
    void withoutConfiguredPeakWindowsEverythingIsOffPeak() {
        AiCostCalculator noPeak = calculator("v", OFF_PEAK, PEAK, List.of(), List.of());
        assertThat(noPeak.forCall(usage(0, 1000, 0), 0, MONDAY_PEAK).period()).isEqualTo(PricingPeriod.OFF_PEAK);
    }

    // --- price changes come from configuration ---

    @Test
    void changedPricesInConfigurationChangeTheResult() {
        AiCostCalculator newPrices = calculator("v-2027", rates("0.01", "0.50", "2.00"), PEAK, WEEKDAYS, PEAK_HOURS);

        CostEstimate estimate = newPrices.forCall(usage(4000, 8000, 1000), 0, MONDAY_NOON);

        // 4000 x 0.01 + 8000 x 0.50 + 1000 x 2.00, per 1M = 0.00004 + 0.004 + 0.002
        assertThat(estimate.usd()).isEqualTo(new BigDecimal("0.006040"));
        assertThat(estimate.pricingVersion()).isEqualTo("v-2027");
    }

    // --- unknown or invalid usage is never zero ---

    @Test
    void missingUsageFallsBackToTheWorstCase() {
        // 138000 chars x 0.5 = 69000 tokens x 0.30 = 0.0207; 1500 x 1.20 = 0.0018
        CostEstimate estimate = calculator.forCall(null, 138_000, MONDAY_NOON);

        assertThat(estimate.usd()).isEqualTo(new BigDecimal("0.022500"));
        assertThat(estimate.usageReported()).isFalse();
        assertThat(estimate.period()).isEqualTo(PricingPeriod.WORST_CASE);
    }

    @Test
    void negativeUsageIsTreatedAsUnknown() {
        assertThat(calculator.forCall(new TutorUsage(0, -5, 10, null), 1000, MONDAY_NOON).usageReported()).isFalse();
        assertThat(calculator.forCall(new TutorUsage(0, 5, 10, -1), 1000, MONDAY_NOON).usageReported()).isFalse();
    }

    @Test
    void worstCaseWithNoInputStillChargesTheFullOutput() {
        assertThat(calculator.worstCase(0).usd()).isEqualTo(new BigDecimal("0.001800"));
        assertThat(calculator.forCall(null, 0, MONDAY_NOON).usd()).isPositive();
    }

    @Test
    void worstCaseRoundsInputTokensUp() {
        // 3 chars x 0.5 = 1.5 -> 2 tokens x 0.30 / 1M = 0.0000006; + 0.0018
        assertThat(calculator.worstCase(3).usd()).isEqualTo(new BigDecimal("0.001801"));
    }

    @Test
    void worstCaseUsesTheHigherRateOfEitherPeriod() {
        // Unusual configuration: off-peak priced above peak. The worst case must still take the higher one.
        AiCostCalculator inverted = calculator("v", rates("0.003", "1.00", "3.00"), PEAK, WEEKDAYS, PEAK_HOURS);
        // 1000 tokens x 1.00 = 0.001; 1500 x 3.00 = 0.0045
        assertThat(inverted.worstCase(2000).usd()).isEqualTo(new BigDecimal("0.005500"));
    }

    @Test
    void worstCaseIsNeverBelowAReportedCostWithinTheSameLimits() {
        int inputChars = 20_000; // at most 10000 input tokens under the worst-case ratio
        CostEstimate reported = calculator.forCall(usage(0, 10_000, 1500), inputChars, MONDAY_PEAK);
        assertThat(calculator.worstCase(inputChars).usd()).isGreaterThanOrEqualTo(reported.usd());
    }

    @Test
    void negativeInputSizeIsRejected() {
        assertThatThrownBy(() -> calculator.worstCase(-1)).isInstanceOf(IllegalArgumentException.class);
    }
}

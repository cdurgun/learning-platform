package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorProperties;
import com.cdurgun.learning.domain.AiFeature;
import com.cdurgun.learning.domain.AiUsageLog;
import com.cdurgun.learning.domain.AiUsageOutcome;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.AiUsageLogRepository;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.AiCostCalculator.CostEstimate;
import com.cdurgun.learning.service.ai.AiCostCalculator.PricingPeriod;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * {@link AiUsageRecorder}, gerçek Postgres'e karşı. Maliyetleri gerçek {@link AiCostCalculator}
 * üretir (fiyatlar {@code application.yml} varsayılanlarıyla aynı); kaydedici yalnızca tutarlılığı
 * doğrulayıp yazar. Her test sonunda geri alınır.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AiUsageRecorderTest {

    private static final Instant MONDAY_PEAK_ISTANBUL = Instant.parse("2026-10-26T10:00:00+03:00"); // 07:00 UTC

    @Autowired
    private AiUsageRecorder recorder;
    @Autowired
    private AiUsageLogRepository repository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EntityManager entityManager;

    /** application.yml'deki fiyatlar: Pazartesi 06-10 UTC yoğun saat. */
    private final AiCostCalculator calculator = new AiCostCalculator(new AiTutorProperties(false, null,
            "https://api.deepseek.com", "deepseek-flash",
            new AiTutorProperties.Timeouts(Duration.ofSeconds(5), Duration.ofSeconds(60)),
            new AiTutorProperties.Limits(1500, 4000, 60000, 8000, 6, 5, 30, 24000),
            new AiTutorProperties.Budget(new BigDecimal("1.00"), new BigDecimal("10.00"),
                    new BigDecimal("0.80"), new BigDecimal("0.5")),
            new AiTutorProperties.Pricing("deepseek-flash-2026-10-27",
                    new AiTutorProperties.Rates(new BigDecimal("0.003"), new BigDecimal("0.15"), new BigDecimal("0.60")),
                    new AiTutorProperties.Rates(new BigDecimal("0.006"), new BigDecimal("0.30"), new BigDecimal("1.20")),
                    List.of(DayOfWeek.MONDAY), List.of(new AiTutorProperties.HourWindow(6, 10)))));

    private Long userId;

    @BeforeEach
    void createUser() {
        userId = userRepository.save(User.builder()
                .email("ai-recorder-" + UUID.randomUUID() + "@example.com")
                .passwordHash("not-a-real-hash")
                .displayName("AI recorder test")
                .role(Role.ADMIN)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build()).getId();
    }

    private AiUsageRecorder.Call call(int inputChars) {
        return new AiUsageRecorder.Call(userId, AiFeature.TUTOR, "deepseek-flash", "enum", Language.EN,
                MONDAY_PEAK_ISTANBUL, Duration.ofMillis(1834), inputChars, 4200);
    }

    private AiUsageLog reload(AiUsageLog saved) {
        entityManager.flush();
        entityManager.clear();
        return repository.findById(saved.getId()).orElseThrow();
    }

    @Test
    void successRecordsProviderTokensAndTheCalculatorCost() {
        TutorUsage usage = new TutorUsage(4000, 8000, 1000, 0);
        CostEstimate cost = calculator.forCall(usage, 50_000, MONDAY_PEAK_ISTANBUL);
        TutorCompletion completion = new TutorCompletion("answer text", true, "deepseek-flash", usage);

        AiUsageLog log = reload(recorder.recordSuccess(call(50_000), completion, cost));

        assertThat(log.getOutcome()).isEqualTo(AiUsageOutcome.SUCCESS);
        assertThat(log.getErrorCategory()).isNull();
        assertThat(log.isTruncated()).isTrue();
        assertThat(log.isUsageReported()).isTrue();
        assertThat(log.getPromptCacheHitTokens()).isEqualTo(4000);
        assertThat(log.getPromptCacheMissTokens()).isEqualTo(8000);
        assertThat(log.getCompletionTokens()).isEqualTo(1000);
        assertThat(log.getReasoningTokens()).isZero();
        assertThat(log.getEstimatedCostUsd()).isEqualTo(new BigDecimal("0.003624"));
        assertThat(log.getPricingPeriod()).isEqualTo("PEAK");
        assertThat(log.getPricingVersion()).isEqualTo("deepseek-flash-2026-10-27");
        assertThat(log.getDurationMs()).isEqualTo(1834);
        assertThat(log.getInputChars()).isEqualTo(50_000);
        assertThat(log.getContextChars()).isEqualTo(4200);
        assertThat(log.getLanguage()).isEqualTo(Language.EN);
        assertThat(log.getUserId()).isEqualTo(userId);
    }

    @Test
    void createdAtIsStoredInUtcRegardlessOfTheCallerZone() {
        TutorUsage usage = new TutorUsage(0, 10, 10, null);
        AiUsageLog log = reload(recorder.recordSuccess(call(20),
                new TutorCompletion("a", false, "deepseek-flash", usage),
                calculator.forCall(usage, 20, MONDAY_PEAK_ISTANBUL)));

        assertThat(log.getCreatedAt()).isEqualTo(LocalDateTime.of(2026, 10, 26, 7, 0));
    }

    @Test
    void failureWithReportedUsageKeepsTokensAndCategory() {
        TutorUsage usage = new TutorUsage(0, 700, 20, null);
        AiProviderException failure = new AiProviderException(AiErrorCategory.CONTENT_FILTERED, 200, usage, null);

        AiUsageLog log = reload(recorder.recordFailure(call(1400), failure,
                calculator.forCall(failure.getUsage(), 1400, MONDAY_PEAK_ISTANBUL)));

        assertThat(log.getOutcome()).isEqualTo(AiUsageOutcome.ERROR);
        assertThat(log.getErrorCategory()).isEqualTo("CONTENT_FILTERED");
        assertThat(log.isUsageReported()).isTrue();
        assertThat(log.getCompletionTokens()).isEqualTo(20);
        assertThat(log.isTruncated()).isFalse();
    }

    @Test
    void failureWithUnknownUsageIsRecordedAtTheWorstCaseNeverZero() {
        AiProviderException timeout = new AiProviderException(AiErrorCategory.TIMEOUT, null);

        AiUsageLog log = reload(recorder.recordFailure(call(138_000), timeout,
                calculator.forCall(timeout.getUsage(), 138_000, MONDAY_PEAK_ISTANBUL)));

        assertThat(log.isUsageReported()).isFalse();
        assertThat(log.getPromptCacheHitTokens()).isNull();
        assertThat(log.getPromptCacheMissTokens()).isNull();
        assertThat(log.getCompletionTokens()).isNull();
        assertThat(log.getEstimatedCostUsd()).isEqualTo(new BigDecimal("0.022500"));
        assertThat(log.getPricingPeriod()).isEqualTo("WORST_CASE");
    }

    @Test
    void invalidProviderUsageIsNotStoredAsTokens() {
        TutorUsage negative = new TutorUsage(0, -1, 5, null);
        AiProviderException failure = new AiProviderException(AiErrorCategory.PROVIDER_ERROR, 200, negative, null);

        AiUsageLog log = reload(recorder.recordFailure(call(100), failure,
                calculator.forCall(negative, 100, MONDAY_PEAK_ISTANBUL)));

        assertThat(log.isUsageReported()).isFalse();
        assertThat(log.getCompletionTokens()).isNull();
        assertThat(log.getEstimatedCostUsd()).isPositive();
    }

    // --- inconsistent input is a programming error and writes nothing ---

    @Test
    void reportedCostWithoutUsageIsRejected() {
        CostEstimate claimsReported = new CostEstimate(new BigDecimal("0.000100"), true, PricingPeriod.PEAK, "v");
        assertRejected(() -> recorder.recordSuccess(call(10),
                new TutorCompletion("a", false, "deepseek-flash", null), claimsReported));
    }

    @Test
    void unknownUsageAtANonWorstCasePeriodIsRejected() {
        CostEstimate wrong = new CostEstimate(new BigDecimal("0.000100"), false, PricingPeriod.OFF_PEAK, "v");
        assertRejected(() -> recorder.recordFailure(call(10),
                new AiProviderException(AiErrorCategory.TIMEOUT, null), wrong));
    }

    @Test
    void reportedUsageAtWorstCasePeriodIsRejected() {
        TutorUsage usage = new TutorUsage(0, 1, 1, null);
        CostEstimate wrong = new CostEstimate(new BigDecimal("0.000100"), true, PricingPeriod.WORST_CASE, "v");
        assertRejected(() -> recorder.recordSuccess(call(10),
                new TutorCompletion("a", false, "deepseek-flash", usage), wrong));
    }

    @Test
    void negativeOrOverPreciseCostsAreRejected() {
        AiProviderException timeout = new AiProviderException(AiErrorCategory.TIMEOUT, null);
        assertRejected(() -> recorder.recordFailure(call(10), timeout,
                new CostEstimate(new BigDecimal("-0.000001"), false, PricingPeriod.WORST_CASE, "v")));
        assertRejected(() -> recorder.recordFailure(call(10), timeout,
                new CostEstimate(new BigDecimal("0.0000001"), false, PricingPeriod.WORST_CASE, "v")));
    }

    @Test
    void missingCostIsRejectedAndWritesNothing() {
        long before = repository.count();
        assertThatThrownBy(() -> recorder.recordFailure(call(10),
                new AiProviderException(AiErrorCategory.TIMEOUT, null), null))
                .isInstanceOf(NullPointerException.class);
        assertThat(repository.count()).isEqualTo(before);
    }

    @Test
    void disabledIsNeverRecordedBecauseNoCallWasMade() {
        assertRejected(() -> recorder.recordFailure(call(10),
                new AiProviderException(AiErrorCategory.DISABLED, null), calculator.worstCase(10)));
    }

    @Test
    void callRejectsMissingUserAndNegativeSizes() {
        assertThatThrownBy(() -> new AiUsageRecorder.Call(null, AiFeature.TUTOR, "m", null, null,
                Instant.now(), Duration.ZERO, 0, null)).isInstanceOf(NullPointerException.class);
        assertThatThrownBy(() -> new AiUsageRecorder.Call(userId, AiFeature.TUTOR, "m", null, null,
                Instant.now(), Duration.ZERO, -1, null)).isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> new AiUsageRecorder.Call(userId, AiFeature.TUTOR, "m", null, null,
                Instant.now(), Duration.ofMillis(-1), 0, null)).isInstanceOf(IllegalArgumentException.class);
    }

    private void assertRejected(Runnable call) {
        long before = repository.count();
        assertThatThrownBy(call::run).isInstanceOf(IllegalArgumentException.class);
        assertThat(repository.count()).isEqualTo(before);
    }
}

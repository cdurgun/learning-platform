package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.AiFeature;
import com.cdurgun.learning.domain.AiUsageLog;
import com.cdurgun.learning.domain.AiUsageOutcome;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * V1150 ({@code ai_usage_log}) gerçek Postgres şemasında: Flyway'in uyguladığı tablo, entity
 * eşlemesi ({@code ddl-auto: validate} bağlam açılırken zaten doğruluyor), CHECK kısıtları,
 * {@code ON DELETE SET NULL} ve repository toplamı. {@code @Transactional}: her test sonunda
 * geri alınır. Bir kısıt ihlali Postgres işlemini iptal ettiği için her ihlal testi tek bir
 * başarısız ekleme ile biter.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AiUsageLogRepositoryTest {

    @Autowired
    private AiUsageLogRepository repository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JdbcTemplate jdbc;
    @Autowired
    private EntityManager entityManager;

    private Long userId;

    @BeforeEach
    void createUser() {
        userId = userRepository.save(User.builder()
                .email("ai-usage-" + UUID.randomUUID() + "@example.com")
                .passwordHash("not-a-real-hash")
                .displayName("AI usage test")
                .role(Role.ADMIN)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build()).getId();
    }

    private AiUsageLog.AiUsageLogBuilder reported(LocalDateTime createdAt, String cost) {
        return AiUsageLog.builder()
                .userId(userId)
                .feature(AiFeature.TUTOR)
                .model("deepseek-flash")
                .topicSlug("enum")
                .language(Language.TR)
                .createdAt(createdAt)
                .durationMs(1200)
                .outcome(AiUsageOutcome.SUCCESS)
                .truncated(false)
                .inputChars(5000)
                .contextChars(4000)
                .usageReported(true)
                .promptCacheHitTokens(100)
                .promptCacheMissTokens(2400)
                .completionTokens(300)
                .reasoningTokens(0)
                .estimatedCostUsd(new BigDecimal(cost))
                .pricingPeriod("OFF_PEAK")
                .pricingVersion("v-test");
    }

    private AiUsageLog.AiUsageLogBuilder unreported(LocalDateTime createdAt, String cost) {
        return reported(createdAt, cost)
                .outcome(AiUsageOutcome.ERROR)
                .errorCategory("TIMEOUT")
                .usageReported(false)
                .promptCacheHitTokens(null)
                .promptCacheMissTokens(null)
                .completionTokens(null)
                .reasoningTokens(null)
                .pricingPeriod("WORST_CASE");
    }

    // --- migration ---

    @Test
    void migrationV1150IsApplied() {
        Boolean success = jdbc.queryForObject(
                "SELECT success FROM flyway_schema_history WHERE version = '1150'", Boolean.class);
        assertThat(success).isTrue();
    }

    @Test
    void tableHoldsOnlySizesTokensAndCostNeverContent() {
        List<String> columns = jdbc.queryForList("""
                SELECT column_name FROM information_schema.columns
                WHERE table_name = 'ai_usage_log' ORDER BY ordinal_position""", String.class);
        assertThat(columns).containsExactly("id", "user_id", "feature", "model", "topic_slug", "language",
                "created_at", "duration_ms", "outcome", "error_category", "truncated", "input_chars",
                "context_chars", "usage_reported", "prompt_cache_hit_tokens", "prompt_cache_miss_tokens",
                "completion_tokens", "reasoning_tokens", "estimated_cost_usd", "pricing_period", "pricing_version");
    }

    @Test
    void costColumnMatchesTheCalculatorPrecision() {
        var column = jdbc.queryForMap("""
                SELECT numeric_precision, numeric_scale, is_nullable FROM information_schema.columns
                WHERE table_name = 'ai_usage_log' AND column_name = 'estimated_cost_usd'""");
        assertThat(column).containsEntry("numeric_precision", 12).containsEntry("numeric_scale", 6)
                .containsEntry("is_nullable", "NO");
    }

    @Test
    void budgetIndexesExist() {
        List<String> indexes = jdbc.queryForList(
                "SELECT indexname FROM pg_indexes WHERE tablename = 'ai_usage_log'", String.class);
        assertThat(indexes).contains("idx_ai_usage_log_created", "idx_ai_usage_log_user_created");
    }

    // --- entity round trip ---

    @Test
    void reportedRowRoundTripsExactly() {
        LocalDateTime at = LocalDateTime.of(2026, 10, 26, 12, 0);
        Long id = repository.saveAndFlush(reported(at, "0.001812").build()).getId();
        entityManager.clear();

        AiUsageLog loaded = repository.findById(id).orElseThrow();
        assertThat(loaded.getEstimatedCostUsd()).isEqualTo(new BigDecimal("0.001812"));
        assertThat(loaded.getLanguage()).isEqualTo(Language.TR);
        assertThat(loaded.getCreatedAt()).isEqualTo(at);
        assertThat(loaded.getPromptCacheMissTokens()).isEqualTo(2400);
        assertThat(jdbc.queryForObject("SELECT language FROM ai_usage_log WHERE id = ?", String.class, id))
                .isEqualTo("tr");
    }

    @Test
    void unreportedRowKeepsTokensEmptyAndAWorstCaseCost() {
        Long id = repository.saveAndFlush(unreported(LocalDateTime.of(2026, 10, 26, 12, 0), "0.022500").build()).getId();
        entityManager.clear();

        AiUsageLog loaded = repository.findById(id).orElseThrow();
        assertThat(loaded.isUsageReported()).isFalse();
        assertThat(loaded.getCompletionTokens()).isNull();
        assertThat(loaded.getEstimatedCostUsd()).isEqualTo(new BigDecimal("0.022500"));
    }

    // --- database constraints ---

    @Test
    void reportedUsageWithoutTokensIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                reported(LocalDateTime.now(), "0.001").completionTokens(null).build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void reportedUsageAtWorstCasePeriodIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                reported(LocalDateTime.now(), "0.001").pricingPeriod("WORST_CASE").build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void unknownUsageWithTokensIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                unreported(LocalDateTime.now(), "0.02").completionTokens(5).build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void unknownUsageMustBePricedAsWorstCase() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                unreported(LocalDateTime.now(), "0.02").pricingPeriod("PEAK").build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void missingCostIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(reported(LocalDateTime.now(), "0").estimatedCostUsd(null).build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void negativeCostIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(reported(LocalDateTime.now(), "-0.000001").build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void errorWithoutCategoryIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                unreported(LocalDateTime.now(), "0.02").errorCategory(null).build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void successWithErrorCategoryIsRejected() {
        assertThatThrownBy(() -> repository.saveAndFlush(
                reported(LocalDateTime.now(), "0.001").errorCategory("TIMEOUT").build()))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    @Test
    void deletingTheUserKeepsTheSpendButDropsTheLink() {
        Long id = repository.saveAndFlush(reported(LocalDateTime.now(), "0.003000").build()).getId();

        jdbc.update("DELETE FROM app_user WHERE id = ?", userId);

        var row = jdbc.queryForMap("SELECT user_id, estimated_cost_usd FROM ai_usage_log WHERE id = ?", id);
        assertThat(row.get("user_id")).isNull();
        assertThat((BigDecimal) row.get("estimated_cost_usd")).isEqualByComparingTo("0.003");
    }

    // --- repository ---

    @Test
    void sumSinceCountsRowsFromTheBoundaryOnwardIncludingWorstCaseRows() {
        LocalDateTime dayStart = LocalDateTime.of(2030, 1, 15, 0, 0);
        BigDecimal before = repository.sumEstimatedCostSince(dayStart);

        repository.save(reported(dayStart.minusSeconds(1), "5.000000").build());
        repository.save(reported(dayStart, "0.001812").build());
        repository.save(unreported(dayStart.plusHours(3), "0.022500").build());
        repository.flush();

        assertThat(repository.sumEstimatedCostSince(dayStart).subtract(before)).isEqualByComparingTo("0.024312");
    }

    @Test
    void sumWithNoRowsIsZero() {
        assertThat(repository.sumEstimatedCostSince(LocalDateTime.of(2999, 1, 1, 0, 0))).isEqualByComparingTo("0");
    }

    @Test
    void rowsCanBeListedPerUserInTimeOrder() {
        repository.save(reported(LocalDateTime.of(2026, 10, 26, 13, 0), "0.002").build());
        repository.save(reported(LocalDateTime.of(2026, 10, 26, 12, 0), "0.001").build());
        repository.flush();
        entityManager.clear();

        assertThat(repository.findByUserIdOrderByCreatedAtAsc(userId))
                .extracting(AiUsageLog::getEstimatedCostUsd)
                .containsExactly(new BigDecimal("0.001000"), new BigDecimal("0.002000"));
    }
}

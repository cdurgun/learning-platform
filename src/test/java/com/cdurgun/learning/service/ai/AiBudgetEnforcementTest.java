package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.AiUsageLog;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.AiTutorGuard.Allowed;
import com.cdurgun.learning.service.ai.AiTutorGuard.CallInfo;
import com.cdurgun.learning.service.ai.AiTutorGuard.Completed;
import com.cdurgun.learning.service.ai.AiTutorGuard.Decision;
import com.cdurgun.learning.service.ai.AiTutorGuard.Denied;
import com.cdurgun.learning.service.ai.AiTutorGuard.DenialReason;
import com.cdurgun.learning.service.ai.AiTutorGuard.Failed;
import com.cdurgun.learning.service.ai.AiTutorGuard.Rejected;
import com.cdurgun.learning.service.ai.AiTutorGuard.Reservation;
import com.zaxxer.hikari.HikariDataSource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Bütçe, limit ve rezervasyonlar GERÇEK Postgres'te (test veritabanı, V1150 + V1151). Eşzamanlılık
 * testleri ayrı iş parçacıklarında ayrı transaction'lar commit ettiği için sınıf
 * {@code @Transactional} DEĞİL: her test kendi satırlarını 2031 yılına (sabit saat) yazar ve
 * öncesinde/sonrasında yalnızca o aralığı ve kendi kullanıcılarını siler. "İkinci uygulama
 * örneği", kendi bağlantı havuzu ve transaction yöneticisi olan ayrı bir {@link AiReservationStore}
 * ile temsil edilir -- ortak olan tek şey veritabanıdır, tıpkı iki Railway instance'ı gibi.
 * Sağlayıcıya hiçbir gerçek çağrı yapılmaz: "sağlayıcı" her yerde yerel bir lambdadır.
 */
@SpringBootTest
@ActiveProfiles("test")
class AiBudgetEnforcementTest {

    private static final Instant MONDAY_NOON = Instant.parse("2031-03-10T12:00:00Z");
    private static final LocalDateTime TEST_RANGE_START = LocalDateTime.of(2031, 1, 1, 0, 0);
    private static final CallInfo LESSON = new CallInfo("enum", Language.EN, 4200);
    /** worstCase(1000): 500 token * 0.30 + 3000 * 1.20 (USD / 1M) */
    private static final BigDecimal WORST_1000 = new BigDecimal("0.003750");

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private AiReservationStore store;
    @Autowired
    private AiUsageRecorder recorder;
    @Autowired
    private PlatformTransactionManager transactionManager;
    @Autowired
    private JdbcTemplate jdbc;

    @Value("${spring.datasource.url}")
    private String url;
    @Value("${spring.datasource.username}")
    private String username;
    @Value("${spring.datasource.password}")
    private String password;

    private final MutableClock clock = new MutableClock(MONDAY_NOON);
    private final List<Long> userIds = new ArrayList<>();

    @BeforeEach
    @AfterEach
    void cleanUp() {
        jdbc.update("DELETE FROM ai_tutor_reservation WHERE created_at >= ?", TEST_RANGE_START);
        jdbc.update("DELETE FROM ai_usage_log WHERE created_at >= ?", TEST_RANGE_START);
        userIds.forEach(id -> {
            jdbc.update("DELETE FROM ai_tutor_reservation WHERE user_id = ?", id);
            jdbc.update("DELETE FROM app_user WHERE id = ?", id);
        });
        userIds.clear();
    }

    // --- yardımcılar ---

    private Authentication admin() {
        return user(Role.ADMIN);
    }

    private Authentication user(Role role) {
        String email = "ai-guard-" + UUID.randomUUID() + "@example.com";
        User saved = userRepository.save(User.builder().email(email).passwordHash("not-a-real-hash")
                .displayName("AI guard test").role(role)
                .createdAt(LocalDateTime.now()).updatedAt(LocalDateTime.now()).build());
        userIds.add(saved.getId());
        return new UsernamePasswordAuthenticationToken(email, null, AuthorityUtils.createAuthorityList("ROLE_" + role));
    }

    private AiTutorGuard guard(String... overrides) {
        return guard(store, overrides);
    }

    private AiTutorGuard guard(AiReservationStore reservations, String... overrides) {
        AiTutorSettings settings = AiTutorTestSettings.usable(overrides);
        return new AiTutorGuard(settings, userRepository, reservations, recorder, transactionManager, clock);
    }

    private static Reservation allowed(Decision decision) {
        assertThat(decision).isInstanceOf(Allowed.class);
        return ((Allowed) decision).reservation();
    }

    private Map<String, Object> row(long reservationId) {
        return jdbc.queryForMap("SELECT * FROM ai_tutor_reservation WHERE id = ?", reservationId);
    }

    private int reservations() {
        Integer count = jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation WHERE created_at >= ?",
                Integer.class, TEST_RANGE_START);
        return count == null ? 0 : count;
    }

    private int usageLogs() {
        Integer count = jdbc.queryForObject("SELECT count(*) FROM ai_usage_log WHERE created_at >= ?",
                Integer.class, TEST_RANGE_START);
        return count == null ? 0 : count;
    }

    /** Bütçede sayılan toplam: log tahminleri + sonuçsuz rezervasyonlar (store'un kuralıyla aynı). */
    private BigDecimal committed() {
        return jdbc.queryForObject("""
                SELECT (SELECT COALESCE(SUM(estimated_cost_usd), 0) FROM ai_usage_log WHERE created_at >= ?)
                     + (SELECT COALESCE(SUM(reserved_usd), 0) FROM ai_tutor_reservation
                        WHERE created_at >= ? AND status IN ('ACTIVE', 'EXPIRED'))""",
                BigDecimal.class, TEST_RANGE_START, TEST_RANGE_START);
    }

    private static TutorCompletion completion(TutorUsage usage) {
        return new TutorCompletion("answer", false, "deepseek-flash", usage);
    }

    // --- rezervasyon ---

    @Test
    void anAcceptedRequestHoldsAWorstCaseReservationAndNoSpendYet() {
        Reservation reservation = allowed(guard().reserve(admin(), 1000));

        Map<String, Object> row = row(reservation.id());
        assertThat(row.get("status")).isEqualTo("ACTIVE");
        assertThat((BigDecimal) row.get("reserved_usd")).isEqualByComparingTo(WORST_1000);
        assertThat(row.get("created_at")).isEqualTo(java.sql.Timestamp.valueOf(LocalDateTime.of(2031, 3, 10, 12, 0)));
        assertThat(row.get("expires_at")).isEqualTo(java.sql.Timestamp.valueOf(LocalDateTime.of(2031, 3, 10, 12, 2, 5)));
        assertThat(row.get("closed_at")).isNull();
        assertThat(reservation.reserved().usd()).isEqualByComparingTo(WORST_1000);
        assertThat(usageLogs()).isZero();
    }

    @Test
    void rejectedRequestsNeverCreateAReservation() {
        Authentication admin = admin();
        assertThat(guard("ai.tutor.enabled=false").reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.DISABLED));
        assertThat(guard("ai.tutor.api-key=").reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.MISSING_API_KEY));
        assertThat(guard().reserve(user(Role.USER), 1000)).isEqualTo(new Denied(DenialReason.FORBIDDEN));
        assertThat(guard("ai.tutor.budget.daily-usd=0.001").reserve(admin, 1000))
                .isEqualTo(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED));

        assertThat(reservations()).isZero();
        assertThat(usageLogs()).isZero();
    }

    @Test
    void oneRequestInFlightPerUser() {
        AiTutorGuard guard = guard();
        Authentication admin = admin();
        Reservation first = allowed(guard.reserve(admin, 1000));

        assertThat(guard.reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.REQUEST_IN_FLIGHT));
        allowed(guard.reserve(admin(), 1000)); // başka bir kullanıcı etkilenmez

        guard.settleSuccess(first, LESSON, Duration.ofMillis(900), completion(new TutorUsage(0, 100, 50, null)));
        allowed(guard.reserve(admin, 1000));
    }

    @Test
    void theDatabaseRefusesASecondActiveReservationForAUser() {
        Reservation first = allowed(guard().reserve(admin(), 1000));

        assertThatThrownBy(() -> jdbc.update("""
                INSERT INTO ai_tutor_reservation (user_id, created_at, expires_at, input_chars, reserved_usd,
                    pricing_version, status) VALUES (?, ?, ?, 1, 0.1, 'v', 'ACTIVE')""",
                first.userId(), LocalDateTime.of(2031, 3, 10, 12, 1), LocalDateTime.of(2031, 3, 10, 12, 5)))
                .isInstanceOf(org.springframework.dao.DuplicateKeyException.class);
    }

    @Test
    void hourlyLimitIsASlidingWindowAndReleasedRequestsDoNotCount() {
        AiTutorGuard guard = guard("ai.tutor.limits.requests-per-user-per-hour=3");
        Authentication admin = admin();

        Reservation released = allowed(guard.reserve(admin, 1000));
        assertThat(guard.release(released)).isTrue();
        for (int i = 0; i < 3; i++) {
            Reservation r = allowed(guard.reserve(admin, 1000));
            guard.settleFailure(r, LESSON, Duration.ofSeconds(1), new AiProviderException(AiErrorCategory.RATE_LIMITED, 429));
            clock.advance(Duration.ofMinutes(10));
        }
        assertThat(guard.reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.HOURLY_LIMIT_REACHED));

        clock.advance(Duration.ofMinutes(31)); // ilk isteğin üstünden 1 saat 1 dakika geçti
        allowed(guard.reserve(admin, 1000));
    }

    @Test
    void dailyBudgetCountsReservationsInFlight() {
        AiTutorGuard guard = guard("ai.tutor.budget.daily-usd=0.02");
        for (int i = 0; i < 5; i++) {
            allowed(guard.reserve(admin(), 1000)); // 5 * 0.00375 = 0.01875
        }
        assertThat(guard.reserve(admin(), 1000)).isEqualTo(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED));
        assertThat(guard.reserve(admin(), 256)).isEqualTo(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED));

        clock.advance(Duration.ofDays(1)); // yeni UTC günü, ay aynı
        allowed(guard.reserve(admin(), 1000));
    }

    @Test
    void monthlyBudgetHoldsAcrossDays() {
        AiTutorGuard guard = guard("ai.tutor.budget.daily-usd=0.008", "ai.tutor.budget.monthly-usd=0.008");
        allowed(guard.reserve(admin(), 1000));
        allowed(guard.reserve(admin(), 1000));
        assertThat(guard.reserve(admin(), 1000)).isEqualTo(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED));

        clock.advance(Duration.ofDays(1));
        assertThat(guard.reserve(admin(), 1000)).isEqualTo(new Denied(DenialReason.MONTHLY_BUDGET_EXHAUSTED));

        clock.set(Instant.parse("2031-04-01T00:00:00Z"));
        allowed(guard.reserve(admin(), 1000));
    }

    @Test
    void aBudgetExactlyFilledIsAllowedAndTheNextCentIsNot() {
        AiTutorGuard guard = guard("ai.tutor.budget.daily-usd=0.007500");
        allowed(guard.reserve(admin(), 1000));
        allowed(guard.reserve(admin(), 1000)); // tam 0.007500
        assertThat(guard.reserve(admin(), 0)).isEqualTo(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED));
    }

    // --- eşzamanlılık ---

    private List<Decision> concurrently(int requests, Callable<Decision> request) throws Exception {
        ExecutorService pool = Executors.newFixedThreadPool(requests);
        CountDownLatch start = new CountDownLatch(1);
        try {
            List<Future<Decision>> futures = new ArrayList<>();
            for (int i = 0; i < requests; i++) {
                futures.add(pool.submit(() -> {
                    start.await();
                    return request.call();
                }));
            }
            start.countDown();
            List<Decision> decisions = new ArrayList<>();
            for (Future<Decision> future : futures) {
                decisions.add(future.get(60, TimeUnit.SECONDS));
            }
            return decisions;
        } finally {
            pool.shutdownNow();
        }
    }

    @Test
    void concurrentRequestsCannotOverrunTheBudget() throws Exception {
        AiTutorGuard guard = guard("ai.tutor.budget.daily-usd=0.02");
        List<Authentication> admins = new ArrayList<>();
        for (int i = 0; i < 20; i++) {
            admins.add(admin());
        }
        AtomicInteger next = new AtomicInteger();

        List<Decision> decisions = concurrently(20, () -> guard.reserve(admins.get(next.getAndIncrement()), 1000));

        assertThat(decisions.stream().filter(Allowed.class::isInstance)).hasSize(5);
        assertThat(decisions.stream().filter(d -> d.equals(new Denied(DenialReason.DAILY_BUDGET_EXHAUSTED)))).hasSize(15);
        assertThat(committed()).isLessThanOrEqualTo(new BigDecimal("0.02")).isEqualByComparingTo("0.01875");
    }

    @Test
    void concurrentRequestsFromOneUserGetExactlyOneSlot() throws Exception {
        AiTutorGuard guard = guard();
        Authentication admin = admin();

        List<Decision> decisions = concurrently(10, () -> guard.reserve(admin, 1000));

        assertThat(decisions.stream().filter(Allowed.class::isInstance)).hasSize(1);
        assertThat(decisions.stream().filter(d -> d.equals(new Denied(DenialReason.REQUEST_IN_FLIGHT)))).hasSize(9);
    }

    @Test
    void twoApplicationInstancesShareOneBudget() throws Exception {
        try (HikariDataSource otherPool = otherInstancePool()) {
            AiReservationStore otherStore = new AiReservationStore(new JdbcTemplate(otherPool),
                    new DataSourceTransactionManager(otherPool));
            AiTutorGuard instanceA = guard("ai.tutor.budget.daily-usd=0.02");
            AiTutorGuard instanceB = guard(otherStore, "ai.tutor.budget.daily-usd=0.02");
            List<Authentication> admins = new ArrayList<>();
            for (int i = 0; i < 16; i++) {
                admins.add(admin());
            }
            AtomicInteger next = new AtomicInteger();

            List<Decision> decisions = concurrently(16, () -> {
                int i = next.getAndIncrement();
                return (i % 2 == 0 ? instanceA : instanceB).reserve(admins.get(i), 1000);
            });

            assertThat(decisions.stream().filter(Allowed.class::isInstance)).hasSize(5);
            assertThat(committed()).isEqualByComparingTo("0.01875");
        }
    }

    @Test
    void anotherInstanceWaitsForTheLockAndGivesUpSafely() throws Exception {
        try (HikariDataSource otherPool = otherInstancePool()) {
            AiReservationStore otherStore = new AiReservationStore(new JdbcTemplate(otherPool),
                    new DataSourceTransactionManager(otherPool));
            AiTutorGuard instanceB = guard(otherStore);
            Authentication admin = admin();
            AtomicInteger providerCalls = new AtomicInteger();

            // A örneği bütçe kilidini alıp lock_timeout'tan (5 sn) uzun tutar.
            CountDownLatch locked = new CountDownLatch(1);
            CountDownLatch done = new CountDownLatch(1);
            ExecutorService holder = Executors.newSingleThreadExecutor();
            Future<?> holding = holder.submit(() -> new TransactionTemplate(transactionManager).executeWithoutResult(s -> {
                store.lockInCurrentTransaction();
                locked.countDown();
                try {
                    done.await(20, TimeUnit.SECONDS);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }));
            try {
                assertThat(locked.await(10, TimeUnit.SECONDS)).isTrue();
                long started = System.nanoTime();
                var outcome = instanceB.execute(admin, 1000, LESSON, () -> {
                    providerCalls.incrementAndGet();
                    return completion(new TutorUsage(0, 1, 1, null));
                });
                assertThat(outcome).isEqualTo(new Rejected(DenialReason.GUARD_UNAVAILABLE));
                assertThat(Duration.ofNanos(System.nanoTime() - started)).isGreaterThanOrEqualTo(Duration.ofSeconds(4));
            } finally {
                done.countDown();
                holding.get(30, TimeUnit.SECONDS);
                holder.shutdownNow();
            }
            assertThat(providerCalls).hasValue(0);
            assertThat(reservations()).isZero();

            allowed(instanceB.reserve(admin, 1000)); // kilit bırakılınca normal çalışır
        }
    }

    private HikariDataSource otherInstancePool() {
        HikariDataSource pool = new HikariDataSource();
        pool.setJdbcUrl(url);
        pool.setUsername(username);
        pool.setPassword(password);
        pool.setMaximumPoolSize(8);
        pool.setPoolName("ai-guard-test-instance-b");
        return pool;
    }

    // --- sonuç yazma ve maliyet politikası ---

    @Test
    void successWithReportedUsageReplacesTheReservationWithTheEstimate() {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));
        TutorUsage usage = new TutorUsage(100, 400, 200, 0);

        AiUsageLog log = guard.settleSuccess(reservation, LESSON, Duration.ofMillis(1200), completion(usage));

        BigDecimal expected = new AiCostCalculator(AiTutorTestSettings.usable().properties().orElseThrow())
                .forCall(usage, 1000, MONDAY_NOON).usd();
        assertThat(log.getEstimatedCostUsd()).isEqualByComparingTo(expected).isLessThan(WORST_1000);
        assertThat(log.isUsageReported()).isTrue();
        assertThat(log.getPricingPeriod()).isEqualTo("OFF_PEAK"); // Pazartesi 12:00 UTC
        assertThat(log.getCreatedAt()).isEqualTo(LocalDateTime.of(2031, 3, 10, 12, 0));
        assertThat(log.getTopicSlug()).isEqualTo("enum");
        assertThat(log.getContextChars()).isEqualTo(4200);
        Map<String, Object> row = row(reservation.id());
        assertThat(row.get("status")).isEqualTo("SETTLED");
        assertThat(row.get("usage_log_id")).isEqualTo(log.getId());
        assertThat((BigDecimal) row.get("reserved_usd")).isEqualByComparingTo(WORST_1000); // rezervasyon ayrı kalır
        assertThat(committed()).isEqualByComparingTo(expected);
    }

    @Test
    void successWithoutUsageKeepsTheWorstCase() {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));

        AiUsageLog log = guard.settleSuccess(reservation, LESSON, Duration.ofMillis(1200), completion(null));

        assertThat(log.isUsageReported()).isFalse();
        assertThat(log.getPricingPeriod()).isEqualTo("WORST_CASE");
        assertThat(log.getEstimatedCostUsd()).isEqualByComparingTo(WORST_1000);
        assertThat(committed()).isEqualByComparingTo(WORST_1000);
    }

    @ParameterizedTest
    @EnumSource(value = AiErrorCategory.class, names = {"INVALID_REQUEST", "AUTHENTICATION", "INSUFFICIENT_BALANCE",
            "RATE_LIMITED", "OVERLOADED", "PROVIDER_ERROR", "TIMEOUT", "NETWORK", "INVALID_RESPONSE"})
    void failuresWithoutUsageAreNeverAssumedFree(AiErrorCategory category) {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));

        AiUsageLog log = guard.settleFailure(reservation, LESSON, Duration.ofSeconds(60),
                new AiProviderException(category, null)).orElseThrow();

        assertThat(log.getErrorCategory()).isEqualTo(category.name());
        assertThat(log.isUsageReported()).isFalse();
        assertThat(log.getPricingPeriod()).isEqualTo("WORST_CASE");
        assertThat(log.getEstimatedCostUsd()).isEqualByComparingTo(WORST_1000);
        assertThat(row(reservation.id()).get("status")).isEqualTo("SETTLED");
        assertThat(committed()).isEqualByComparingTo(WORST_1000);
    }

    @Test
    void aFailureThatReportsUsageIsPricedFromIt() {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));
        TutorUsage usage = new TutorUsage(0, 300, 40, null);

        AiUsageLog log = guard.settleFailure(reservation, LESSON, Duration.ofSeconds(2),
                new AiProviderException(AiErrorCategory.CONTENT_FILTERED, 200, usage, null)).orElseThrow();

        assertThat(log.isUsageReported()).isTrue();
        assertThat(log.getEstimatedCostUsd()).isLessThan(WORST_1000);
    }

    @Test
    void aRequestThatNeverLeftReleasesItsReservation() {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));

        assertThat(guard.settleFailure(reservation, LESSON, Duration.ZERO,
                new AiProviderException(AiErrorCategory.DISABLED, null))).isEmpty();

        assertThat(row(reservation.id()).get("status")).isEqualTo("RELEASED");
        assertThat(usageLogs()).isZero();
        assertThat(committed()).isEqualByComparingTo("0");
    }

    @Test
    void aReservationCanOnlyBeClosedOnce() {
        AiTutorGuard guard = guard();
        Reservation reservation = allowed(guard.reserve(admin(), 1000));
        guard.settleSuccess(reservation, LESSON, Duration.ofSeconds(1), completion(new TutorUsage(0, 10, 10, null)));

        assertThatThrownBy(() -> guard.settleSuccess(reservation, LESSON, Duration.ofSeconds(1),
                completion(new TutorUsage(0, 10, 10, null)))).isInstanceOf(IllegalStateException.class);
        assertThat(guard.release(reservation)).isFalse();
        assertThat(usageLogs()).isEqualTo(1); // ikinci log satırı geri alındı
    }

    @Test
    void aReservationCannotBeSettledForAnotherUser() {
        AiTutorGuard guard = guard();
        Reservation real = allowed(guard.reserve(admin(), 1000));
        Reservation forged = new Reservation(real.id(), allowed(guard.reserve(admin(), 10)).userId(),
                real.createdAt(), real.inputChars(), real.reserved());

        assertThatThrownBy(() -> guard.settleSuccess(forged, LESSON, Duration.ZERO, completion(null)))
                .isInstanceOf(IllegalStateException.class);
        assertThat(row(real.id()).get("status")).isEqualTo("ACTIVE");
    }

    // --- execute: rezervasyon -> sağlayıcı -> sonuç ---

    @Test
    void executeCallsTheProviderOnlyAfterAReservation() {
        AiTutorGuard guard = guard("ai.tutor.budget.daily-usd=0.001");
        AtomicInteger providerCalls = new AtomicInteger();

        var outcome = guard.execute(admin(), 1000, LESSON, () -> {
            providerCalls.incrementAndGet();
            return completion(new TutorUsage(0, 1, 1, null));
        });

        assertThat(outcome).isEqualTo(new Rejected(DenialReason.DAILY_BUDGET_EXHAUSTED));
        assertThat(providerCalls).hasValue(0);
        assertThat(reservations()).isZero();
    }

    @Test
    void executeSettlesASuccessfulCall() {
        TutorUsage usage = new TutorUsage(0, 400, 100, null);
        var outcome = guard().execute(admin(), 1000, LESSON, () -> completion(usage));

        assertThat(outcome).isInstanceOf(Completed.class);
        Completed completed = (Completed) outcome;
        assertThat(completed.completion().content()).isEqualTo("answer");
        assertThat(completed.usageLog().isUsageReported()).isTrue();
        assertThat(jdbc.queryForObject("SELECT status FROM ai_tutor_reservation WHERE usage_log_id = ?",
                String.class, completed.usageLog().getId())).isEqualTo("SETTLED");
    }

    @Test
    void executeRecordsATimeoutAtTheWorstCase() {
        var outcome = guard().execute(admin(), 1000, LESSON, () -> {
            throw new AiProviderException(AiErrorCategory.TIMEOUT, null);
        });

        assertThat(outcome).isInstanceOf(Failed.class);
        Failed failed = (Failed) outcome;
        assertThat(failed.failure().getCategory()).isEqualTo(AiErrorCategory.TIMEOUT);
        assertThat(failed.usageLog().getEstimatedCostUsd()).isEqualByComparingTo(WORST_1000);
        assertThat(failed.usageLog().getPricingPeriod()).isEqualTo("WORST_CASE");
    }

    @Test
    void anUnexpectedErrorIsRecordedAtTheWorstCaseAndRethrown() {
        AiTutorGuard guard = guard();
        Authentication admin = admin();

        assertThatThrownBy(() -> guard.execute(admin, 1000, LESSON, () -> {
            throw new IllegalStateException("boom");
        })).isInstanceOf(IllegalStateException.class).hasMessage("boom");

        assertThat(jdbc.queryForObject("SELECT error_category FROM ai_usage_log WHERE created_at >= ?",
                String.class, TEST_RANGE_START)).isEqualTo("PROVIDER_ERROR");
        assertThat(committed()).isEqualByComparingTo(WORST_1000);
        allowed(guard.reserve(admin, 1000)); // kullanıcının kilidi kalkmış
    }

    // --- süresi dolan rezervasyonlar ---

    @Test
    void anExpiredReservationFreesTheUserButStaysInTheBudget() {
        AiTutorGuard guard = guard();
        Authentication admin = admin();
        Reservation stale = allowed(guard.reserve(admin, 1000));

        clock.advance(Duration.ofSeconds(124));
        assertThat(guard.reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.REQUEST_IN_FLIGHT));

        clock.advance(Duration.ofSeconds(1)); // 125 sn: bağlantı + toplam zaman aşımı + pay
        Reservation next = allowed(guard.reserve(admin, 1000));

        assertThat(row(stale.id()).get("status")).isEqualTo("EXPIRED");
        assertThat(row(stale.id()).get("closed_at")).isNotNull();
        assertThat(committed()).isEqualByComparingTo(WORST_1000.multiply(BigDecimal.valueOf(2)));
        assertThat(row(next.id()).get("status")).isEqualTo("ACTIVE");
    }

    @Test
    void aLateResultForAnExpiredReservationIsStillRecordedOnce() {
        AiTutorGuard guard = guard();
        Authentication admin = admin();
        Reservation stale = allowed(guard.reserve(admin, 1000));
        clock.advance(Duration.ofMinutes(3));
        allowed(guard.reserve(admin, 1000)); // stale EXPIRED oldu

        TutorUsage usage = new TutorUsage(0, 400, 100, null);
        AiUsageLog log = guard.settleSuccess(stale, LESSON, Duration.ofMinutes(3), completion(usage));

        assertThat(row(stale.id()).get("status")).isEqualTo("SETTLED");
        // Artık rezervasyon değil, onun log tahmini sayılır: çift sayım yok.
        assertThat(committed()).isEqualByComparingTo(log.getEstimatedCostUsd().add(WORST_1000));
        assertThat(log.getCreatedAt()).isEqualTo(LocalDateTime.of(2031, 3, 10, 12, 0));
    }

    @Test
    void anExpiredReservationCountsForTheHourlyLimit() {
        AiTutorGuard guard = guard("ai.tutor.limits.requests-per-user-per-hour=1");
        Authentication admin = admin();
        allowed(guard.reserve(admin, 1000));

        clock.advance(Duration.ofMinutes(5));
        assertThat(guard.reserve(admin, 1000)).isEqualTo(new Denied(DenialReason.HOURLY_LIMIT_REACHED));
    }

    /** Testlerin elle ilerlettiği saat; birden fazla iş parçacığı okuyabilir. */
    static final class MutableClock extends Clock {

        private volatile Instant now;

        MutableClock(Instant now) {
            this.now = now;
        }

        void advance(Duration duration) {
            now = now.plus(duration);
        }

        void set(Instant instant) {
            now = instant;
        }

        @Override
        public ZoneId getZone() {
            return ZoneOffset.UTC;
        }

        @Override
        public Clock withZone(ZoneId zone) {
            throw new UnsupportedOperationException();
        }

        @Override
        public Instant instant() {
            return now;
        }
    }
}

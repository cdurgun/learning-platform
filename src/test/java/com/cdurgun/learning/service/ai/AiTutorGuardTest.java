package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.AiTutorGuard.Allowed;
import com.cdurgun.learning.service.ai.AiTutorGuard.CallInfo;
import com.cdurgun.learning.service.ai.AiTutorGuard.Denied;
import com.cdurgun.learning.service.ai.AiTutorGuard.DenialReason;
import com.cdurgun.learning.service.ai.AiTutorGuard.Rejected;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
import org.mockito.ArgumentCaptor;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;
import org.springframework.dao.QueryTimeoutException;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.TestingAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.transaction.PlatformTransactionManager;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * {@link AiTutorGuard}'ın veritabanına gitmeden verdiği kararlar: kimlik, rol, yapılandırma,
 * store'un reddi ya da hatası. Hiçbir red durumunda rezervasyon istenmez ve sağlayıcı çağrılmaz.
 * Kilitleme, bütçe ve sonuç yazma gerçek Postgres'te {@link AiBudgetEnforcementTest}'te.
 */
@ExtendWith(OutputCaptureExtension.class)
class AiTutorGuardTest {

    private static final String ADMIN_EMAIL = "admin@example.com";
    private static final Instant NOW = Instant.parse("2031-01-15T12:00:00Z");

    private final UserRepository users = mock(UserRepository.class);
    private final AiReservationStore store = mock(AiReservationStore.class);
    private final AiUsageRecorder recorder = mock(AiUsageRecorder.class);
    private final PlatformTransactionManager transactions = mock(PlatformTransactionManager.class);
    private final AtomicInteger providerCalls = new AtomicInteger();

    AiTutorGuardTest() {
        when(users.findByEmail(ADMIN_EMAIL)).thenReturn(Optional.of(user(41L, Role.ADMIN)));
        when(users.findByEmail("user@example.com")).thenReturn(Optional.of(user(42L, Role.USER)));
    }

    private static User user(long id, Role role) {
        User user = new User();
        user.setId(id);
        user.setRole(role);
        return user;
    }

    private AiTutorGuard guard(AiTutorSettings settings) {
        return new AiTutorGuard(settings, users, store, recorder, transactions, Clock.fixed(NOW, ZoneOffset.UTC));
    }

    private static Authentication signedIn(String email) {
        return new UsernamePasswordAuthenticationToken(email, null, AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
    }

    private TutorCompletion provider() {
        providerCalls.incrementAndGet();
        return new TutorCompletion("answer", false, "deepseek-flash", new TutorUsage(0, 10, 10, null));
    }

    private void assertRejectedWithoutReservation(AiTutorGuard guard, Authentication auth, DenialReason reason) {
        assertThat(guard.reserve(auth, 1000)).isEqualTo(new Denied(reason));
        assertThat(guard.execute(auth, 1000, new CallInfo(null, null, null), this::provider))
                .isEqualTo(new Rejected(reason));
        assertThat(providerCalls).hasValue(0);
        verifyNoInteractions(store, recorder, transactions);
    }

    // --- kimlik ---

    @Test
    void anonymousOrMissingAuthenticationIsRejected() {
        AiTutorGuard guard = guard(AiTutorTestSettings.usable());
        Authentication anonymous = new AnonymousAuthenticationToken("key", "anonymousUser",
                AuthorityUtils.createAuthorityList("ROLE_ANONYMOUS"));
        TestingAuthenticationToken notAuthenticated = new TestingAuthenticationToken(ADMIN_EMAIL, null);
        notAuthenticated.setAuthenticated(false);

        for (Authentication auth : new Authentication[]{null, anonymous, notAuthenticated, signedIn(""),
                signedIn("unknown@example.com")}) {
            assertRejectedWithoutReservation(guard, auth, DenialReason.NOT_AUTHENTICATED);
        }
    }

    @Test
    void roleComesFromTheDatabaseNotFromTheToken() {
        // Token ROLE_ADMIN taşısa da app_user.role USER: reddedilir.
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.usable()), signedIn("user@example.com"),
                DenialReason.FORBIDDEN);
    }

    @Test
    void userLookupFailureRefusesTheRequest(CapturedOutput output) {
        when(users.findByEmail(anyString())).thenThrow(new QueryTimeoutException("db down"));

        assertRejectedWithoutReservation(guard(AiTutorTestSettings.usable()), signedIn(ADMIN_EMAIL),
                DenialReason.GUARD_UNAVAILABLE);
        assertThat(output).contains("QueryTimeoutException").doesNotContain("db down");
    }

    // --- yapılandırma ---

    @Test
    void featureIsOffByDefault() {
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.load()), signedIn(ADMIN_EMAIL), DenialReason.DISABLED);
    }

    @Test
    void disabledWinsEvenWithAKey() {
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.load("ai.tutor.api-key=" + AiTutorTestSettings.FAKE_KEY)),
                signedIn(ADMIN_EMAIL), DenialReason.DISABLED);
    }

    @Test
    void enabledWithoutAKeyIsRejected() {
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.load("ai.tutor.enabled=true")),
                signedIn(ADMIN_EMAIL), DenialReason.MISSING_API_KEY);
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.load("ai.tutor.enabled=true", "ai.tutor.api-key=  ")),
                signedIn(ADMIN_EMAIL), DenialReason.MISSING_API_KEY);
    }

    @Test
    void invalidConfigurationKeepsTheTutorClosedEvenWhenEnabled() {
        AiTutorSettings invalid = AiTutorTestSettings.usable("ai.tutor.budget.daily-usd=-1");
        assertThat(invalid.isValid()).isFalse();

        assertRejectedWithoutReservation(guard(invalid), signedIn(ADMIN_EMAIL), DenialReason.INVALID_CONFIGURATION);
    }

    @Test
    void unbindableConfigurationKeepsTheTutorClosed() {
        assertRejectedWithoutReservation(guard(AiTutorTestSettings.usable("ai.tutor.limits.requests-per-user-per-hour=many")),
                signedIn(ADMIN_EMAIL), DenialReason.INVALID_CONFIGURATION);
    }

    @Test
    void anUnconfiguredGuardCannotSettleAnything() {
        AiTutorGuard guard = guard(AiTutorTestSettings.usable("ai.tutor.budget.daily-usd=-1"));
        var reservation = new AiTutorGuard.Reservation(1, 41, NOW, 10, null);
        assertThatThrownBy(() -> guard.settleSuccess(reservation, new CallInfo(null, null, null), Duration.ZERO,
                new TutorCompletion("a", false, "m", null))).isInstanceOf(IllegalStateException.class);
    }

    // --- store kararları ---

    @ParameterizedTest
    @EnumSource(value = DenialReason.class, names = {"REQUEST_IN_FLIGHT", "HOURLY_LIMIT_REACHED",
            "DAILY_BUDGET_EXHAUSTED", "MONTHLY_BUDGET_EXHAUSTED"})
    void storeRejectionsArePassedThroughAndTheProviderIsNeverCalled(DenialReason reason) {
        when(store.reserve(any())).thenReturn(AiReservationStore.Outcome.rejected(reason));
        AiTutorGuard guard = guard(AiTutorTestSettings.usable());

        assertThat(guard.execute(signedIn(ADMIN_EMAIL), 1000, new CallInfo(null, null, null), this::provider))
                .isEqualTo(new Rejected(reason));
        assertThat(providerCalls).hasValue(0);
        verifyNoInteractions(recorder);
    }

    @Test
    void aFailingReservationRefusesTheRequestAndNeverReachesTheProvider(CapturedOutput output) {
        when(store.reserve(any())).thenThrow(new QueryTimeoutException("canceling statement due to lock timeout"));
        AiTutorGuard guard = guard(AiTutorTestSettings.usable());

        assertThat(guard.execute(signedIn(ADMIN_EMAIL), 1000, new CallInfo(null, null, null), this::provider))
                .isEqualTo(new Rejected(DenialReason.GUARD_UNAVAILABLE));
        assertThat(providerCalls).hasValue(0);
        assertThat(output).contains("request refused").doesNotContain(AiTutorTestSettings.FAKE_KEY);
    }

    @Test
    void theReservationIsTheWorstCaseWithTheConfiguredLimits() {
        when(store.reserve(any())).thenReturn(new AiReservationStore.Outcome(9L, null, BigDecimal.ZERO, BigDecimal.ZERO));
        AiTutorSettings settings = AiTutorTestSettings.usable();
        AiCostCalculator calculator = new AiCostCalculator(settings.properties().orElseThrow());

        Allowed allowed = (Allowed) guard(settings).reserve(signedIn(ADMIN_EMAIL), 138_000);

        ArgumentCaptor<AiReservationStore.Request> request = ArgumentCaptor.forClass(AiReservationStore.Request.class);
        verify(store).reserve(request.capture());
        assertThat(request.getValue().amount()).isEqualByComparingTo("0.024300")
                .isEqualByComparingTo(calculator.worstCase(138_000).usd());
        assertThat(request.getValue().userId()).isEqualTo(41L);
        assertThat(request.getValue().now()).isEqualTo(NOW);
        assertThat(request.getValue().ttl()).isEqualTo(Duration.ofSeconds(5 + 60 + 60));
        assertThat(request.getValue().hourlyLimit()).isEqualTo(30);
        assertThat(request.getValue().dailyBudget()).isEqualByComparingTo("1.00");
        assertThat(request.getValue().monthlyBudget()).isEqualByComparingTo("10.00");
        assertThat(allowed.reservation().id()).isEqualTo(9L);
        assertThat(allowed.reservation().reserved().period()).isEqualTo(AiCostCalculator.PricingPeriod.WORST_CASE);
        assertThat(allowed.reservation().reserved().usageReported()).isFalse();
    }

    @Test
    void crossingTheAlertRatioLogsOnlyNumbers(CapturedOutput output) {
        when(store.reserve(any())).thenReturn(new AiReservationStore.Outcome(9L, null, new BigDecimal("0.79"), BigDecimal.ZERO));

        guard(AiTutorTestSettings.usable()).reserve(signedIn(ADMIN_EMAIL), 138_000);

        assertThat(output).contains("AI Tutor daily budget reached 0.814300 of 1.00 USD")
                .doesNotContain("monthly budget").doesNotContain(AiTutorTestSettings.FAKE_KEY);
    }

    @Test
    void negativeInputIsAProgrammingError() {
        assertThatThrownBy(() -> guard(AiTutorTestSettings.usable()).reserve(signedIn(ADMIN_EMAIL), -1))
                .isInstanceOf(IllegalArgumentException.class);
        verifyNoInteractions(store);
    }

    @Test
    void reasonsCoverEveryRefusal() {
        assertThat(List.of(DenialReason.values())).containsExactly(DenialReason.NOT_AUTHENTICATED,
                DenialReason.FORBIDDEN, DenialReason.INVALID_CONFIGURATION, DenialReason.DISABLED,
                DenialReason.MISSING_API_KEY, DenialReason.REQUEST_IN_FLIGHT, DenialReason.HOURLY_LIMIT_REACHED,
                DenialReason.DAILY_BUDGET_EXHAUSTED, DenialReason.MONTHLY_BUDGET_EXHAUSTED,
                DenialReason.GUARD_UNAVAILABLE);
    }
}

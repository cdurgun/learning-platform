package com.cdurgun.learning.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.StandardEnvironment;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@code ai.tutor.*}'ın GERÇEK {@code application.yml}'den {@link AiTutorSettings#load} ile
 * bağlanması ve doğrulanması. Makinedeki ortam değişkenleri ve sistem özellikleri BİLİNÇLİ
 * OLARAK kaldırılıyor -- aksi hâlde geliştiricinin kabuğunda tanımlı bir
 * {@code AI_TUTOR_ENABLED}/{@code DEEPSEEK_API_KEY} "varsayılan kapalı" testini bozardı.
 */
class AiTutorSettingsTest {

    static StandardEnvironment environment(String... overrides) {
        StandardEnvironment environment = new StandardEnvironment();
        MutablePropertySources sources = environment.getPropertySources();
        sources.remove(StandardEnvironment.SYSTEM_ENVIRONMENT_PROPERTY_SOURCE_NAME);
        sources.remove(StandardEnvironment.SYSTEM_PROPERTIES_PROPERTY_SOURCE_NAME);
        Map<String, Object> values = new LinkedHashMap<>();
        for (String override : overrides) {
            int eq = override.indexOf('=');
            values.put(override.substring(0, eq), override.substring(eq + 1));
        }
        sources.addFirst(new MapPropertySource("overrides", values));
        try {
            new YamlPropertySourceLoader().load("application.yml", new ClassPathResource("application.yml"))
                    .forEach(sources::addLast);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
        return environment;
    }

    private static AiTutorSettings load(String... overrides) {
        return AiTutorSettings.load(environment(overrides));
    }

    @Test
    void applicationYmlDefaultsAreValidDisabledAndMatchThePlan() {
        AiTutorSettings settings = load();
        assertThat(settings.isValid()).isTrue();
        assertThat(settings.problems()).isEmpty();
        assertThat(settings.isUsable()).isFalse();

        AiTutorProperties properties = settings.properties().orElseThrow();
        assertThat(properties.enabled()).isFalse();
        assertThat(properties.hasApiKey()).isFalse();
        assertThat(properties.baseUrl()).isEqualTo("https://api.deepseek.com");
        assertThat(properties.model()).isEqualTo("deepseek-flash");

        assertThat(properties.timeouts().connect()).isEqualTo(Duration.ofSeconds(5));
        assertThat(properties.timeouts().total()).isEqualTo(Duration.ofSeconds(60));

        AiTutorProperties.Limits limits = properties.limits();
        assertThat(limits.maxOutputTokens()).isEqualTo(1500);
        assertThat(limits.maxMessageChars()).isEqualTo(4000);
        assertThat(limits.maxContextChars()).isEqualTo(60000);
        assertThat(limits.maxAnswerCharsStored()).isEqualTo(8000);
        assertThat(limits.historyTurns()).isEqualTo(6);
        assertThat(limits.maxConversationsPerSession()).isEqualTo(5);
        assertThat(limits.requestsPerUserPerHour()).isEqualTo(30);
        assertThat(limits.maxHistoryChars()).isEqualTo(24000);

        AiTutorProperties.Budget budget = properties.budget();
        assertThat(budget.dailyUsd()).isEqualByComparingTo("1.00");
        assertThat(budget.monthlyUsd()).isEqualByComparingTo("10.00");
        assertThat(budget.alertRatio()).isEqualByComparingTo("0.80");
        assertThat(budget.worstCaseTokensPerChar()).isEqualByComparingTo("0.5");

        AiTutorProperties.Pricing pricing = properties.pricing();
        assertThat(pricing.version()).isEqualTo("deepseek-flash-2026-10-27");
        assertThat(pricing.offPeak().cacheHitUsdPerMillion()).isEqualByComparingTo("0.003");
        assertThat(pricing.offPeak().cacheMissUsdPerMillion()).isEqualByComparingTo("0.15");
        assertThat(pricing.offPeak().outputUsdPerMillion()).isEqualByComparingTo("0.60");
        assertThat(pricing.peak().cacheHitUsdPerMillion()).isEqualByComparingTo("0.006");
        assertThat(pricing.peak().cacheMissUsdPerMillion()).isEqualByComparingTo("0.30");
        assertThat(pricing.peak().outputUsdPerMillion()).isEqualByComparingTo("1.20");
        assertThat(pricing.peakDays()).containsExactly(DayOfWeek.MONDAY, DayOfWeek.TUESDAY,
                DayOfWeek.WEDNESDAY, DayOfWeek.THURSDAY, DayOfWeek.FRIDAY);
        assertThat(pricing.peakHoursUtc()).containsExactly(
                new AiTutorProperties.HourWindow(1, 4), new AiTutorProperties.HourWindow(6, 10));
    }

    @Test
    void enabledWithoutApiKeyIsNotUsable() {
        assertThat(load("ai.tutor.enabled=true").isUsable()).isFalse();
    }

    @Test
    void blankApiKeyCountsAsMissing() {
        assertThat(load("ai.tutor.enabled=true", "ai.tutor.api-key=   ").isUsable()).isFalse();
    }

    @Test
    void apiKeyAloneDoesNotEnableTheTutor() {
        assertThat(load("ai.tutor.api-key=sk-test-not-a-real-key").isUsable()).isFalse();
    }

    @Test
    void enabledWithApiKeyIsUsable() {
        assertThat(load("ai.tutor.enabled=true", "ai.tutor.api-key=sk-test-not-a-real-key").isUsable()).isTrue();
    }

    @Test
    void toStringNeverContainsTheApiKey() {
        String text = load("ai.tutor.api-key=sk-test-not-a-real-key").properties().orElseThrow().toString();
        assertThat(text).doesNotContain("sk-test-not-a-real-key").contains("apiKey=****");
    }

    @Test
    void budgetsCanBeOverriddenLikeTheRailwayVariables() {
        AiTutorProperties.Budget budget = load("ai.tutor.budget.daily-usd=0.25", "ai.tutor.budget.monthly-usd=3")
                .properties().orElseThrow().budget();
        assertThat(budget.dailyUsd()).isEqualByComparingTo(new BigDecimal("0.25"));
        assertThat(budget.monthlyUsd()).isEqualByComparingTo(new BigDecimal("3"));
    }

    @Test
    void localhostHttpBaseUrlIsAllowedForTestStubs() {
        assertThat(load("ai.tutor.base-url=http://localhost:8089").isValid()).isTrue();
    }

    @Test
    void plainHttpBaseUrlIsRejected() {
        assertInvalid("ai.tutor.base-url", "ai.tutor.base-url=http://api.deepseek.com");
    }

    @Test
    void outputTokensMustStayWithinTheSafetyCap() {
        assertInvalid("ai.tutor.limits.max-output-tokens", "ai.tutor.limits.max-output-tokens=0");
        assertInvalid("ai.tutor.limits.max-output-tokens", "ai.tutor.limits.max-output-tokens=8193");
    }

    @Test
    void dailyBudgetMustNotExceedMonthlyBudget() {
        AiTutorSettings settings = assertInvalid("ai.tutor.budget", "ai.tutor.budget.daily-usd=20");
        assertThat(settings.problems()).anySatisfy(p -> assertThat(p).contains("daily-usd must not exceed monthly-usd"));
    }

    @Test
    void negativeValuesAreRejected() {
        assertInvalid("ai.tutor.budget.daily-usd", "ai.tutor.budget.daily-usd=-1");
        assertInvalid("ai.tutor.pricing.peak.output-usd-per-million", "ai.tutor.pricing.peak.output-usd-per-million=-0.01");
    }

    @Test
    void tokensPerCharMustBePositive() {
        assertInvalid("ai.tutor.budget.worst-case-tokens-per-char", "ai.tutor.budget.worst-case-tokens-per-char=0");
    }

    @Test
    void totalTimeoutIsCapped() {
        assertInvalid("ai.tutor.timeouts.total", "ai.tutor.timeouts.total=10m");
    }

    @Test
    void peakWindowMustBeOrdered() {
        assertInvalid("ai.tutor.pricing.peak-hours-utc[0]",
                "ai.tutor.pricing.peak-hours-utc[0].start=5", "ai.tutor.pricing.peak-hours-utc[0].end=4");
    }

    @Test
    void modelIsRequired() {
        assertInvalid("ai.tutor.model", "ai.tutor.model= ");
    }

    @Test
    void unconvertibleValueIsReportedByNameOnly() {
        AiTutorSettings settings = assertInvalid("ai.tutor.budget.daily-usd", "ai.tutor.budget.daily-usd=one-dollar");
        assertThat(String.join(" ", settings.problems())).doesNotContain("one-dollar");
    }

    @Test
    void invalidConfigurationFailsClosedEvenWhenEnabledWithAKey() {
        AiTutorSettings settings = load("ai.tutor.enabled=true", "ai.tutor.api-key=sk-test-not-a-real-key",
                "ai.tutor.limits.max-output-tokens=0");
        assertThat(settings.isValid()).isFalse();
        assertThat(settings.isUsable()).isFalse();
        assertThat(settings.properties()).isEmpty();
    }

    @Test
    void problemsNeverContainRejectedValuesOrTheApiKey() {
        AiTutorSettings settings = load("ai.tutor.api-key=sk-test-not-a-real-key",
                "ai.tutor.base-url=http://leaky-host.example/sk-pasted-here");
        assertThat(settings.isValid()).isFalse();
        String problems = String.join(" ", settings.problems());
        assertThat(problems).contains("ai.tutor.base-url")
                .doesNotContain("sk-test-not-a-real-key")
                .doesNotContain("leaky-host")
                .doesNotContain("sk-pasted-here");
    }

    private AiTutorSettings assertInvalid(String expectedProperty, String... overrides) {
        AiTutorSettings settings = load(overrides);
        assertThat(settings.isValid()).isFalse();
        assertThat(settings.isUsable()).isFalse();
        assertThat(settings.problems()).anySatisfy(p -> assertThat(p).startsWith(expectedProperty));
        return settings;
    }
}

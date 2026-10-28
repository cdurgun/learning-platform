package com.cdurgun.learning.config;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Geçersiz bir {@code ai.tutor.*} yapılandırmasının uygulama bağlamını DÜŞÜRMEDİĞİ,
 * tutoru kapalı tuttuğu ve değer sızdırmayan tek bir uyarı yazdığı. Bağlamdaki başka bir
 * bean ("sitenin geri kalanı" yerine) normal oluşmaya devam etmeli.
 */
@ExtendWith(OutputCaptureExtension.class)
class AiTutorConfigTest {

    private static final String KEY = "sk-test-not-a-real-key";

    @Configuration(proxyBeanMethods = false)
    static class RestOfTheSite {
        @Bean
        String unrelatedBean() {
            return "still here";
        }
    }

    private ApplicationContextRunner runner(String... overrides) {
        return new ApplicationContextRunner(() -> {
            AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
            context.setEnvironment(AiTutorSettingsTest.environment(overrides));
            return context;
        }).withUserConfiguration(AiTutorConfig.class, RestOfTheSite.class);
    }

    @Test
    void invalidConfigurationKeepsTheApplicationUpAndTheTutorOff(CapturedOutput output) {
        runner("ai.tutor.enabled=true", "ai.tutor.api-key=" + KEY,
                "ai.tutor.budget.daily-usd=20", "ai.tutor.base-url=http://leaky-host.example")
                .run(context -> {
                    assertThat(context).hasNotFailed();
                    assertThat(context.getBean("unrelatedBean")).isEqualTo("still here");
                    assertThat(context.getBean(AiTutorSettings.class).isUsable()).isFalse();
                });

        assertThat(output).contains("AI Tutor disabled: invalid configuration")
                .contains("ai.tutor.base-url")
                .contains("daily-usd must not exceed monthly-usd")
                .doesNotContain(KEY)
                .doesNotContain("leaky-host");
    }

    @Test
    void enabledWithoutKeyWarnsAndStaysOff(CapturedOutput output) {
        runner("ai.tutor.enabled=true").run(context -> {
            assertThat(context).hasNotFailed();
            assertThat(context.getBean(AiTutorSettings.class).isUsable()).isFalse();
        });
        assertThat(output).contains("ai.tutor.enabled is true but no API key is configured");
    }

    @Test
    void defaultConfigurationIsQuietAndOff(CapturedOutput output) {
        runner().run(context -> {
            assertThat(context).hasNotFailed();
            assertThat(context.getBean(AiTutorSettings.class).isValid()).isTrue();
            assertThat(context.getBean(AiTutorSettings.class).isUsable()).isFalse();
        });
        assertThat(output).doesNotContain("AI Tutor disabled");
    }

    @Test
    void validEnabledConfigurationIsUsableAndNeverLogsTheKey(CapturedOutput output) {
        runner("ai.tutor.enabled=true", "ai.tutor.api-key=" + KEY).run(context ->
                assertThat(context.getBean(AiTutorSettings.class).isUsable()).isTrue());
        assertThat(output).doesNotContain(KEY);
    }
}

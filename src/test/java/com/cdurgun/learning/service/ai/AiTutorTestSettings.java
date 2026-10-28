package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.config.AiTutorSettings;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.StandardEnvironment;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Gerçek {@code application.yml} + verilen geçersiz kılmalarla {@link AiTutorSettings}. Sistem
 * ortamı ve sistem özellikleri bilinçli olarak çıkarılır: makinede tanımlı bir
 * {@code DEEPSEEK_API_KEY} ya da {@code AI_TUTOR_ENABLED} testlere hiç sızmaz.
 */
final class AiTutorTestSettings {

    /** Test anahtarı; gerçek değil, hiçbir yere gönderilmez. */
    static final String FAKE_KEY = "sk-test-not-a-real-key";

    private AiTutorTestSettings() {
    }

    static AiTutorSettings load(String... overrides) {
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
        return AiTutorSettings.load(environment);
    }

    /** Bayrak açık + sahte anahtar + verilen ek ayarlar. */
    static AiTutorSettings usable(String... overrides) {
        String[] all = new String[overrides.length + 2];
        all[0] = "ai.tutor.enabled=true";
        all[1] = "ai.tutor.api-key=" + FAKE_KEY;
        System.arraycopy(overrides, 0, all, 2, overrides.length);
        return load(all);
    }
}

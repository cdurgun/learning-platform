package com.cdurgun.learning.web;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;

import static org.assertj.core.api.Assertions.assertThat;

/** AI Tutor'un {@code aiTutor.*} arayüz metinleri üç dosyada da eksiksiz. */
class AiTutorMessagesTest {

    private static Set<String> aiTutorKeys(String file) throws IOException {
        Properties properties = new Properties();
        try (InputStream in = AiTutorMessagesTest.class.getResourceAsStream("/" + file)) {
            properties.load(in);
        }
        Set<String> keys = new TreeSet<>();
        for (String key : properties.stringPropertyNames()) {
            if (key.startsWith("aiTutor.")) {
                assertThat(properties.getProperty(key)).as(file + " " + key).isNotBlank();
                keys.add(key);
            }
        }
        return keys;
    }

    @Test
    void everyLanguageHasTheSameKeys() throws IOException {
        Set<String> english = aiTutorKeys("messages_en.properties");

        assertThat(english).contains("aiTutor.notSaved", "aiTutor.client.network", "aiTutor.error.ai_unavailable");
        assertThat(aiTutorKeys("messages_tr.properties")).isEqualTo(english);
        assertThat(aiTutorKeys("messages.properties")).isEqualTo(english);
    }
}

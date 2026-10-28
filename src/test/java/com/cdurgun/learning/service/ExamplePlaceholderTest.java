package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;

import java.util.regex.Matcher;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Ortak {@code {{Ad.uzanti}}} deseni. {@link MarkdownService} Faz 27'den beri bu literal'i
 * kullanıyordu; sabit oraya taşındığında değeri DEĞİŞMEMELİ (sayfa render'ı ile AI Tutor'un ders
 * bağlamı aynı yer tutucuları görsün diye).
 */
class ExamplePlaceholderTest {

    @Test
    void patternIsTheOneMarkdownServiceAlwaysUsed() {
        assertThat(ExamplePlaceholder.PATTERN.pattern()).isEqualTo("\\{\\{(\\w+)\\.(\\w+)}}");
        assertThat(ExamplePlaceholder.PATTERN.flags()).isZero();
    }

    @Test
    void groupsAreNameAndExtension() {
        Matcher matcher = ExamplePlaceholder.PATTERN.matcher("before {{Hello_World2.jsx}} after");

        assertThat(matcher.find()).isTrue();
        assertThat(matcher.group(ExamplePlaceholder.NAME_GROUP)).isEqualTo("Hello_World2");
        assertThat(matcher.group(ExamplePlaceholder.EXTENSION_GROUP)).isEqualTo("jsx");
    }

    @Test
    void onlyTheExactPlaceholderFormMatches() {
        for (String text : new String[]{"{{ A.java }}", "{{A-b.java}}", "{{A.java}", "{A.java}}", "{{A}}",
                "{{A.b.java}}", "{{path/A.java}}"}) {
            assertThat(ExamplePlaceholder.PATTERN.matcher(text).find()).as(text).isFalse();
        }
    }
}

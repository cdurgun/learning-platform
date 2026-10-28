package com.cdurgun.learning.service.ai;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.ai.LessonContextBuilder.LessonContext;
import com.cdurgun.learning.service.ai.LessonContextBuilder.Result;
import com.cdurgun.learning.service.ai.LessonContextBuilder.Status;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * {@link LessonContextBuilder}, gerçek Flyway şeması (yayın bayrakları) ve gerçek sınıf yolu
 * içeriğiyle. Yalnızca okur; hiçbir satır yazmaz.
 */
@SpringBootTest
@ActiveProfiles("test")
class LessonContextBuilderIntegrationTest {

    /** application.yml: ai.tutor.limits.max-context-chars */
    private static final int MAX = 60_000;

    @Autowired
    private LessonContextBuilder builder;
    @Autowired
    private TopicTranslationRepository translations;
    @Autowired
    private JdbcTemplate jdbc;

    private static String resource(String path) throws IOException {
        try (InputStream in = LessonContextBuilderIntegrationTest.class.getResourceAsStream("/" + path)) {
            assertThat(in).as(path).isNotNull();
            return new String(in.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    private static String html(String markdown) {
        return HtmlRenderer.builder().build().render(Parser.builder().build().parse(markdown));
    }

    private String dbTitle(String slug, Language language) {
        return jdbc.queryForObject("""
                SELECT tt.title FROM topic_translation tt JOIN topic t ON t.id = tt.topic_id
                WHERE t.slug = ? AND tt.language = ?""", String.class, slug, language.getCode());
    }

    @Test
    void englishEnumLessonIsTheRealFileWithItsRealExamples() throws IOException {
        LessonContext lesson = builder.build("enum", Language.EN, MAX).context();
        String markdown = resource("content/en/enum.md");

        assertThat(lesson.title()).isEqualTo(dbTitle("enum", Language.EN));
        assertThat(lesson.content()).startsWith(markdown.substring(0, markdown.indexOf("{{")));
        assertThat(lesson.content()).doesNotContain("{{").doesNotContain("unavailable]");
        assertThat(lesson.examples()).isEqualTo(11);
        assertThat(lesson.examplesOmitted()).isZero();
        assertThat(lesson.truncated()).isFalse();

        String firstExample = markdown.substring(markdown.indexOf("{{") + 2, markdown.indexOf("}}"));
        String code = resource("examples/enum/" + firstExample).stripTrailing();
        assertThat(lesson.content()).contains("```java\n" + code + "\n```");
    }

    @Test
    void turkishEnumLessonIsTheTurkishFileNotTheEnglishOne() throws IOException {
        LessonContext tr = builder.build("enum", Language.TR, MAX).context();
        LessonContext en = builder.build("enum", Language.EN, MAX).context();
        String markdown = resource("content/tr/enum.md");

        assertThat(tr.language()).isEqualTo(Language.TR);
        assertThat(tr.title()).isEqualTo(dbTitle("enum", Language.TR));
        assertThat(tr.content()).startsWith(markdown.substring(0, markdown.indexOf("{{")));
        assertThat(tr.content()).isNotEqualTo(en.content());
        assertThat(tr.examples()).isEqualTo(11);
    }

    @Test
    void unknownTopicIsNotFound() {
        assertThat(builder.build("no-such-topic-xyz", Language.EN, MAX).status()).isEqualTo(Status.TOPIC_NOT_FOUND);
    }

    @Test
    void aDraftTranslationIsNotPublished() {
        List<Map<String, Object>> drafts = jdbc.queryForList("""
                SELECT t.slug, tt.language FROM topic_translation tt JOIN topic t ON t.id = tt.topic_id
                WHERE NOT tt.published LIMIT 1""");
        assumeTrue(!drafts.isEmpty(), "no draft translation in this database");
        String slug = (String) drafts.getFirst().get("slug");
        Language language = Language.fromCode((String) drafts.getFirst().get("language"));

        assertThat(builder.build(slug, language, MAX).status()).isEqualTo(Status.NOT_PUBLISHED);
    }

    @Test
    void theLongestLessonDropsTrailingExamplesButKeepsItsText() throws IOException {
        LessonContext lesson = builder.build("transaction-management", Language.EN, MAX).context();
        String markdown = resource("content/en/transaction-management.md");

        assertThat(lesson.contentChars()).isLessThanOrEqualTo(MAX);
        assertThat(lesson.examplesOmitted()).isPositive().isLessThan(lesson.examples());
        assertThat(lesson.truncated()).isFalse();
        // İlk örnek kodu korunur, metnin sonu kesilmez.
        assertThat(lesson.content()).startsWith(markdown.substring(0, markdown.indexOf("{{")) + "```");
        assertThat(lesson.content()).endsWith(markdown.substring(markdown.lastIndexOf("}}") + 2));
        assertThat(html(lesson.content())).contains("<p>[example ").doesNotContain("{{");
    }

    @Test
    void everyPublishedLessonBuildsWithinTheLimitWithItsStructureIntact() {
        List<String> problems = new ArrayList<>();
        int checked = 0;
        for (TopicTranslation translation : translations.findAllPublishedWithTopic()) {
            String slug = translation.getTopic().getSlug();
            Result result = builder.build(slug, translation.getLanguage(), MAX);
            String id = slug + "/" + translation.getLanguage().getCode();
            checked++;
            if (!result.available()) {
                problems.add(id + ": " + result.status());
                continue;
            }
            LessonContext lesson = result.context();
            if (lesson.contentChars() > MAX) {
                problems.add(id + ": " + lesson.contentChars() + " chars");
            }
            if (lesson.content().contains("unavailable]")) {
                problems.add(id + ": an example file could not be read");
            }
            // İşaretler hiçbir zaman bir code block'un içinde kalmamalı: CommonMark onları paragraf görür.
            String html = html(lesson.content());
            long markers = lesson.examplesOmitted() + (lesson.truncated() ? 1 : 0);
            long paragraphs = html.split("<p>\\[(?:example [^\\]]+ omitted|lesson truncated)]</p>", -1).length - 1;
            if (paragraphs != markers) {
                problems.add(id + ": " + markers + " markers but " + paragraphs + " as paragraphs");
            }
        }
        assertThat(checked).isGreaterThan(300);
        assertThat(problems).isEmpty();
    }
}

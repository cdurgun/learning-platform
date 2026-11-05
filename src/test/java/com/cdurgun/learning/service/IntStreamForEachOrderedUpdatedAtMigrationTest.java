package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.function.Predicate;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * functional-interfaces-streams/V1158'in yalnızca IntStreamCreationExample'ı forEachOrdered()'a
 * geçirilen primitive-parallel-streams dersinin TR+EN çevirilerini (iki satır) ilerlettiğini
 * doğrular. Migration zaten uygulanmış olduğundan iki satır önce V1158 öncesindeki değerlerine
 * geri çekilir ve gerçek V1158 SQL dosyası yeniden çalıştırılır. {@code @Transactional} -- tüm değişiklikler test sonunda geri
 * alınır.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class IntStreamForEachOrderedUpdatedAtMigrationTest {

    private static final String TARGET_DATE = "2026-11-05";
    private static final String PUBLISHED_AT = "2026-08-17";

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /** slug|dil|published_at|updated_at, tüm çeviriler. */
    private List<String> allDates() {
        return jdbcTemplate.queryForList("""
                SELECT t.slug || '|' || tt.language || '|' || tt.published_at || '|' || tt.updated_at
                FROM topic_translation tt JOIN topic t ON t.id = tt.topic_id
                ORDER BY t.slug, tt.language
                """, String.class);
    }

    private static Predicate<String> targeted() {
        return row -> row.startsWith("primitive-parallel-streams|");
    }

    private static String migrationSql() throws IOException {
        return new ClassPathResource(
                "db/migration/functional-interfaces-streams/V1158__advance_updated_at_for_intstream_creation_foreachordered.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }

    private void setUpdatedAt(String language, String date) {
        jdbcTemplate.update("""
                UPDATE topic_translation SET updated_at = CAST(? AS DATE)
                WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams') AND language = ?
                """, date, language);
    }

    @Test
    void theTwoTargetTranslationsCarryTheNewDate() {
        assertThat(allDates()).filteredOn(targeted())
                .containsExactly("primitive-parallel-streams|en|" + PUBLISHED_AT + "|" + TARGET_DATE,
                        "primitive-parallel-streams|tr|" + PUBLISHED_AT + "|" + TARGET_DATE);
    }

    @Test
    void migrationTouchesExactlyTheTwoTargetRowsAndIsIdempotent() throws IOException {
        // V1158 öncesindeki değerler: EN 2026-10-18, TR 2026-10-18 (V1139).
        setUpdatedAt("en", "2026-10-18");
        setUpdatedAt("tr", "2026-10-18");
        List<String> before = allDates();

        assertThat(jdbcTemplate.update(migrationSql())).isEqualTo(2);
        assertThat(jdbcTemplate.update(migrationSql())).isZero();

        List<String> after = allDates();
        assertThat(after).hasSameSizeAs(before);
        assertThat(after).filteredOn(targeted().negate())
                .containsExactlyElementsOf(before.stream().filter(targeted().negate()).toList());
        assertThat(after).filteredOn(targeted())
                .containsExactly("primitive-parallel-streams|en|" + PUBLISHED_AT + "|" + TARGET_DATE,
                        "primitive-parallel-streams|tr|" + PUBLISHED_AT + "|" + TARGET_DATE);
    }

    @Test
    void migrationNeverMovesANewerDateBack() throws IOException {
        setUpdatedAt("en", "2026-11-06");
        setUpdatedAt("tr", "2026-10-18");

        assertThat(jdbcTemplate.update(migrationSql())).isEqualTo(1);

        assertThat(allDates()).filteredOn(targeted())
                .containsExactly("primitive-parallel-streams|en|" + PUBLISHED_AT + "|2026-11-06",
                        "primitive-parallel-streams|tr|" + PUBLISHED_AT + "|" + TARGET_DATE);
    }
}

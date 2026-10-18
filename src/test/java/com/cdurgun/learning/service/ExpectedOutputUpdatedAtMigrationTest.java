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
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * functional-interfaces-streams/V1139'un yalnızca "Beklenen Çıktı" paneli eklenen üç dersin
 * TR+EN çevirilerini (altı satır) ilerlettiğini doğrular. Migration zaten uygulanmış olduğundan
 * altı satır önce V1137'deki değerlerine geri çekilir ve gerçek V1139 SQL dosyası yeniden
 * çalıştırılır. {@code @Transactional} -- tüm değişiklikler test sonunda geri alınır.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ExpectedOutputUpdatedAtMigrationTest {

    private static final String TARGET_DATE = "2026-10-18";
    private static final Set<String> TARGET_SLUGS =
            Set.of("primitive-parallel-streams", "built-in-functional-interfaces", "collectors");

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
        return row -> TARGET_SLUGS.contains(row.substring(0, row.indexOf('|')));
    }

    private static String migrationSql() throws IOException {
        return new ClassPathResource(
                "db/migration/functional-interfaces-streams/V1139__advance_updated_at_for_expected_output_panels.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }

    @Test
    void theSixTargetTranslationsCarryTheNewDate() {
        assertThat(allDates()).filteredOn(targeted()).containsExactly(
                "built-in-functional-interfaces|en|2026-08-17|" + TARGET_DATE,
                "built-in-functional-interfaces|tr|2026-08-17|" + TARGET_DATE,
                "collectors|en|2026-08-17|" + TARGET_DATE,
                "collectors|tr|2026-08-17|" + TARGET_DATE,
                "primitive-parallel-streams|en|2026-08-17|" + TARGET_DATE,
                "primitive-parallel-streams|tr|2026-08-17|" + TARGET_DATE);
    }

    @Test
    void migrationTouchesExactlyTheSixTargetRowsAndIsIdempotent() throws IOException {
        // V1137'deki değerler.
        for (Map.Entry<String, String> previous : Map.of(
                "built-in-functional-interfaces", "2026-08-17",
                "collectors", "2026-08-17",
                "primitive-parallel-streams", "2026-08-17").entrySet()) {
            jdbcTemplate.update("""
                    UPDATE topic_translation SET updated_at = CAST(? AS DATE)
                    WHERE topic_id = (SELECT id FROM topic WHERE slug = ?)
                    """, previous.getValue(), previous.getKey());
        }
        jdbcTemplate.update("""
                UPDATE topic_translation SET updated_at = DATE '2026-10-06'
                WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams') AND language = 'tr'
                """);
        List<String> before = allDates();

        assertThat(jdbcTemplate.update(migrationSql())).isEqualTo(6);
        assertThat(jdbcTemplate.update(migrationSql())).isZero();

        List<String> after = allDates();
        assertThat(after).hasSameSizeAs(before);
        assertThat(after).filteredOn(targeted().negate())
                .containsExactlyElementsOf(before.stream().filter(targeted().negate()).toList());
        assertThat(after).filteredOn(targeted()).hasSize(6).allSatisfy(row -> assertThat(row).endsWith("|" + TARGET_DATE));
    }
}

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
 * control-flow/V1143'ün yalnızca "Beklenen Çıktı" paneli eklenen altı control-flow dersinin
 * TR+EN çevirilerini (on iki satır) ilerlettiğini doğrular. Migration zaten uygulanmış
 * olduğundan on iki satır önce V1143 öncesindeki değerlerine geri çekilir ve gerçek V1143 SQL
 * dosyası yeniden çalıştırılır. {@code @Transactional} -- tüm değişiklikler test sonunda geri alınır.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ControlFlowExpectedOutputUpdatedAtMigrationTest {

    private static final String TARGET_DATE = "2026-10-19";
    private static final Set<String> TARGET_SLUGS =
            Set.of("if-else", "switch", "for-loop", "enhanced-for-loop", "while-do-while", "nested-loops");

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
                "db/migration/control-flow/V1143__advance_updated_at_for_control_flow_expected_outputs.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }

    @Test
    void theTwelveTargetTranslationsCarryTheNewDate() {
        assertThat(allDates()).filteredOn(targeted()).hasSize(12)
                .allSatisfy(row -> assertThat(row).endsWith("|2026-08-23|" + TARGET_DATE));
    }

    @Test
    void migrationTouchesExactlyTheTwelveTargetRowsAndIsIdempotent() throws IOException {
        // V1143 öncesindeki değerler: EN çevirileri 2026-08-23 (switch 2026-10-05), TR çevirileri
        // 2026-10-06 (while-do-while 2026-08-23).
        for (String slug : TARGET_SLUGS) {
            jdbcTemplate.update("""
                    UPDATE topic_translation SET updated_at = DATE '2026-08-23'
                    WHERE topic_id = (SELECT id FROM topic WHERE slug = ?)
                    """, slug);
        }
        for (Map.Entry<String, String> previous : Map.of(
                "switch|en", "2026-10-05",
                "if-else|tr", "2026-10-06",
                "switch|tr", "2026-10-06",
                "for-loop|tr", "2026-10-06",
                "enhanced-for-loop|tr", "2026-10-06",
                "nested-loops|tr", "2026-10-06").entrySet()) {
            String[] key = previous.getKey().split("\\|");
            jdbcTemplate.update("""
                    UPDATE topic_translation SET updated_at = CAST(? AS DATE)
                    WHERE topic_id = (SELECT id FROM topic WHERE slug = ?) AND language = ?
                    """, previous.getValue(), key[0], key[1]);
        }
        List<String> before = allDates();

        assertThat(jdbcTemplate.update(migrationSql())).isEqualTo(12);
        assertThat(jdbcTemplate.update(migrationSql())).isZero();

        List<String> after = allDates();
        assertThat(after).hasSameSizeAs(before);
        assertThat(after).filteredOn(targeted().negate())
                .containsExactlyElementsOf(before.stream().filter(targeted().negate()).toList());
        assertThat(after).filteredOn(targeted()).hasSize(12)
                .allSatisfy(row -> assertThat(row).endsWith("|2026-08-23|" + TARGET_DATE));
    }
}

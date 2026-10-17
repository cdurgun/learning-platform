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

import static org.assertj.core.api.Assertions.assertThat;

/**
 * enum/V1138'in davranışını doğrular -- yalnızca "migration zaten çalıştı, metin temiz"
 * durumuna bakmak yetmez (fixture'ı migration'ın kendisi düzeltmiş olurdu). Bu yüzden
 * satır, question-promotion/V431'in ORİJİNAL bozuk metnine geri çekilip gerçek V1138
 * SQL dosyası yeniden çalıştırılıyor. {@code @Transactional} -- tüm değişiklikler test
 * sonunda geri alınır.
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class EnumCodeFenceMigrationTest {

    private static final String CLEAN_TEXT = "What will be the output of the following code?";
    private static final String FENCE = "```";

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private Long enumCodeOutputQuestionId(String language) {
        return jdbcTemplate.queryForObject("""
                SELECT q.id FROM question q JOIN topic t ON t.id = q.topic_id
                WHERE t.slug = 'enum' AND q.language = ? AND q.type = 'CODE_OUTPUT'
                  AND q.code_snippet LIKE '%Day.valueOf("FRIDAY")%'
                """, Long.class, language);
    }

    private Map<String, Object> preservedFields(Long id) {
        return jdbcTemplate.queryForMap(
                "SELECT code_snippet, code_language, explanation, type, difficulty, status FROM question WHERE id = ?", id);
    }

    private List<Map<String, Object>> options(Long id) {
        return jdbcTemplate.queryForList(
                "SELECT option_text, is_correct, sort_order FROM question_option WHERE question_id = ? ORDER BY sort_order", id);
    }

    private String questionText(Long id) {
        return jdbcTemplate.queryForObject("SELECT question FROM question WHERE id = ?", String.class, id);
    }

    private static String migrationSql() throws IOException {
        return new ClassPathResource("db/migration/enum/V1138__strip_code_fence_from_enum_code_output_question.sql")
                .getContentAsString(StandardCharsets.UTF_8);
    }

    @Test
    void migratedEnglishEnumQuestionHasExactlyTheCleanSentence() {
        assertThat(questionText(enumCodeOutputQuestionId("en"))).isEqualTo(CLEAN_TEXT);
    }

    @Test
    void migrationStripsTheFenceOnceAndPreservesEverythingElse() throws IOException {
        Long id = enumCodeOutputQuestionId("en");
        Long trId = enumCodeOutputQuestionId("tr");
        Map<String, Object> fieldsBefore = preservedFields(id);
        List<Map<String, Object>> optionsBefore = options(id);
        String snippet = (String) fieldsBefore.get("code_snippet");

        // V431'in orijinal (bozuk) metnini geri yükle; TR satırına da bir fence koy --
        // migration yalnızca EN satırını düzeltmeli.
        String fenced = CLEAN_TEXT + "\n\n" + FENCE + "java\n" + snippet + "\n" + FENCE;
        jdbcTemplate.update("UPDATE question SET question = ? WHERE id = ?", fenced, id);
        String trFenced = "Aşağıdaki kodun çıktısı ne olacaktır?\n\n" + FENCE + "java\n" + snippet + "\n" + FENCE;
        jdbcTemplate.update("UPDATE question SET question = ? WHERE id = ?", trFenced, trId);

        assertThat(jdbcTemplate.update(migrationSql())).isEqualTo(1);
        assertThat(jdbcTemplate.update(migrationSql())).isZero();

        assertThat(questionText(id)).isEqualTo(CLEAN_TEXT);
        assertThat(preservedFields(id)).isEqualTo(fieldsBefore);
        assertThat(options(id)).isEqualTo(optionsBefore);
        assertThat(options(id)).filteredOn(o -> Boolean.TRUE.equals(o.get("is_correct")))
                .extracting(o -> o.get("option_text")).containsExactly("FRIDAY");
        assertThat(questionText(trId)).isEqualTo(trFenced);
    }

    @Test
    void noCodeOutputQuestionWithASnippetContainsARawCodeFence() {
        List<String> offenders = jdbcTemplate.queryForList("""
                SELECT t.slug || '/' || q.language || ': ' || left(q.question, 60)
                FROM question q JOIN topic t ON t.id = q.topic_id
                WHERE q.type = 'CODE_OUTPUT' AND q.code_snippet IS NOT NULL AND q.code_snippet <> ''
                  AND position(? IN q.question) > 0
                """, String.class, FENCE);
        assertThat(offenders).isEmpty();
    }
}

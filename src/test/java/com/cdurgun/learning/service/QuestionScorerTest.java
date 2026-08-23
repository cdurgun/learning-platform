package com.cdurgun.learning.service;

import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class QuestionScorerTest {

    @Test
    void singleChoiceExactMatchIsCorrect() {
        assertThat(QuestionScorer.isCorrect(Set.of(1L), Set.of(1L))).isTrue();
    }

    @Test
    void singleChoiceWrongOptionIsIncorrect() {
        assertThat(QuestionScorer.isCorrect(Set.of(1L), Set.of(2L))).isFalse();
    }

    @Test
    void multipleChoiceExactSetMatchIsCorrect() {
        assertThat(QuestionScorer.isCorrect(Set.of(1L, 2L, 3L), Set.of(3L, 1L, 2L))).isTrue();
    }

    @Test
    void multipleChoicePartialSelectionIsIncorrect() {
        // Yalnızca doğru şıklardan bazılarını seçmek KABUL EDİLMEZ -- tam küme
        // eşleşmesi gerekir (bkz. plan bölüm 5.1).
        assertThat(QuestionScorer.isCorrect(Set.of(1L, 2L, 3L), Set.of(1L, 2L))).isFalse();
    }

    @Test
    void multipleChoiceExtraWrongSelectionIsIncorrect() {
        // Tüm doğru şıklar seçilmiş olsa bile FAZLADAN yanlış bir şık seçildiyse
        // yanlış sayılır.
        assertThat(QuestionScorer.isCorrect(Set.of(1L, 2L), Set.of(1L, 2L, 4L))).isFalse();
    }

    @Test
    void emptySelectionAgainstNonEmptyCorrectSetIsIncorrect() {
        assertThat(QuestionScorer.isCorrect(Set.of(1L), Set.of())).isFalse();
    }
}

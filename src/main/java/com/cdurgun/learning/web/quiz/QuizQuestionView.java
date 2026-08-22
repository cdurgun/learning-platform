package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * Quiz'in GET-render (submit öncesi) görünümü — {@code explanation} ve doğru şık
 * kasıtlı olarak burada YOK, yalnızca submit sonrası {@link QuizQuestionResult} ile döner.
 */
public record QuizQuestionView(Long id, String question, List<QuizOptionView> options) {
}

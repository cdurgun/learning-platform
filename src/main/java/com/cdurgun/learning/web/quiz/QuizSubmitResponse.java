package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * POST /{lang}/topics/enum/quiz/submit 200 yanıt gövdesi.
 */
public record QuizSubmitResponse(int score, int total, boolean passed, List<QuizQuestionResult> results) {
}

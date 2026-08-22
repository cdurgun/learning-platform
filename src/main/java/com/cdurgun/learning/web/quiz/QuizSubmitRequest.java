package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * POST /{lang}/topics/enum/quiz/submit istek gövdesi.
 */
public record QuizSubmitRequest(List<Long> selectedOptionIds) {
}

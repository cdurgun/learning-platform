package com.cdurgun.learning.web.quiz;

/**
 * Tek bir sorunun submit sonrası sonucu — is_correct client'a önceden değil,
 * yalnızca bu yapı içinde, submit sonrası gönderilir.
 */
public record QuizQuestionResult(Long questionId, Long selectedOptionId, boolean correct,
                                  Long correctOptionId, String explanation) {
}

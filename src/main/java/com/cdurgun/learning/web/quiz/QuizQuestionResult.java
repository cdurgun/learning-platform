package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * Tek bir sorunun submit sonrası sonucu — is_correct client'a önceden değil,
 * yalnızca bu yapı içinde, submit sonrası gönderilir. FAZ B'DEN İTİBAREN:
 * selectedOptionId/correctOptionId (tekil Long) yerine liste — MULTIPLE_CHOICE
 * birden fazla seçili/doğru şık taşıyabilir.
 */
public record QuizQuestionResult(Long questionId, List<Long> selectedOptionIds, boolean correct,
                                  List<Long> correctOptionIds, String explanation) {
}

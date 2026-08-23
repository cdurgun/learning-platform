package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * Tek bir sorunun cevabı — {@code selectedOptionIds} birden fazla eleman
 * taşıyabilir (MULTIPLE_CHOICE), SINGLE_CHOICE/CODE_OUTPUT'ta tam olarak bir eleman
 * beklenir (bkz. QuizService.submit doğrulaması).
 */
public record QuizAnswer(Long questionId, List<Long> selectedOptionIds) {
}

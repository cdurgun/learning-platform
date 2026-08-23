package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * POST /{lang}/topics/{topicSlug}/quiz/{quizSlug}/submit istek gövdesi.
 * FAZ B'DEN İTİBAREN: düz, DOM sırasına dayalı bir selectedOptionIds listesi
 * DEĞİL, her soru için AÇIKÇA gruplu bir cevap listesi (MULTIPLE_CHOICE'ı
 * desteklemek için gerekli — bkz. plan bölüm 5).
 */
public record QuizSubmitRequest(List<QuizAnswer> answers) {
}

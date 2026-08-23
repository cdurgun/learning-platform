package com.cdurgun.learning.web.quiz;

import java.util.List;

/**
 * POST /{lang}/practice/submit 200 yanıt gövdesi. {@link QuizSubmitResponse}'tan
 * farklı olarak {@code passed} YOK -- Practice'in bağlı olduğu bir {@code Quiz}
 * (dolayısıyla bir passThreshold) yok, yalnızca ham skor raporlanır. Her sorunun
 * sonucu AYNI {@link QuizQuestionResult} ile döner (yeni bir model yaratılmadı).
 */
public record PracticeSubmitResponse(int score, int total, List<QuizQuestionResult> results) {
}

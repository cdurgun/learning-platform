package com.cdurgun.learning.web.quiz;

import com.cdurgun.learning.domain.QuestionType;

import java.util.List;

/**
 * Practice havuzundan çekilen tek bir sorunun GET-render görünümü. {@link
 * QuizQuestionView}'ın aksine {@code type} taşır -- client'ın SINGLE_CHOICE için
 * radio, MULTIPLE_CHOICE için checkbox render etmesi gerekir. {@code codeSnippet}/
 * {@code codeLanguage}, yalnızca {@code type == CODE_OUTPUT} olduğunda dolu olur
 * (bkz. {@code Question} entity javadoc'u), diğer tiplerde her zaman null'dır.
 * Şıklar için AYNI {@link QuizOptionView} yeniden kullanılıyor (yeni bir
 * "PracticeOptionView" yaratmaya gerek yok) -- burada da {@code isCorrect}
 * KASITLI OLARAK yok, doğru şık(lar) yalnızca submit sonrası
 * {@link QuizQuestionResult} ile döner.
 */
public record QuestionView(Long id, String question, QuestionType type,
                            String codeSnippet, String codeLanguage,
                            List<QuizOptionView> options) {
}

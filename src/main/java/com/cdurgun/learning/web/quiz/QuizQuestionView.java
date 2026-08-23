package com.cdurgun.learning.web.quiz;

import com.cdurgun.learning.domain.QuestionType;

import java.util.List;

/**
 * Quiz'in GET-render (submit öncesi) görünümü — {@code explanation} ve doğru şık
 * kasıtlı olarak burada YOK, yalnızca submit sonrası {@link QuizQuestionResult} ile döner.
 * {@code type}/{@code codeSnippet}/{@code codeLanguage}, {@link QuestionView}
 * (Practice) ile AYNI amaca hizmet eder -- {@code CODE_OUTPUT} tipi bir soru için
 * topic.html'in kod bloğunu render edebilmesi gerekir. {@code codeSnippet}/
 * {@code codeLanguage} SINGLE_CHOICE/MULTIPLE_CHOICE için her zaman null'dır.
 */
public record QuizQuestionView(Long id, String question, QuestionType type,
                                String codeSnippet, String codeLanguage,
                                List<QuizOptionView> options) {
}

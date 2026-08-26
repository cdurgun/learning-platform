package com.cdurgun.learning.web.review;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class QuestionReviewViewTest {

    private static QuestionReviewView viewOf(String question, String codeSnippet) {
        return new QuestionReviewView(
                1L, question, "explanation", codeSnippet, codeSnippet != null ? "java" : null,
                codeSnippet != null ? QuestionType.CODE_OUTPUT : QuestionType.SINGLE_CHOICE,
                Difficulty.BEGINNER, Language.EN, QuestionSource.OPENAI, QuestionStatus.PENDING_REVIEW,
                "enum", "Enum", null, List.of());
    }

    @Test
    void stripsRedundantFencedCodeBlockWhenCodeSnippetIsPresent() {
        String question = "What will be the output of the following code?\n\n"
                + "```java\nenum Day { MONDAY }\n\nSystem.out.println(Day.MONDAY);\n```";
        QuestionReviewView view = viewOf(question, "enum Day { MONDAY }\n\nSystem.out.println(Day.MONDAY);");

        assertThat(view.questionDisplayText())
                .isEqualTo("What will be the output of the following code?")
                .doesNotContain("```");
    }

    @Test
    void leavesQuestionTextUntouchedWhenNoCodeSnippet() {
        QuestionReviewView view = viewOf("What is an enum in Java?", null);

        assertThat(view.questionDisplayText()).isEqualTo("What is an enum in Java?");
    }

    @Test
    void leavesQuestionTextUntouchedWhenCodeSnippetPresentButQuestionHasNoFencedBlock() {
        QuestionReviewView view = viewOf("What does this code print?", "System.out.println(1);");

        assertThat(view.questionDisplayText()).isEqualTo("What does this code print?");
    }

    @Test
    void fallsBackToOriginalQuestionIfStrippingWouldLeaveItEmpty() {
        String question = "```java\nSystem.out.println(1);\n```";
        QuestionReviewView view = viewOf(question, "System.out.println(1);");

        assertThat(view.questionDisplayText()).isEqualTo(question);
    }
}

package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Quiz;
import com.cdurgun.learning.domain.QuizQuestion;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuizQuestionRepository;
import com.cdurgun.learning.repository.QuizRepository;
import com.cdurgun.learning.web.quiz.QuizAnswer;
import com.cdurgun.learning.web.quiz.QuizQuestionView;
import com.cdurgun.learning.web.quiz.QuizSubmitRequest;
import com.cdurgun.learning.web.quiz.QuizSubmitResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.when;

/**
 * {@code loadQuiz()}'in CODE_OUTPUT sorular için type/codeSnippet/codeLanguage'ı
 * doğru taşıdığını VE SINGLE_CHOICE/MULTIPLE_CHOICE sorularda bu alanların null
 * kalmasının hiçbir şeyi bozmadığını doğrular. Ayrıca {@code submit()} için,
 * quiz.js'in gönderdiği GERÇEK gruplu {@code answers[{questionId,
 * selectedOptionIds}]} sözleşmesini birebir kullanan bir regresyon testi içerir --
 * bu, quiz.js'in eski düz {@code selectedOptionIds} gövdesini göndermeye devam
 * ettiği (backend'in artık kabul etmediği), ama hiçbir Java-seviyesi testin
 * yakalamadığı gerçek bir üretim regresyonunu simüle eder.
 */
@ExtendWith(MockitoExtension.class)
class QuizServiceTest {

    @Mock
    private QuizRepository quizRepository;
    @Mock
    private QuizQuestionRepository quizQuestionRepository;
    @Mock
    private QuestionOptionRepository questionOptionRepository;

    private QuizService newService() {
        return new QuizService(quizRepository, quizQuestionRepository, questionOptionRepository);
    }

    @Test
    void loadQuizExposesCodeSnippetAndCodeLanguageForCodeOutputQuestions() {
        Question codeQuestion = questionOf(1L, QuestionType.CODE_OUTPUT, "System.out.println(1 + 1);", "java");
        QuizQuestion link = QuizQuestion.builder().id(10L).quiz(Quiz.builder().id(5L).build())
                .question(codeQuestion).position(1).build();
        QuestionOption correct = optionOf(100L, codeQuestion, "2", true);
        QuestionOption wrong = optionOf(101L, codeQuestion, "11", false);

        when(quizQuestionRepository.findByQuizIdOrderByPositionAsc(5L)).thenReturn(List.of(link));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L)))
                .thenReturn(List.of(correct, wrong));

        List<QuizQuestionView> views = newService().loadQuiz(5L);

        assertThat(views).hasSize(1);
        QuizQuestionView view = views.get(0);
        assertThat(view.type()).isEqualTo(QuestionType.CODE_OUTPUT);
        assertThat(view.codeSnippet()).isEqualTo("System.out.println(1 + 1);");
        assertThat(view.codeLanguage()).isEqualTo("java");
        // Doğru şık burada da HİÇBİR ZAMAN sızmıyor -- QuizOptionView zaten isCorrect taşımıyor.
        assertThat(view.options()).extracting("id", "optionText")
                .containsExactlyInAnyOrder(
                        org.assertj.core.groups.Tuple.tuple(100L, "2"),
                        org.assertj.core.groups.Tuple.tuple(101L, "11"));
    }

    @Test
    void loadQuizLeavesCodeFieldsNullForSingleChoiceQuestionsWithoutBreaking() {
        Question singleChoiceQuestion = questionOf(2L, QuestionType.SINGLE_CHOICE, null, null);
        QuizQuestion link = QuizQuestion.builder().id(11L).quiz(Quiz.builder().id(5L).build())
                .question(singleChoiceQuestion).position(1).build();
        QuestionOption correct = optionOf(200L, singleChoiceQuestion, "Right", true);

        when(quizQuestionRepository.findByQuizIdOrderByPositionAsc(5L)).thenReturn(List.of(link));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(2L)))
                .thenReturn(List.of(correct));

        List<QuizQuestionView> views = newService().loadQuiz(5L);

        assertThat(views).hasSize(1);
        QuizQuestionView view = views.get(0);
        assertThat(view.type()).isEqualTo(QuestionType.SINGLE_CHOICE);
        assertThat(view.codeSnippet()).isNull();
        assertThat(view.codeLanguage()).isNull();
        assertThat(view.options()).hasSize(1);
    }

    @Test
    void submitAcceptsTheGroupedAnswersContractQuizJsSends() {
        // enum quiz'in gerçek şeklini yansıtan 5 SINGLE_CHOICE soru, her biri 2
        // şıklı (bir doğru + bir yanlış) -- quiz.js artık HER soru için ayrı bir
        // {questionId, selectedOptionIds:[id]} göndermesi gerekiyor, DOM sırasına
        // dayalı düz bir liste DEĞİL.
        Quiz quiz = Quiz.builder().id(5L).passThreshold(new BigDecimal("0.80")).build();

        List<QuizQuestion> links = new ArrayList<>();
        List<QuestionOption> allOptions = new ArrayList<>();
        List<QuizAnswer> answers = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            Question question = questionOf((long) i, QuestionType.SINGLE_CHOICE, null, null);
            QuestionOption correct = optionOf((long) (i * 10), question, "Right " + i, true);
            QuestionOption wrong = optionOf((long) (i * 10 + 1), question, "Wrong " + i, false);
            links.add(QuizQuestion.builder().id((long) (100 + i)).quiz(quiz).question(question).position(i).build());
            allOptions.add(correct);
            allOptions.add(wrong);
            // İlk 4 soruda doğru şık, 5. soruda yanlış şık seçiliyor -> 4/5 = 0.80 = passThreshold.
            long selectedId = (i <= 4) ? correct.getId() : wrong.getId();
            answers.add(new QuizAnswer((long) i, List.of(selectedId)));
        }

        when(quizRepository.findById(5L)).thenReturn(Optional.of(quiz));
        when(quizQuestionRepository.findByQuizIdOrderByPositionAsc(5L)).thenReturn(links);
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L, 2L, 3L, 4L, 5L)))
                .thenReturn(allOptions);
        // İçeride submit edilen option id'leri bir Set'ten yeni bir ArrayList'e
        // kopyalanıyor (bkz. QuizService.submit) -- sıra GARANTİ DEĞİL, bu yüzden
        // burada tam sıra eşleşmesi ARAMIYORUZ, yalnızca çağrının yapıldığını.
        List<Long> submittedOptionIds = answers.stream().flatMap(a -> a.selectedOptionIds().stream()).toList();
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(anyList()))
                .thenReturn(allOptions.stream().filter(o -> submittedOptionIds.contains(o.getId())).toList());

        QuizSubmitResponse response = newService().submit(5L, new QuizSubmitRequest(answers));

        assertThat(response.total()).isEqualTo(5);
        assertThat(response.score()).isEqualTo(4);
        assertThat(response.passed()).isTrue();
        assertThat(response.results()).hasSize(5);
    }

    private static Question questionOf(Long id, QuestionType type, String codeSnippet, String codeLanguage) {
        return Question.builder()
                .id(id)
                .language(Language.EN)
                .type(type)
                .difficulty(Difficulty.INTERMEDIATE)
                .status(QuestionStatus.PUBLISHED)
                .question("question " + id)
                .codeSnippet(codeSnippet)
                .codeLanguage(codeLanguage)
                .explanation("explanation " + id)
                .build();
    }

    private static QuestionOption optionOf(Long id, Question question, String text, boolean correct) {
        return QuestionOption.builder()
                .id(id)
                .question(question)
                .optionText(text)
                .correct(correct)
                .sortOrder(0)
                .build();
    }
}

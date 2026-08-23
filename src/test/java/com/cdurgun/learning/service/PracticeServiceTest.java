package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.quiz.PracticeSubmitRequest;
import com.cdurgun.learning.web.quiz.PracticeSubmitResponse;
import com.cdurgun.learning.web.quiz.QuestionView;
import com.cdurgun.learning.web.quiz.QuizAnswer;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PracticeServiceTest {

    @Mock
    private QuestionRepository questionRepository;
    @Mock
    private QuestionOptionRepository questionOptionRepository;
    @Mock
    private TopicRepository topicRepository;

    private PracticeService newService() {
        return new PracticeService(questionRepository, questionOptionRepository, topicRepository);
    }

    // ---- draw(): filtreler, count sınırlaması, PUBLISHED zorunluluğu ----

    @Test
    void drawDefaultsCountWhenNullOrNonPositive() {
        when(questionRepository.findRandomPublishedPool(isNull(), eq("en"), isNull(), isNull(), eq(10)))
                .thenReturn(List.of());

        newService().draw(Language.EN, null, null, null, null);
        newService().draw(Language.EN, null, null, null, 0);
        newService().draw(Language.EN, null, null, null, -5);

        verify(questionRepository, org.mockito.Mockito.times(3))
                .findRandomPublishedPool(isNull(), eq("en"), isNull(), isNull(), eq(10));
    }

    @Test
    void drawCapsCountAtMaximum() {
        when(questionRepository.findRandomPublishedPool(any(), anyString(), any(), any(), eq(50)))
                .thenReturn(List.of());

        newService().draw(Language.EN, null, null, null, 500);

        verify(questionRepository).findRandomPublishedPool(isNull(), eq("en"), isNull(), isNull(), eq(50));
    }

    @Test
    void drawResolvesTopicSlugToTopicIdAndPassesAllFilters() {
        Topic topic = Topic.builder().id(42L).slug("enum").build();
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(topic));
        when(questionRepository.findRandomPublishedPool(eq(42L), eq("tr"), eq("ADVANCED"), eq("MULTIPLE_CHOICE"), eq(5)))
                .thenReturn(List.of());

        newService().draw(Language.TR, "enum", Difficulty.ADVANCED, QuestionType.MULTIPLE_CHOICE, 5);

        verify(questionRepository).findRandomPublishedPool(42L, "tr", "ADVANCED", "MULTIPLE_CHOICE", 5);
    }

    @Test
    void drawThrowsNotFoundForUnknownTopicSlug() {
        when(topicRepository.findBySlug("does-not-exist")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().draw(Language.EN, "does-not-exist", null, null, null))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("does-not-exist");

        verify(questionRepository, never()).findRandomPublishedPool(any(), any(), any(), any(), anyInt());
    }

    @Test
    void drawMapsRepositoryResultsWithoutLeakingCorrectness() {
        Question question = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        QuestionOption correct = optionOf(10L, question, "Correct", true);
        QuestionOption wrong = optionOf(11L, question, "Wrong", false);

        when(questionRepository.findRandomPublishedPool(any(), anyString(), any(), any(), anyInt()))
                .thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L)))
                .thenReturn(List.of(correct, wrong));

        List<QuestionView> views = newService().draw(Language.EN, null, null, null, null);

        assertThat(views).hasSize(1);
        QuestionView view = views.get(0);
        assertThat(view.id()).isEqualTo(1L);
        assertThat(view.type()).isEqualTo(QuestionType.SINGLE_CHOICE);
        assertThat(view.options()).extracting("id", "optionText")
                .containsExactlyInAnyOrder(
                        org.assertj.core.groups.Tuple.tuple(10L, "Correct"),
                        org.assertj.core.groups.Tuple.tuple(11L, "Wrong"));
        // QuizOptionView'ın kendisi zaten isCorrect taşımıyor (compile-time garanti) --
        // burada ayrıca hiçbir alanın "correct"/"isCorrect" adını taşımadığını teyit
        // ediyoruz ki gelecekte DTO'ya yanlışlıkla eklenirse bu test kırılsın.
        assertThat(view.options().get(0).getClass().getRecordComponents())
                .extracting("name")
                .containsExactly("id", "optionText");
    }

    @Test
    void drawExposesCodeSnippetAndCodeLanguageForCodeOutputQuestions() {
        Question question = Question.builder()
                .id(1L)
                .language(Language.EN)
                .type(QuestionType.CODE_OUTPUT)
                .difficulty(Difficulty.INTERMEDIATE)
                .status(QuestionStatus.PUBLISHED)
                .question("What does this print?")
                .codeSnippet("System.out.println(1 + 1);")
                .codeLanguage("java")
                .explanation("explanation")
                .build();
        when(questionRepository.findRandomPublishedPool(any(), anyString(), any(), any(), anyInt()))
                .thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L))).thenReturn(List.of());

        QuestionView view = newService().draw(Language.EN, null, null, null, null).get(0);

        assertThat(view.type()).isEqualTo(QuestionType.CODE_OUTPUT);
        assertThat(view.codeSnippet()).isEqualTo("System.out.println(1 + 1);");
        assertThat(view.codeLanguage()).isEqualTo("java");
    }

    @Test
    void drawLeavesCodeFieldsNullForNonCodeOutputQuestionsWithoutBreaking() {
        // questionOf(...) codeSnippet/codeLanguage'ı hiç set etmiyor (null kalıyor) --
        // draw()'ın bunu sorunsuz taşıdığını doğrular (nullable alanların normal
        // sorularda hiçbir şeyi bozmadığı garantisi).
        Question question = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        when(questionRepository.findRandomPublishedPool(any(), anyString(), any(), any(), anyInt()))
                .thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L))).thenReturn(List.of());

        QuestionView view = newService().draw(Language.EN, null, null, null, null).get(0);

        assertThat(view.codeSnippet()).isNull();
        assertThat(view.codeLanguage()).isNull();
    }

    @Test
    void drawPreservesRepositoryOrderWithoutReSorting() {
        Question first = questionOf(2L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        Question second = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        when(questionRepository.findRandomPublishedPool(any(), anyString(), any(), any(), anyInt()))
                .thenReturn(List.of(first, second));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(any())).thenReturn(List.of());

        List<QuestionView> views = newService().draw(Language.EN, null, null, null, null);

        // Repository "rastgele" bir sıra döndürdüğünde servis bunu YENİDEN
        // sıralamıyor -- gerçek rastgeleliği DB'nin ORDER BY RANDOM()'ına
        // bırakıyor (bkz. QuestionRepository javadoc).
        assertThat(views).extracting(QuestionView::id).containsExactly(2L, 1L);
    }

    // ---- submit(): doğrulama, PUBLISHED zorunluluğu, single/multiple choice puanlama ----

    @Test
    void submitRejectsEmptyAnswers() {
        assertThatThrownBy(() -> newService().submit(Language.EN, new PracticeSubmitRequest(List.of())))
                .isInstanceOf(ResponseStatusException.class);
    }

    @Test
    void submitRejectsDuplicateQuestionIdInAnswers() {
        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(
                new QuizAnswer(1L, List.of(10L)),
                new QuizAnswer(1L, List.of(11L))));

        assertThatThrownBy(() -> newService().submit(Language.EN, request))
                .isInstanceOf(ResponseStatusException.class);
        verify(questionRepository, never()).findAllById(any());
    }

    @Test
    void submitRejectsNonPublishedQuestion() {
        Question pending = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PENDING_REVIEW);
        when(questionRepository.findAllById(any())).thenReturn(List.of(pending));

        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L))));

        assertThatThrownBy(() -> newService().submit(Language.EN, request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("not published");
    }

    @Test
    void submitRejectsQuestionFromDifferentLanguage() {
        Question trQuestion = questionOf(1L, Language.TR, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        when(questionRepository.findAllById(any())).thenReturn(List.of(trQuestion));

        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L))));

        assertThatThrownBy(() -> newService().submit(Language.EN, request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("does not belong to this language");
    }

    @Test
    void submitScoresSingleChoiceCorrectAndIncorrect() {
        Question q1 = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        Question q2 = questionOf(2L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        QuestionOption q1Correct = optionOf(10L, q1, "Right", true);
        QuestionOption q1Wrong = optionOf(11L, q1, "Wrong", false);
        QuestionOption q2Correct = optionOf(20L, q2, "Right", true);
        QuestionOption q2Wrong = optionOf(21L, q2, "Wrong", false);

        when(questionRepository.findAllById(any())).thenReturn(List.of(q1, q2));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(any()))
                .thenReturn(List.of(q1Correct, q1Wrong, q2Correct, q2Wrong));
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any()))
                .thenReturn(List.of(q1Correct, q2Wrong));

        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(
                new QuizAnswer(1L, List.of(10L)),   // doğru
                new QuizAnswer(2L, List.of(21L))));  // yanlış

        PracticeSubmitResponse response = newService().submit(Language.EN, request);

        assertThat(response.total()).isEqualTo(2);
        assertThat(response.score()).isEqualTo(1);
        assertThat(response.results()).hasSize(2);
        assertThat(response.results()).anySatisfy(r -> {
            if (r.questionId().equals(1L)) {
                assertThat(r.correct()).isTrue();
            } else {
                assertThat(r.correct()).isFalse();
            }
        });
    }

    @Test
    void submitMultipleChoiceRequiresExactSetMatch() {
        Question question = questionOf(1L, Language.EN, QuestionType.MULTIPLE_CHOICE, QuestionStatus.PUBLISHED);
        QuestionOption a = optionOf(10L, question, "A", true);
        QuestionOption b = optionOf(11L, question, "B", true);
        QuestionOption c = optionOf(12L, question, "C", false);

        when(questionRepository.findAllById(any())).thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(any()))
                .thenReturn(List.of(a, b, c));

        // Tam eşleşme (a+b) -> doğru
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any())).thenReturn(List.of(a, b));
        PracticeSubmitResponse exact = newService().submit(Language.EN,
                new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L, 11L)))));
        assertThat(exact.results().get(0).correct()).isTrue();

        // Kısmi seçim (yalnızca a) -> YANLIŞ
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any())).thenReturn(List.of(a));
        PracticeSubmitResponse partial = newService().submit(Language.EN,
                new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L)))));
        assertThat(partial.results().get(0).correct()).isFalse();

        // Fazladan yanlış şık (a+b+c) -> YANLIŞ
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any())).thenReturn(List.of(a, b, c));
        PracticeSubmitResponse extra = newService().submit(Language.EN,
                new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L, 11L, 12L)))));
        assertThat(extra.results().get(0).correct()).isFalse();
    }

    @Test
    void submitRejectsOptionNotBelongingToAnsweredQuestion() {
        Question q1 = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        Question q2 = questionOf(2L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        QuestionOption q2Option = optionOf(20L, q2, "Belongs to q2", true);

        when(questionRepository.findAllById(any())).thenReturn(List.of(q1));
        // q1'e "20" (aslında q2'ye ait) cevabı gönderiliyor.
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any())).thenReturn(List.of(q2Option));

        PracticeSubmitRequest request = new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(20L))));

        assertThatThrownBy(() -> newService().submit(Language.EN, request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("does not belong to question");
    }

    @Test
    void submitAllowsPartialAnswerSetUnlikeFixedQuiz() {
        // Practice, sabit quiz'in aksine "tüm sorular cevaplanmalı" kuralına tabi
        // değil -- tek bir soruyu submit etmek başlı başına yeterli ve GEÇERLİ.
        Question question = questionOf(1L, Language.EN, QuestionType.SINGLE_CHOICE, QuestionStatus.PUBLISHED);
        QuestionOption correct = optionOf(10L, question, "Right", true);

        when(questionRepository.findAllById(any())).thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(any())).thenReturn(List.of(correct));
        when(questionOptionRepository.findByIdInWithQuestionAndTopic(any())).thenReturn(List.of(correct));

        PracticeSubmitResponse response = newService().submit(Language.EN,
                new PracticeSubmitRequest(List.of(new QuizAnswer(1L, List.of(10L)))));

        assertThat(response.total()).isEqualTo(1);
        assertThat(response.score()).isEqualTo(1);
    }

    private static Question questionOf(Long id, Language language, QuestionType type, QuestionStatus status) {
        return Question.builder()
                .id(id)
                .language(language)
                .type(type)
                .difficulty(Difficulty.INTERMEDIATE)
                .status(status)
                .question("question " + id)
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

package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.QuizDefinition;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.QuizDefinitionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.quiz.QuestionView;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * {@link QuizDefinitionService#draw} yalnızca "slug -> (courseId, categoryIds-or-null)"
 * kapsam çözümünü ve {@link QuestionRepository#findRandomPublishedPoolByCourseAndCategories}
 * çağrısını test eder -- PUBLISHED/dil filtresi ve "questionCount'tan az varsa hatasız
 * mevcut olanı döner" davranışı sorgunun KENDİSİNDE (native SQL, `LIMIT`/`status='PUBLISHED'`
 * hardcoded) yaşıyor, bu yüzden burada mock'lanan repository'nin "ne döndürdüğü" test
 * edilmiyor -- "servis, repository'nin döndürdüğünü OLDUĞU GİBİ, ek bir filtre/kırpma
 * uygulamadan taşıyor mu" test ediliyor (bkz. Faz 2/3'teki gerçek DB'ye karşı psql
 * doğrulaması, native sorgunun kendisinin doğruluğu için tek doğruluk kaynağı).
 *
 * <p>{@link PracticeService} MOCK DEĞİL, gerçek bir örnek olarak kuruluyor --
 * {@code toQuestionViews} paylaşımının (draw'ın QuestionOption yükleme/DTO'ya çevirme
 * mantığının Practice'le AYNI kod yolunu kullandığının) gerçekten çalıştığını
 * doğrulamak için.</p>
 */
@ExtendWith(MockitoExtension.class)
class QuizDefinitionServiceTest {

    @Mock
    private QuizDefinitionRepository quizDefinitionRepository;
    @Mock
    private QuestionRepository questionRepository;
    @Mock
    private QuestionOptionRepository questionOptionRepository;
    @Mock
    private TopicRepository topicRepository;

    private QuizDefinitionService newService() {
        PracticeService practiceService = new PracticeService(questionRepository, questionOptionRepository, topicRepository);
        return new QuizDefinitionService(quizDefinitionRepository, questionRepository, practiceService);
    }

    @Test
    void drawThrowsNotFoundForUnknownOrInactiveSlug() {
        when(quizDefinitionRepository.findBySlugAndActiveTrue("missing")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().draw(Language.EN, "missing"))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("missing");
    }

    @Test
    void drawResolvesWholeCourseScopeWhenCategoriesEmpty() {
        QuizDefinition definition = definitionOf("all-java", 20, Set.of());
        when(quizDefinitionRepository.findBySlugAndActiveTrue("all-java")).thenReturn(Optional.of(definition));
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(eq(1L), isNull(), eq("en"), isNull(), isNull(), eq(20)))
                .thenReturn(List.of());

        newService().draw(Language.EN, "all-java");

        // "Boş kategori kümesi = tüm kurs" -- categoryIds parametresi null geçilmeli.
        verify(questionRepository).findRandomPublishedPoolByCourseAndCategories(1L, null, "en", null, null, 20);
    }

    @Test
    void drawResolvesCategoryScopeWhenCategoriesNonEmpty() {
        Category category = categoryOf(100L, "java-basics");
        QuizDefinition definition = definitionOf("basic-java", 10, Set.of(category));
        when(quizDefinitionRepository.findBySlugAndActiveTrue("basic-java")).thenReturn(Optional.of(definition));
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(eq(1L), any(Long[].class), eq("en"), isNull(), isNull(), eq(10)))
                .thenReturn(List.of());

        newService().draw(Language.EN, "basic-java");

        ArgumentCaptor<Long[]> categoryIdsCaptor = ArgumentCaptor.forClass(Long[].class);
        verify(questionRepository).findRandomPublishedPoolByCourseAndCategories(
                eq(1L), categoryIdsCaptor.capture(), eq("en"), isNull(), isNull(), eq(10));
        assertThat(categoryIdsCaptor.getValue()).containsExactly(100L);
    }

    @Test
    void drawPassesRequestedLanguageThroughToRepository() {
        QuizDefinition definition = definitionOf("all-java", 20, Set.of());
        when(quizDefinitionRepository.findBySlugAndActiveTrue("all-java")).thenReturn(Optional.of(definition));
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(eq(1L), isNull(), eq("tr"), isNull(), isNull(), eq(20)))
                .thenReturn(List.of());

        newService().draw(Language.TR, "all-java");

        verify(questionRepository).findRandomPublishedPoolByCourseAndCategories(1L, null, "tr", null, null, 20);
    }

    @Test
    void drawReturnsFewerQuestionsThanRequestedWithoutErrorOrPadding() {
        QuizDefinition definition = definitionOf("basic-java", 10, Set.of(categoryOf(100L, "java-basics")));
        when(quizDefinitionRepository.findBySlugAndActiveTrue("basic-java")).thenReturn(Optional.of(definition));
        Question onlyOneAvailable = questionOf(1L);
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(any(), any(), any(), any(), any(), eq(10)))
                .thenReturn(List.of(onlyOneAvailable));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L))).thenReturn(List.of());

        List<QuestionView> views = newService().draw(Language.EN, "basic-java");

        // questionCount=10 istendi ama repository yalnızca 1 döndürdü -- servis bunu
        // ne bir hataya çeviriyor ne de eksik kalanı doldurmaya çalışıyor.
        assertThat(views).hasSize(1);
    }

    @Test
    void drawReturnsEmptyListWhenNoEligibleQuestionsExist() {
        QuizDefinition definition = definitionOf("advanced-java", 10,
                Set.of(categoryOf(200L, "exceptions"), categoryOf(201L, "generics")));
        when(quizDefinitionRepository.findBySlugAndActiveTrue("advanced-java")).thenReturn(Optional.of(definition));
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(any(), any(), any(), any(), any(), eq(10)))
                .thenReturn(List.of());

        List<QuestionView> views = newService().draw(Language.EN, "advanced-java");

        // Boş sonuç bir hata DEĞİL -- geçerli bir durum (ilgili kategorilerde henüz
        // PUBLISHED soru yok), UI katmanı bunu dostane bir mesajla karşılar.
        assertThat(views).isEmpty();
    }

    @Test
    void drawDoesNotExposeCorrectnessBeforeSubmit() {
        QuizDefinition definition = definitionOf("basic-java", 10, Set.of(categoryOf(100L, "java-basics")));
        when(quizDefinitionRepository.findBySlugAndActiveTrue("basic-java")).thenReturn(Optional.of(definition));
        Question question = questionOf(1L);
        QuestionOption correct = QuestionOption.builder().id(10L).question(question).optionText("Right").correct(true).sortOrder(0).build();
        QuestionOption wrong = QuestionOption.builder().id(11L).question(question).optionText("Wrong").correct(false).sortOrder(1).build();
        when(questionRepository.findRandomPublishedPoolByCourseAndCategories(any(), any(), any(), any(), any(), eq(10)))
                .thenReturn(List.of(question));
        when(questionOptionRepository.findByQuestionIdInOrderBySortOrderAsc(List.of(1L))).thenReturn(List.of(correct, wrong));

        QuestionView view = newService().draw(Language.EN, "basic-java").get(0);

        // QuizOptionView (draw'ın döndürdüğü seçenek view'ı) yalnızca id+optionText
        // taşır -- "correct"/"isCorrect" alanı derleme zamanında bile YOK.
        assertThat(view.options().get(0).getClass().getRecordComponents())
                .extracting("name")
                .containsExactly("id", "optionText");
    }

    private static QuizDefinition definitionOf(String slug, int questionCount, Set<Category> categories) {
        Course course = Course.builder().id(1L).name("Java").slug("java").sortOrder(1).build();
        return QuizDefinition.builder()
                .id(1L)
                .course(course)
                .slug(slug)
                .questionCount(questionCount)
                .active(true)
                .sortOrder(1)
                .categories(categories)
                .build();
    }

    private static Category categoryOf(Long id, String slug) {
        return Category.builder().id(id).name(slug).slug(slug).sortOrder(1).build();
    }

    private static Question questionOf(Long id) {
        return Question.builder()
                .id(id)
                .language(Language.EN)
                .type(QuestionType.SINGLE_CHOICE)
                .difficulty(Difficulty.BEGINNER)
                .status(QuestionStatus.PUBLISHED)
                .question("question " + id)
                .explanation("explanation " + id)
                .build();
    }
}

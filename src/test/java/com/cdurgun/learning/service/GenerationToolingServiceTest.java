package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.internal.ExistingQuestionView;
import com.cdurgun.learning.web.internal.TopicMetadataResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class GenerationToolingServiceTest {

    @Mock
    private TopicRepository topicRepository;
    @Mock
    private ContentResolver contentResolver;
    @Mock
    private QuestionRepository questionRepository;

    private GenerationToolingService newService() {
        return new GenerationToolingService(topicRepository, contentResolver, questionRepository);
    }

    private static Topic enumTopic() {
        Course course = Course.builder().id(1L).slug("java").name("Java").sortOrder(1).build();
        Category category = Category.builder().id(1L).course(course).slug("java-basics").name("Java Basics").sortOrder(1).build();
        return Topic.builder().id(7L).slug("enum").category(category).difficulty(Difficulty.INTERMEDIATE).estimatedMinutes(25).build();
    }

    @Test
    void getMetadataReturnsSlugDifficultyCategoryAndCourse() {
        when(topicRepository.findBySlugWithCategoryAndCourse("enum")).thenReturn(Optional.of(enumTopic()));

        TopicMetadataResponse response = newService().getMetadata("enum");

        assertThat(response.slug()).isEqualTo("enum");
        assertThat(response.difficulty()).isEqualTo("INTERMEDIATE");
        assertThat(response.categorySlug()).isEqualTo("java-basics");
        assertThat(response.courseSlug()).isEqualTo("java");
        assertThat(response.estimatedMinutes()).isEqualTo(25);
    }

    @Test
    void getMetadataThrowsNotFoundForUnknownSlug() {
        when(topicRepository.findBySlugWithCategoryAndCourse("does-not-exist")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().getMetadata("does-not-exist"))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("does-not-exist");
    }

    @Test
    void getContentReturnsRawMarkdownForKnownTopicAndLanguage() {
        when(topicRepository.findBySlugWithCategoryAndCourse("enum")).thenReturn(Optional.of(enumTopic()));
        when(contentResolver.resolve("enum", Language.EN)).thenReturn(Optional.of("# Enum\n\nBody text."));

        String content = newService().getContent("enum", "en");

        assertThat(content).isEqualTo("# Enum\n\nBody text.");
    }

    @Test
    void getContentThrowsNotFoundWhenTopicExistsButContentFileMissing() {
        when(topicRepository.findBySlugWithCategoryAndCourse("enum")).thenReturn(Optional.of(enumTopic()));
        when(contentResolver.resolve("enum", Language.TR)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().getContent("enum", "tr"))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("no content file");
    }

    @Test
    void getContentRejectsInvalidLanguage() {
        when(topicRepository.findBySlugWithCategoryAndCourse("enum")).thenReturn(Optional.of(enumTopic()));

        assertThatThrownBy(() -> newService().getContent("enum", "fr"))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("invalid language");
    }

    @Test
    void listExistingReturnsIdAndQuestionTextOnlyRegardlessOfStatus() {
        when(topicRepository.findBySlugWithCategoryAndCourse("enum")).thenReturn(Optional.of(enumTopic()));
        Question published = questionOf(1L, QuestionStatus.PUBLISHED, "Published question?");
        Question pending = questionOf(2L, QuestionStatus.PENDING_REVIEW, "Pending question?");
        Question rejected = questionOf(3L, QuestionStatus.REJECTED, "Rejected question?");
        when(questionRepository.findByTopicIdAndLanguage(7L, Language.EN))
                .thenReturn(List.of(published, pending, rejected));

        List<ExistingQuestionView> result = newService().listExisting("enum", "en");

        // Statüye göre HİÇ filtrelenmiyor -- duplicate kontrolü PENDING_REVIEW/REJECTED
        // sorular için de geçerli olmalı ("zaten denenmiş" bir soru).
        assertThat(result).extracting(ExistingQuestionView::id, ExistingQuestionView::question)
                .containsExactlyInAnyOrder(
                        org.assertj.core.groups.Tuple.tuple(1L, "Published question?"),
                        org.assertj.core.groups.Tuple.tuple(2L, "Pending question?"),
                        org.assertj.core.groups.Tuple.tuple(3L, "Rejected question?"));
    }

    private static Question questionOf(Long id, QuestionStatus status, String text) {
        return Question.builder()
                .id(id)
                .language(Language.EN)
                .type(QuestionType.SINGLE_CHOICE)
                .difficulty(Difficulty.INTERMEDIATE)
                .status(status)
                .source(QuestionSource.MANUAL)
                .question(text)
                .explanation("explanation")
                .build();
    }
}

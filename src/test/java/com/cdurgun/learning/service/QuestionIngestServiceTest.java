package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.ingest.QuestionIngestOption;
import com.cdurgun.learning.web.ingest.QuestionIngestRequest;
import com.cdurgun.learning.web.ingest.QuestionIngestResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class QuestionIngestServiceTest {

    @Mock
    private TopicRepository topicRepository;
    @Mock
    private QuestionRepository questionRepository;
    @Mock
    private QuestionOptionRepository questionOptionRepository;

    private QuestionIngestService newService() {
        return new QuestionIngestService(topicRepository, questionRepository, questionOptionRepository);
    }

    private static Topic enumTopic() {
        return Topic.builder().id(7L).slug("enum").build();
    }

    private static QuestionIngestRequest singleChoice(List<QuestionIngestOption> options) {
        return new QuestionIngestRequest("enum", "en", "SINGLE_CHOICE", "INTERMEDIATE",
                "What is an enum?", null, null, "Because.", options);
    }

    private static QuestionIngestRequest multipleChoice(List<QuestionIngestOption> options) {
        return new QuestionIngestRequest("enum", "en", "MULTIPLE_CHOICE", "INTERMEDIATE",
                "Which are true?", null, null, "Because.", options);
    }

    private static QuestionIngestRequest codeOutput(String codeSnippet, List<QuestionIngestOption> options) {
        return new QuestionIngestRequest("enum", "en", "CODE_OUTPUT", "INTERMEDIATE",
                "What does this print?", codeSnippet, "java", "Because.", options);
    }

    private void stubSave() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        when(questionRepository.save(any(Question.class))).thenAnswer(invocation -> {
            Question question = invocation.getArgument(0);
            question.setId(100L);
            return question;
        });
    }

    @Test
    void ingestForcesPendingReviewAndAiSourceRegardlessOfRequest() {
        stubSave();
        QuestionIngestRequest request = singleChoice(List.of(
                new QuestionIngestOption("A", true),
                new QuestionIngestOption("B", false)));

        QuestionIngestResponse response = newService().ingest(request);

        assertThat(response.id()).isEqualTo(100L);
        assertThat(response.status()).isEqualTo(QuestionStatus.PENDING_REVIEW.name());
        assertThat(response.source()).isEqualTo(QuestionSource.AI.name());

        ArgumentCaptor<Question> captor = ArgumentCaptor.forClass(Question.class);
        verify(questionRepository).save(captor.capture());
        assertThat(captor.getValue().getStatus()).isEqualTo(QuestionStatus.PENDING_REVIEW);
        assertThat(captor.getValue().getSource()).isEqualTo(QuestionSource.AI);
    }

    @Test
    void ingestRejectsUnknownTopicSlug() {
        when(topicRepository.findBySlug("does-not-exist")).thenReturn(Optional.empty());
        QuestionIngestRequest request = new QuestionIngestRequest("does-not-exist", "en", "SINGLE_CHOICE",
                "INTERMEDIATE", "Q?", null, null, "Because.",
                List.of(new QuestionIngestOption("A", true), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("does-not-exist");
        verify(questionRepository, never()).save(any());
    }

    @Test
    void ingestRejectsInvalidLanguage() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = new QuestionIngestRequest("enum", "fr", "SINGLE_CHOICE",
                "INTERMEDIATE", "Q?", null, null, "Because.",
                List.of(new QuestionIngestOption("A", true), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("language");
        verify(questionRepository, never()).save(any());
    }

    @Test
    void ingestRejectsInvalidType() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = new QuestionIngestRequest("enum", "en", "NOT_A_TYPE",
                "INTERMEDIATE", "Q?", null, null, "Because.",
                List.of(new QuestionIngestOption("A", true), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("type");
    }

    @Test
    void ingestRejectsFewerThanTwoOptions() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = singleChoice(List.of(new QuestionIngestOption("A", true)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("two options");
    }

    @Test
    void ingestSingleChoiceRejectsZeroCorrectOptions() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = singleChoice(List.of(
                new QuestionIngestOption("A", false), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("exactly one correct option");
    }

    @Test
    void ingestSingleChoiceRejectsMultipleCorrectOptions() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = singleChoice(List.of(
                new QuestionIngestOption("A", true), new QuestionIngestOption("B", true)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("exactly one correct option");
    }

    @Test
    void ingestMultipleChoiceAcceptsTwoOrMoreCorrectOptions() {
        stubSave();
        QuestionIngestRequest request = multipleChoice(List.of(
                new QuestionIngestOption("A", true),
                new QuestionIngestOption("B", true),
                new QuestionIngestOption("C", false)));

        // Bu, V293'ün eski "en fazla bir doğru" DB kısıtını kaldırdığını VE
        // ingestion doğrulamasının MULTIPLE_CHOICE için birden fazla doğru şıkkı
        // kabul ettiğini birlikte kanıtlıyor (bkz. plan bölüm 5.1).
        QuestionIngestResponse response = newService().ingest(request);
        assertThat(response.status()).isEqualTo(QuestionStatus.PENDING_REVIEW.name());

        ArgumentCaptor<List<QuestionOption>> captor = ArgumentCaptor.forClass(List.class);
        verify(questionOptionRepository).saveAll(captor.capture());
        long correctCount = captor.getValue().stream().filter(QuestionOption::isCorrect).count();
        assertThat(correctCount).isEqualTo(2);
    }

    @Test
    void ingestMultipleChoiceRejectsZeroCorrectOptions() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = multipleChoice(List.of(
                new QuestionIngestOption("A", false), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("MULTIPLE_CHOICE requires at least one correct option");
    }

    @Test
    void ingestCodeOutputRequiresCodeSnippet() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = codeOutput(null, List.of(
                new QuestionIngestOption("1", true), new QuestionIngestOption("2", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("codeSnippet is required");
    }

    @Test
    void ingestRejectsCodeSnippetForNonCodeOutputType() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = new QuestionIngestRequest("enum", "en", "SINGLE_CHOICE", "INTERMEDIATE",
                "Q?", "System.out.println(1);", "java", "Because.",
                List.of(new QuestionIngestOption("A", true), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("only allowed for CODE_OUTPUT");
    }

    @Test
    void ingestCodeOutputWithExactlyOneCorrectOptionSucceeds() {
        stubSave();
        QuestionIngestRequest request = codeOutput("System.out.println(1 + 1);", List.of(
                new QuestionIngestOption("2", true), new QuestionIngestOption("11", false)));

        QuestionIngestResponse response = newService().ingest(request);

        assertThat(response.status()).isEqualTo(QuestionStatus.PENDING_REVIEW.name());
        ArgumentCaptor<Question> captor = ArgumentCaptor.forClass(Question.class);
        verify(questionRepository).save(captor.capture());
        assertThat(captor.getValue().getCodeSnippet()).isEqualTo("System.out.println(1 + 1);");
        assertThat(captor.getValue().getCodeLanguage()).isEqualTo("java");
    }

    @Test
    void ingestSavesOptionsWithSortOrderMatchingRequestOrder() {
        stubSave();
        QuestionIngestRequest request = singleChoice(List.of(
                new QuestionIngestOption("First", false),
                new QuestionIngestOption("Second", true),
                new QuestionIngestOption("Third", false)));

        newService().ingest(request);

        ArgumentCaptor<List<QuestionOption>> captor = ArgumentCaptor.forClass(List.class);
        verify(questionOptionRepository).saveAll(captor.capture());
        assertThat(captor.getValue()).extracting(QuestionOption::getOptionText, QuestionOption::getSortOrder)
                .containsExactly(
                        org.assertj.core.groups.Tuple.tuple("First", 0),
                        org.assertj.core.groups.Tuple.tuple("Second", 1),
                        org.assertj.core.groups.Tuple.tuple("Third", 2));
    }

    @Test
    void ingestRejectsBlankQuestionText() {
        when(topicRepository.findBySlug("enum")).thenReturn(Optional.of(enumTopic()));
        QuestionIngestRequest request = new QuestionIngestRequest("enum", "en", "SINGLE_CHOICE", "INTERMEDIATE",
                "   ", null, null, "Because.",
                List.of(new QuestionIngestOption("A", true), new QuestionIngestOption("B", false)));

        assertThatThrownBy(() -> newService().ingest(request))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("question is required");
    }
}

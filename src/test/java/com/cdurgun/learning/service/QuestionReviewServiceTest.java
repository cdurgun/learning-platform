package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.PublishLogStatus;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionPublishLog;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.publish.QuestionAutoPublishRequest;
import com.cdurgun.learning.web.publish.QuestionAutoPublishResponse;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * n8n'in AI Judge aşamasının çağırdığı {@link QuestionReviewService#autoPublish}
 * -- var olan insan Publish/Reject akışı (409/PENDING_REVIEW-only geçiş kuralı) burada
 * DEĞİŞTİRİLMEDEN yeniden kullanılıyor, testler de bu yüzden {@code
 * QuestionReviewControllerTest}'in zaten kapsadığı publish/reject senaryolarını
 * TEKRARLAMIYOR -- yalnızca auto-publish'e ÖZGÜ davranışı (kill switch, denetim
 * kaydı, {@code QuestionPublishAuditService}'in {@code REQUIRES_NEW} sınırının
 * autoPublish()'in asıl sonucunu HİÇ etkilememesi, duplicate-publish koruması)
 * doğruluyor. {@link QuestionPublishAuditService} burada mock'lanıyor -- gerçek
 * {@code Propagation.REQUIRES_NEW} davranışı (bağımsız commit) bu sınıfın kendi
 * sorumluluğu değil, bir sonraki DB-destekli testte (ör. bir {@code @SpringBootTest})
 * doğrulanabilir; burada test edilen, {@code QuestionReviewService}'in o servisin
 * BAŞARI/HATA sonucuna nasıl tepki verdiği.
 */
@ExtendWith(MockitoExtension.class)
class QuestionReviewServiceTest {

    @Mock
    private QuestionRepository questionRepository;
    @Mock
    private QuestionOptionRepository questionOptionRepository;
    @Mock
    private TopicTranslationRepository topicTranslationRepository;
    @Mock
    private QuestionPublishAuditService questionPublishAuditService;

    private QuestionReviewService newService(boolean autoPublishEnabled) {
        return new QuestionReviewService(questionRepository, questionOptionRepository,
                topicTranslationRepository, questionPublishAuditService, autoPublishEnabled);
    }

    private static Question pendingQuestion() {
        return Question.builder().id(200L).status(QuestionStatus.PENDING_REVIEW).build();
    }

    @Test
    void autoPublishRejectsWhenDisabled() {
        QuestionReviewService service = newService(false);

        assertThatThrownBy(() -> service.autoPublish(200L, null))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(e -> assertThat(((ResponseStatusException) e).getStatusCode())
                        .isEqualTo(HttpStatus.SERVICE_UNAVAILABLE));

        verify(questionRepository, never()).findById(any());
        verify(questionPublishAuditService, never()).record(any());
    }

    @Test
    void autoPublishTransitionsPendingReviewQuestionToPublishedAndLogsSuccess() {
        Question question = pendingQuestion();
        when(questionRepository.findById(200L)).thenReturn(Optional.of(question));
        when(questionRepository.save(any(Question.class))).thenAnswer(inv -> inv.getArgument(0));

        QuestionReviewService service = newService(true);
        QuestionAutoPublishResponse response = service.autoPublish(200L,
                new QuestionAutoPublishRequest("run-1", "gpt-4o-mini", "Factually correct and unambiguous."));

        assertThat(response.status()).isEqualTo("PUBLISHED");
        assertThat(question.getStatus()).isEqualTo(QuestionStatus.PUBLISHED);
        assertThat(question.getReviewedBy()).isEqualTo("n8n-ai-judge");
        assertThat(question.getReviewedAt()).isNotNull();

        ArgumentCaptor<QuestionPublishLog> captor = ArgumentCaptor.forClass(QuestionPublishLog.class);
        verify(questionPublishAuditService).record(captor.capture());
        QuestionPublishLog auditLog = captor.getValue();
        assertThat(auditLog.getQuestionId()).isEqualTo(200L);
        assertThat(auditLog.getStatus()).isEqualTo(PublishLogStatus.SUCCESS);
        assertThat(auditLog.getRunId()).isEqualTo("run-1");
        assertThat(auditLog.getModelName()).isEqualTo("gpt-4o-mini");
        assertThat(auditLog.getPublishedAt()).isNotNull();
    }

    @Test
    void autoPublishOnAlreadyPublishedQuestionFailsAndLogsFailureWithoutChangingState() {
        Question question = Question.builder().id(201L).status(QuestionStatus.PUBLISHED).build();
        when(questionRepository.findById(201L)).thenReturn(Optional.of(question));

        QuestionReviewService service = newService(true);

        assertThatThrownBy(() -> service.autoPublish(201L, null))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(e -> assertThat(((ResponseStatusException) e).getStatusCode())
                        .isEqualTo(HttpStatus.CONFLICT));

        // No second state transition -- the question was already PUBLISHED and stays so.
        assertThat(question.getStatus()).isEqualTo(QuestionStatus.PUBLISHED);
        verify(questionRepository, never()).save(any());

        ArgumentCaptor<QuestionPublishLog> captor = ArgumentCaptor.forClass(QuestionPublishLog.class);
        verify(questionPublishAuditService).record(captor.capture());
        assertThat(captor.getValue().getStatus()).isEqualTo(PublishLogStatus.FAILED);
        assertThat(captor.getValue().getQuestionId()).isEqualTo(201L);
        assertThat(captor.getValue().getErrorMessage()).isNotBlank();
    }

    @Test
    void autoPublishOnUnknownQuestionDoesNotWriteAnAuditRow() {
        when(questionRepository.findById(999L)).thenReturn(Optional.empty());

        QuestionReviewService service = newService(true);

        assertThatThrownBy(() -> service.autoPublish(999L, null))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(e -> assertThat(((ResponseStatusException) e).getStatusCode())
                        .isEqualTo(HttpStatus.NOT_FOUND));

        // question_id has a NOT NULL FK to question(id) -- a log row referencing a
        // non-existent question would violate that constraint, so none is written.
        verify(questionPublishAuditService, never()).record(any());
    }

    @Test
    void successfulAuditWriteFailureDoesNotTurnASuccessfulPublishIntoAnError() {
        Question question = pendingQuestion();
        when(questionRepository.findById(200L)).thenReturn(Optional.of(question));
        when(questionRepository.save(any(Question.class))).thenAnswer(inv -> inv.getArgument(0));
        // Simulates QuestionPublishAuditService.record()'s own REQUIRES_NEW transaction
        // failing (e.g. a transient DB issue, or the concurrent-duplicate-SUCCESS-row
        // race hitting uq_question_publish_log_success_question).
        doThrow(new DataIntegrityViolationException("simulated audit insert failure"))
                .when(questionPublishAuditService).record(any());

        QuestionReviewService service = newService(true);

        QuestionAutoPublishResponse response = service.autoPublish(200L, null);

        // The publish itself is the ground truth and must be reported as successful
        // regardless of the audit write's own failure.
        assertThat(response.status()).isEqualTo("PUBLISHED");
        assertThat(question.getStatus()).isEqualTo(QuestionStatus.PUBLISHED);
        verify(questionPublishAuditService).record(any());
    }

    @Test
    void failedAuditWriteFailureDoesNotReplaceTheOriginalConflictResponse() {
        Question question = Question.builder().id(201L).status(QuestionStatus.PUBLISHED).build();
        when(questionRepository.findById(201L)).thenReturn(Optional.of(question));
        doThrow(new DataIntegrityViolationException("simulated audit insert failure"))
                .when(questionPublishAuditService).record(any());

        QuestionReviewService service = newService(true);

        // The original 409 (not a 500 from the audit-write failure) must still be what
        // the caller sees.
        assertThatThrownBy(() -> service.autoPublish(201L, null))
                .isInstanceOf(ResponseStatusException.class)
                .satisfies(e -> assertThat(((ResponseStatusException) e).getStatusCode())
                        .isEqualTo(HttpStatus.CONFLICT));
        verify(questionPublishAuditService).record(any());
    }
}

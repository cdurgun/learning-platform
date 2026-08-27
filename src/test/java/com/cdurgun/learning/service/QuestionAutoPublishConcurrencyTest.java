package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.PublishLogStatus;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.repository.QuestionPublishLogRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.web.publish.QuestionAutoPublishResponse;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@code QuestionReviewServiceTest} (Mockito) yalnızca {@code
 * OptimisticLockingFailureException}'ın 409'a nasıl çevrildiğini DETERMİNİSTİK olarak
 * test ediyor -- bir mock, gerçek bir veritabanı seviyesi yarışı GÖSTEREMEZ. Bu sınıf
 * gerçek Postgres'e karşı, gerçek iki thread'le {@link QuestionReviewService#autoPublish}
 * çağırıp {@code Question.version} ({@code @Version}) sayesinde yalnızca birinin
 * gerçekten PENDING_REVIEW->PUBLISHED geçişini kazandığını doğruluyor.
 *
 * <p>BİLİNÇLİ OLARAK sınıf seviyesinde {@code @Transactional} YOK -- iki worker
 * thread'i ayrı bağlantılarda çalışıyor, ana thread'in fixture satırı gerçekten COMMIT
 * olmadan onu göremezler; bu yüzden fixture elle eklenip test sonunda elle
 * temizleniyor (rollback-on-exit'e güvenilmiyor).</p>
 */
@SpringBootTest
@ActiveProfiles("test")
@TestPropertySource(properties = "quiz.auto-publish.enabled=true")
class QuestionAutoPublishConcurrencyTest {

    @Autowired
    private QuestionReviewService questionReviewService;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private QuestionPublishLogRepository questionPublishLogRepository;
    @Autowired
    private TopicRepository topicRepository;

    private Long fixtureQuestionId;

    @AfterEach
    void cleanUp() {
        if (fixtureQuestionId != null) {
            questionPublishLogRepository.findByQuestionIdOrderByCreatedAtAsc(fixtureQuestionId)
                    .forEach(questionPublishLogRepository::delete);
            questionRepository.deleteById(fixtureQuestionId);
            fixtureQuestionId = null;
        }
    }

    @Test
    void concurrentAutoPublishAttemptsOnTheSameQuestionYieldExactlyOneWinner() throws Exception {
        Topic enumTopic = topicRepository.findBySlug("enum").orElseThrow();
        Question question = Question.builder()
                .topic(enumTopic)
                .language(Language.EN)
                .type(QuestionType.SINGLE_CHOICE)
                .difficulty(Difficulty.BEGINNER)
                .status(QuestionStatus.PENDING_REVIEW)
                .source(QuestionSource.MANUAL)
                .question("QuestionAutoPublishConcurrencyTest fixture question?")
                .explanation("QuestionAutoPublishConcurrencyTest fixture explanation.")
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        question = questionRepository.saveAndFlush(question);
        fixtureQuestionId = question.getId();

        int threadCount = 2;
        CyclicBarrier barrier = new CyclicBarrier(threadCount);
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        Long questionId = fixtureQuestionId;

        Callable<Object> attempt = () -> {
            barrier.await();
            try {
                return questionReviewService.autoPublish(questionId, null);
            } catch (ResponseStatusException e) {
                return e;
            }
        };

        try {
            List<Future<Object>> futures = executor.invokeAll(List.of(attempt, attempt));
            int successCount = 0;
            int conflictCount = 0;
            for (Future<Object> future : futures) {
                Object result = future.get(10, TimeUnit.SECONDS);
                if (result instanceof QuestionAutoPublishResponse response) {
                    successCount++;
                    assertThat(response.status()).isEqualTo("PUBLISHED");
                } else if (result instanceof ResponseStatusException e) {
                    conflictCount++;
                    assertThat(e.getStatusCode().value()).isEqualTo(409);
                } else {
                    throw new AssertionError("Unexpected result: " + result);
                }
            }

            assertThat(successCount).isEqualTo(1);
            assertThat(conflictCount).isEqualTo(1);
        } finally {
            executor.shutdownNow();
        }

        Question reloaded = questionRepository.findById(questionId).orElseThrow();
        assertThat(reloaded.getStatus()).isEqualTo(QuestionStatus.PUBLISHED);

        long successRows = questionPublishLogRepository.findByQuestionIdOrderByCreatedAtAsc(questionId).stream()
                .filter(log -> log.getStatus() == PublishLogStatus.SUCCESS)
                .count();
        long failedRows = questionPublishLogRepository.findByQuestionIdOrderByCreatedAtAsc(questionId).stream()
                .filter(log -> log.getStatus() == PublishLogStatus.FAILED)
                .count();
        assertThat(successRows).isEqualTo(1);
        assertThat(failedRows).isEqualTo(1);
    }
}

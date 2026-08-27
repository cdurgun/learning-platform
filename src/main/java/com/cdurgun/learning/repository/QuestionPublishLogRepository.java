package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.PublishLogStatus;
import com.cdurgun.learning.domain.QuestionPublishLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface QuestionPublishLogRepository extends JpaRepository<QuestionPublishLog, Long> {

    List<QuestionPublishLog> findByQuestionIdOrderByCreatedAtAsc(Long questionId);

    /**
     * Duplicate-publish korumasının ikinci (fiziksel) katmanı için -- bkz. migration
     * V465'teki {@code uq_question_publish_log_success_question} kısmi unique index'i.
     * Servis katmanı, {@code QuestionReviewService.publish()}'in (PENDING_REVIEW-only,
     * 409) zaten reddettiği bir durumu buraya ulaşmadan önce elediği için bu metot
     * normalde hiç {@code true} dönmez -- yalnızca test/doğrulama amaçlı.
     */
    boolean existsByQuestionIdAndStatus(Long questionId, PublishLogStatus status);
}

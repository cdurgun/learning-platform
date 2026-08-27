package com.cdurgun.learning.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * {@code /api/internal/questions/{id}/auto-publish}'e yapılan HER çağrının denetim
 * kaydı -- başarılı da olsa başarısız da olsa (bkz. {@link
 * com.cdurgun.learning.service.QuestionReviewService#autoPublish}).
 * {@code questionId} BİLİNÇLİ OLARAK bir {@code @ManyToOne} DEĞİL, düz bir
 * {@code Long} -- bu bir denetim/log satırı, Question'ın entity graph'ını hiç
 * yüklemesine gerek yok, DB seviyesinde FK zaten yeterli bütünlük garantisi verir
 * (bkz. migration V465).
 */
@Entity
@Table(name = "question_publish_log")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuestionPublishLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "question_id", nullable = false)
    private Long questionId;

    /**
     * n8n çalıştırma/execution korelasyon id'si -- opsiyonel, yalnızca denetim amaçlı.
     */
    @Column(name = "run_id")
    private String runId;

    @Column(name = "model_name")
    private String modelName;

    /**
     * AI Judge'ın APPROVE gerekçesi -- opsiyonel, yalnızca denetim amaçlı.
     */
    @Column(columnDefinition = "TEXT")
    private String reason;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PublishLogStatus status;

    @Column(name = "error_message", columnDefinition = "TEXT")
    private String errorMessage;

    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}

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

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * AI Tutor'un sağlayıcıya yaptığı bir çağrının kullanım ve tahmini maliyet kaydı (bkz. migration
 * V1150). Soru, cevap, ders içeriği ve API anahtarı BİLİNÇLİ OLARAK burada yok -- yalnızca
 * boyutlar, token sayıları ve maliyet. Satırları yalnızca
 * {@link com.cdurgun.learning.service.ai.AiUsageRecorder} yazar.
 *
 * <p>{@code userId} bir {@code @ManyToOne} DEĞİL, düz bir {@code Long} ({@link QuestionPublishLog}
 * ile aynı gerekçe: bir log satırı User'ın entity graph'ına ihtiyaç duymaz). {@code createdAt}
 * UTC'dir. {@code errorCategory} ve {@code pricingPeriod}, servis katmanındaki enum'ların adları
 * olarak düz metin tutulur -- domain servis katmanına bağımlı olmasın; geçerli değerleri
 * migration'daki CHECK kısıtları ve kaydedici korur.</p>
 */
@Entity
@Table(name = "ai_usage_log")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AiUsageLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Hesap silinirse NULL olur (ON DELETE SET NULL); harcama kaydı yine kalır. */
    @Column(name = "user_id")
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AiFeature feature;

    @Column(nullable = false)
    private String model;

    @Column(name = "topic_slug")
    private String topicSlug;

    private Language language;

    /** UTC. */
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "duration_ms", nullable = false)
    private Integer durationMs;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AiUsageOutcome outcome;

    @Column(name = "error_category")
    private String errorCategory;

    @Column(nullable = false)
    private boolean truncated;

    @Column(name = "input_chars", nullable = false)
    private Integer inputChars;

    @Column(name = "context_chars")
    private Integer contextChars;

    /** {@code false}: token sayıları bilinmiyordu, {@link #estimatedCostUsd} en kötü durumdur. */
    @Column(name = "usage_reported", nullable = false)
    private boolean usageReported;

    @Column(name = "prompt_cache_hit_tokens")
    private Integer promptCacheHitTokens;

    @Column(name = "prompt_cache_miss_tokens")
    private Integer promptCacheMissTokens;

    @Column(name = "completion_tokens")
    private Integer completionTokens;

    @Column(name = "reasoning_tokens")
    private Integer reasoningTokens;

    /** USD, 6 ondalık; DB {@code NUMERIC(12,6)} -- bu yüzden {@code BigDecimal} (bkz. CLAUDE.md). */
    @Column(name = "estimated_cost_usd", nullable = false, precision = 12, scale = 6)
    private BigDecimal estimatedCostUsd;

    @Column(name = "pricing_period", nullable = false)
    private String pricingPeriod;

    @Column(name = "pricing_version", nullable = false)
    private String pricingVersion;
}

package com.cdurgun.learning.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Bir konunun dil-bağımsız metadata'sı. Not: {@code published} durumu kasıtlı olarak
 * burada değil, {@link TopicTranslation} üzerinde tutulur — çünkü bir dilin yayında,
 * diğerinin taslak olması gayet normal bir senaryodur.
 *
 * <p>İçeriğin kendisi burada yok: gövde metni {@code content/{lang}/{slug}.md} dosyasında,
 * kod örnekleri {@code examples/{slug}/*.java} altında — bağlantı {@link #slug} üzerinden
 * convention ile kurulur, hiçbir dosya yolu DB'de saklanmaz.</p>
 */
@Entity
@Table(name = "topic")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Topic {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(nullable = false, unique = true)
    private String slug;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Difficulty difficulty;

    @Column(name = "estimated_minutes")
    private Integer estimatedMinutes;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;
}

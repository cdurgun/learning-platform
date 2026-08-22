package com.cdurgun.learning.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
 * Bir konunun tek bir dildeki quiz sorusu. DİKKAT: {@code language} alanına
 * {@code @Enumerated} EKLENMEZ — {@code LanguageAttributeConverter} zaten
 * {@code @Converter(autoApply = true)} ile bu alanı otomatik dönüştürüyor
 * (bkz. {@link TopicTranslation#getLanguage()}).
 */
@Entity
@Table(name = "quiz_question")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuizQuestion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private Language language;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String explanation;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;
}

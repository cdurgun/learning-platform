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
import jakarta.persistence.Version;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * Bir konunun soru havuzundaki tek bir sorusu -- herhangi bir {@link Quiz}'e bağlı
 * olmak ZORUNDA değil. Sabit bir quiz'in parçası olmak isteyen sorular
 * {@link QuizQuestion} (Quiz ile Question arasında bir ilişki/join entity'si)
 * üzerinden bağlanır; Practice modu ise bu tabloyu doğrudan, hiçbir {@code Quiz}
 * satırına ihtiyaç duymadan filtreler (bkz. soru havuzu yeniden tasarımı planı).
 * DİKKAT: {@code language} alanına {@code @Enumerated} EKLENMEZ --
 * {@code LanguageAttributeConverter} zaten {@code @Converter(autoApply = true)} ile
 * bu alanı otomatik dönüştürüyor (bkz. {@link TopicTranslation#getLanguage()}).
 */
@Entity
@Table(name = "question")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Question {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private Language language;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QuestionType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Difficulty difficulty;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QuestionStatus status;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QuestionSource source;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String question;

    /**
     * Yalnızca {@link QuestionType#CODE_OUTPUT} için doldurulur -- diğer tiplerde null.
     */
    @Column(name = "code_snippet", columnDefinition = "TEXT")
    private String codeSnippet;

    /**
     * highlight.js dil sınıfı (ör. "java") -- yalnızca {@code codeSnippet} doluyken anlamlı.
     */
    @Column(name = "code_language")
    private String codeLanguage;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String explanation;

    @Column(name = "reviewed_by")
    private String reviewedBy;

    @Column(name = "reviewed_at")
    private LocalDateTime reviewedAt;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    /**
     * Optimistic lock -- {@link QuestionReviewService#transition}'ın eşzamanlı iki
     * PENDING_REVIEW->PUBLISHED/REJECTED geçişinden yalnızca birinin gerçekten
     * başarılı olmasını, Hibernate'in {@code UPDATE ... WHERE id=? AND version=?}
     * karşılaştır-ve-değiştir'iyle veritabanı seviyesinde garanti eder.
     */
    @Version
    @Column(nullable = false)
    private Long version;
}

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
 * FAZ B'DEN İTİBAREN YENİ ANLAM: bu artık bir soru DEĞİL, {@link Quiz} ile
 * {@link Question} arasında bir İLİŞKİ (join) entity'si -- hangi sorunun hangi
 * quiz'de, hangi sırada ({@link #position}) yer aldığını tutar. Eski anlamıyla
 * ("bir konunun tek bir dildeki quiz sorusu") artık {@link Question}'a taşındı.
 * Tablo adı çakışmayı önlemek için {@code quiz_question_link} (eski
 * {@code quiz_question} tablosu Faz A'da {@code question}'a yeniden adlandırıldı).
 */
@Entity
@Table(name = "quiz_question_link")
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
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Column(nullable = false)
    private Integer position;
}

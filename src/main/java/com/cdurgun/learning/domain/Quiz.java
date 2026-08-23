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

import java.math.BigDecimal;

/**
 * Bir topic+language'e bağlı, editoryal olarak KÜRE edilmiş (curated), sıralı bir
 * soru kümesi -- "sabit quiz". Hangi {@link Question}'ların bu quiz'in parçası
 * olduğu ve hangi sırada göründüğü {@link QuizQuestion} (join entity) üzerinden
 * belirlenir; bu entity'nin kendisi soru içeriği taşımaz.
 */
@Entity
@Table(name = "quiz")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private Language language;

    @Column(nullable = false)
    private String slug;

    @Column(nullable = false)
    private String title;

    /**
     * {@code NUMERIC(3,2)} kolonuna karşılık BİLİNÇLİ OLARAK {@code BigDecimal} --
     * {@code Double} kullanılırsa Hibernate'in varsayılan SQL tip beklentisi
     * {@code float(53)}/{@code double precision} olur ve DB'deki gerçek {@code
     * NUMERIC} tipiyle şema doğrulaması ({@code ddl-auto: validate}) çakışır.
     * Kolon tipi bilinçli olarak NUMERIC seçildi (kesin ondalık temsil, floating-point
     * yuvarlama riski yok) -- DB DEĞİL, Java tarafı buna uymalı.
     */
    @Column(name = "pass_threshold", nullable = false)
    private BigDecimal passThreshold;

    @Column(nullable = false)
    private boolean active;
}

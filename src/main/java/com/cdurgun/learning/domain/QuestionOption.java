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
 * Bir {@link Question}'a ait çoktan seçmeli şık. {@code SINGLE_CHOICE}/{@code CODE_OUTPUT}
 * tipi sorularda tam olarak bir {@code correct = true} satır olması gerekir,
 * {@code MULTIPLE_CHOICE}'ta bir veya daha fazla olabilir. FAZ A/B/C İTİBARIYLA DB hâlâ
 * "en fazla bir doğru" kısıtını (bkz. {@code core/V259__quiz_schema.sql}, Faz B'de
 * {@code core/V288}'de yeniden adlandırıldı) global olarak zorluyor -- bu, Faz D'nin
 * {@code core/V294__...} migration'ıyla kaldırılıp servis/ingestion katmanına taşınacak
 * (bkz. plan bölüm 5.1). O migration çalışana kadar MULTIPLE_CHOICE fiilen desteklenmez.
 */
@Entity
@Table(name = "question_option")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuestionOption {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Column(name = "option_text", nullable = false, columnDefinition = "TEXT")
    private String optionText;

    @Column(name = "is_correct", nullable = false)
    private boolean correct;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;
}

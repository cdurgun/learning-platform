package com.cdurgun.learning.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

/**
 * Quiz Area: bir kursa bağlı, isteğe bağlı olarak bir veya daha fazla {@link Category}
 * ile kapsamı daraltılmış, YENİDEN KULLANILABİLİR bir rastgele-soru-çekme tanımı
 * (örn. "Basic Java", "All Spring"). Var olan {@link Quiz}/{@link QuizQuestion} çiftinin
 * (bir topic'e gömülü, sabit/küre edilmiş sıralı soru kümesi) BİLİNÇLİ OLARAK ayrı,
 * ek bir kavram -- bu ikisi asla birleştirilmedi/taşınmadı, mekanikleri temelden
 * farklı (burada soru kümesi her çekilişte havuzdan RASTGELE seçilir, sabit bir
 * sıra/eşik yok).
 *
 * <p>{@code categories} boşsa kapsam TÜM kursu kapsar (örn. "All Java") -- bu sayede
 * kursa yeni bir kategori eklendiğinde "All X" tanımı hiçbir migration'a gerek
 * kalmadan otomatik olarak onu da kapsar. Boş olmayan bir küme yalnızca o
 * kategorilerle sınırlar (örn. "Basic Java" = yalnızca java-basics).</p>
 *
 * <p>{@code slug} KASITLI OLARAK global olarak unique (course_id+slug DEĞİL) --
 * play/submit URL'leri ({@code /{lang}/quiz/{definitionSlug}}) yalnızca bu slug'ı
 * taşır, kursu değil, bu yüzden slug tek başına belirsizliksiz çözülebilmeli.</p>
 *
 * <p>Bu entity'de başlık/isim kolonu YOK -- ekranda gösterilen başlıklar
 * ({@code quiz.def.{slug}.title}) {@code messages_{lang}.properties}'ten slug
 * konvansiyonuyla okunur, ayrı bir çeviri tablosu eklenmedi (bkz. proje genelindeki
 * "DB↔dosya bağlantısı yalnızca slug convention" ilkesi).</p>
 */
@Entity
@Table(name = "quiz_definition")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuizDefinition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @Column(nullable = false, unique = true)
    private String slug;

    @Column(name = "question_count", nullable = false)
    private Integer questionCount;

    @Column(nullable = false)
    private boolean active;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "quiz_definition_category",
            joinColumns = @JoinColumn(name = "quiz_definition_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id"))
    @Builder.Default
    private Set<Category> categories = new HashSet<>();
}

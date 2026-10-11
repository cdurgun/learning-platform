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
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

/**
 * Bir konunun tek bir dildeki başlık/özet/SEO metadata'sı ve yayın durumu.
 * {@code published} kasıtlı olarak burada — bir dil yayında iken diğeri taslak olabilir.
 * Gövde içeriği burada YOK, bkz. {@code content/{language}/{topic.slug}.md}.
 */
@Entity
@Table(name = "topic_translation", uniqueConstraints = @UniqueConstraint(columnNames = {"topic_id", "language"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TopicTranslation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "topic_id", nullable = false)
    private Topic topic;

    @Column(nullable = false)
    private Language language;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String summary;

    @Column(name = "seo_title")
    private String seoTitle;

    @Column(name = "seo_description")
    private String seoDescription;

    @Column(nullable = false)
    private boolean published;

    /**
     * {@code content/{language}/{slug}.md} dosyasının ilk git commit tarihi (bkz. {@code V1137}).
     * Sitenin gerçek yayın tarihi DEĞİL; bu yüzden hiçbir sayfada, JSON-LD'de ya da sitemap'te
     * YAYINLANMAZ. Yalnızca iç kayıttır ({@code updated_at >= published_at} kısıtının alt sınırı).
     */
    @Column(name = "published_at", nullable = false)
    private LocalDate publishedAt;

    /**
     * Ders metninin ya da sayfada görünen örnek kodun son anlamlı değişikliği. Otomatik
     * GÜNCELLENMEZ: içerik dosyada yaşadığı için bu satır değişmez, tarih bir migration'la elle
     * ilerletilir.
     */
    @Column(name = "updated_at", nullable = false)
    private LocalDate updatedAt;
}

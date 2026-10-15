package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface TopicTranslationRepository extends JpaRepository<TopicTranslation, Long> {

    Optional<TopicTranslation> findByTopicIdAndLanguage(Long topicId, Language language);

    /**
     * sitemap.xml için: yayında olan HER çeviriyi, ilişkili {@code Topic}'iyle birlikte,
     * join fetch ile tek sorguda getirir — N+1'e düşmeden. Sıra önemli değil; controller
     * kendi içinde slug'a göre gruplayıp dil kümelerini (hreflang cross-reference için)
     * çıkarıyor.
     */
    /** Kurs açılış sayfası için: bu kursun verilen dilde yayında en az bir konusu var mı (hreflang kararı). */
    @Query("select count(tt) > 0 from TopicTranslation tt " +
            "where tt.published = true and tt.language = :language and tt.topic.category.course.slug = :courseSlug")
    boolean existsPublishedInCourse(@Param("courseSlug") String courseSlug, @Param("language") Language language);

    @Query("select tt from TopicTranslation tt join fetch tt.topic t join fetch t.category c join fetch c.course " +
            "where tt.published = true")
    List<TopicTranslation> findAllPublishedWithTopic();

    /**
     * Menü için: verilen dilde yayında olan tüm ders çevirileri, kurs/kategori bilgisiyle,
     * kurs + kategori + konu sort_order sırasında, tek sorguda. Sıra eşitliğinde id'ler
     * sırayı belirler, böylece aynı kursun/kategorinin satırları her zaman bitişik gelir.
     */
    @Query("select new com.cdurgun.learning.repository.NavigationRow(" +
            "co.slug, co.name, c.slug, c.name, t.slug, tt.title, tt.summary, t.difficulty, t.estimatedMinutes) " +
            "from TopicTranslation tt join tt.topic t join t.category c join c.course co " +
            "where tt.language = :language and tt.published = true " +
            "order by co.sortOrder, co.id, c.sortOrder, c.id, t.sortOrder, t.id")
    List<NavigationRow> findPublishedNavigationRows(@Param("language") Language language);

    /** Önceki/sonraki navigasyonu için: yukarıdakinin tek bir kursla sınırlı hâli. */
    @Query("select new com.cdurgun.learning.repository.NavigationRow(" +
            "co.slug, co.name, c.slug, c.name, t.slug, tt.title, tt.summary, t.difficulty, t.estimatedMinutes) " +
            "from TopicTranslation tt join tt.topic t join t.category c join c.course co " +
            "where co.id = :courseId and tt.language = :language and tt.published = true " +
            "order by c.sortOrder, c.id, t.sortOrder, t.id")
    List<NavigationRow> findPublishedNavigationRowsByCourse(@Param("courseId") Long courseId,
                                                            @Param("language") Language language);
}

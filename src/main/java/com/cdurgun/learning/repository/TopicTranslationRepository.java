package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface TopicTranslationRepository extends JpaRepository<TopicTranslation, Long> {

    Optional<TopicTranslation> findByTopicIdAndLanguage(Long topicId, Language language);

    /**
     * sitemap.xml için: yayında olan HER çeviriyi, ilişkili {@code Topic}'iyle birlikte,
     * join fetch ile tek sorguda getirir — N+1'e düşmeden. {@code Topic.category.course}
     * de fetch ediliyor: sitemap yalnızca anonim erişime açık kursların konularını
     * listeliyor (bkz. {@code CourseAccessPolicy#isPublicCourse}, {@code SitemapController}). Sıra önemli değil; controller
     * kendi içinde slug'a göre gruplayıp dil kümelerini (hreflang cross-reference için)
     * çıkarıyor.
     */
    @Query("select tt from TopicTranslation tt join fetch tt.topic t join fetch t.category c join fetch c.course " +
            "where tt.published = true")
    List<TopicTranslation> findAllPublishedWithTopic();
}

package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Topic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface TopicRepository extends JpaRepository<Topic, Long> {

    Optional<Topic> findBySlug(String slug);

    List<Topic> findByCategoryIdOrderBySortOrderAsc(Long categoryId);

    /**
     * Konu sayfası için: Category ve Course'u join fetch ile birlikte getirir.
     * Breadcrumb ve önceki/sonraki konu navigasyonu bu ilişkilere ihtiyaç duyuyor;
     * bunu lazy-loading'e (open-in-view'a) bırakmak yerine tek sorguda açıkça çözüyoruz.
     */
    @Query("select t from Topic t join fetch t.category c join fetch c.course where t.slug = :slug")
    Optional<Topic> findBySlugWithCategoryAndCourse(String slug);
}

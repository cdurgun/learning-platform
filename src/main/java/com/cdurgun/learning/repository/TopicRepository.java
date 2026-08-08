package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Topic;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface TopicRepository extends JpaRepository<Topic, Long> {

    Optional<Topic> findBySlug(String slug);

    List<Topic> findByCategoryIdOrderBySortOrderAsc(Long categoryId);
}

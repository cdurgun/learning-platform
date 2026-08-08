package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.CodeExample;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CodeExampleRepository extends JpaRepository<CodeExample, Long> {

    List<CodeExample> findByTopicIdOrderBySortOrderAsc(Long topicId);

    Optional<CodeExample> findByTopicIdAndExampleName(Long topicId, String exampleName);
}

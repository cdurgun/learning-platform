package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface TopicTranslationRepository extends JpaRepository<TopicTranslation, Long> {

    Optional<TopicTranslation> findByTopicIdAndLanguage(Long topicId, Language language);
}

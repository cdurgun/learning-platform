package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {

    @Query("select q from QuizQuestion q join fetch q.topic where q.topic.id = :topicId " +
            "and q.language = :language order by q.sortOrder asc")
    List<QuizQuestion> findByTopicIdAndLanguageOrderBySortOrderAsc(Long topicId, Language language);
}

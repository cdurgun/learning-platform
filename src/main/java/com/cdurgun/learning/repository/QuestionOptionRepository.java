package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.QuestionOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuestionOptionRepository extends JpaRepository<QuestionOption, Long> {

    @Query("select o from QuestionOption o join fetch o.question q join fetch q.topic " +
            "where q.id in :questionIds order by o.sortOrder asc")
    List<QuestionOption> findByQuestionIdInOrderBySortOrderAsc(List<Long> questionIds);

    /**
     * Submit sırasında gönderilen option id'lerini question + topic'e join ederek
     * getirir — QuizService.submit()'teki ownership (topic/language) doğrulaması
     * için tek sorguda ihtiyaç duyulan her şeyi sağlar.
     */
    @Query("select o from QuestionOption o join fetch o.question q join fetch q.topic " +
            "where o.id in :optionIds")
    List<QuestionOption> findByIdInWithQuestionAndTopic(List<Long> optionIds);
}

package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.QuizOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuizOptionRepository extends JpaRepository<QuizOption, Long> {

    @Query("select o from QuizOption o join fetch o.question q join fetch q.topic " +
            "where q.id in :questionIds order by o.sortOrder asc")
    List<QuizOption> findByQuestionIdInOrderBySortOrderAsc(List<Long> questionIds);

    /**
     * Submit sırasında gönderilen option id'lerini question + topic'e join ederek
     * getirir — QuizService.submit()'teki ownership (topic/language) doğrulaması
     * için tek sorguda ihtiyaç duyulan her şeyi sağlar.
     */
    @Query("select o from QuizOption o join fetch o.question q join fetch q.topic " +
            "where o.id in :optionIds")
    List<QuizOption> findByIdInWithQuestionAndTopic(List<Long> optionIds);
}

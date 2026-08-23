package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {

    @Query("select qq from QuizQuestion qq join fetch qq.question q join fetch q.topic " +
            "where qq.quiz.id = :quizId order by qq.position asc")
    List<QuizQuestion> findByQuizIdOrderByPositionAsc(Long quizId);
}

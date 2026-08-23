package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface QuizRepository extends JpaRepository<Quiz, Long> {

    /**
     * Bugün için bir topic+language'in en fazla bir aktif quiz'i var (enum quiz
     * yeni modele bu şekilde taşındı) — birden fazla aktif quiz olan bir
     * topic+language ortaya çıkarsa bu metot "ilkini" döner, bu bilinçli bir
     * v1 basitleştirmesi (bkz. plan).
     */
    Optional<Quiz> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(Long topicId, Language language);

    @Query("select q from Quiz q join fetch q.topic t where t.slug = :topicSlug " +
            "and q.language = :language and q.slug = :quizSlug and q.active = true")
    Optional<Quiz> findByTopicSlugAndLanguageAndSlugAndActiveTrue(String topicSlug, Language language, String quizSlug);
}

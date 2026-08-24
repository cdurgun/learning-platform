import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

// This project's own QuizRepository -- a query no method name could
// derive cleanly (three conditions across two joined entities, one of
// them a relationship's own field). @Query switches from a generated
// query to one written directly in JPQL.
interface QuizJpqlRepositoryExample extends JpaRepository<QuizJpqlExample, Long> {

    // JPQL looks like SQL, but queries ENTITIES and their fields (Quiz,
    // q.topic, t.slug), not tables and columns -- Hibernate translates
    // this into real SQL against "quiz"/"topic" underneath, exactly the
    // same translation step covered in "JPA, Hibernate, and Spring Data
    // JPA."
    //
    // The method's own parameter NAMES (topicSlug, language, quizSlug)
    // bind directly to the query's :topicSlug/:language/:quizSlug --
    // Spring Data JPA matches them by name, with no separate @Param
    // annotation required here.
    @Query("select q from Quiz q join fetch q.topic t where t.slug = :topicSlug " +
            "and q.language = :language and q.slug = :quizSlug and q.active = true")
    Optional<QuizJpqlExample> findByTopicSlugAndLanguageAndSlugAndActiveTrue(
            String topicSlug, String language, String quizSlug);
}

class QuizJpqlExample {
}

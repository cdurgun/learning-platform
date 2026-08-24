import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

// Two real join fetch queries from this project -- TopicTranslationRepository
// and QuizQuestionRepository. "join fetch" itself, and the
// LazyInitializationException it avoids, is already covered in full in
// "Transaction Management" -- this only looks at the JPQL syntax itself.
interface JoinFetchRepositoryExample extends JpaRepository<TopicTranslationExample, Long> {

    // A single "join fetch" pulls the related Topic back in the SAME
    // query, instead of a separate query per row later -- exactly the
    // technique "Transaction Management" uses to sidestep
    // LazyInitializationException for this project's sitemap generation.
    @Query("select tt from TopicTranslationExample tt join fetch tt.topic where tt.published = true")
    List<TopicTranslationExample> findAllPublishedWithTopic();
}

interface QuizQuestionRepositoryExample extends JpaRepository<QuizQuestionExample, Long> {

    // Multiple "join fetch" clauses chain together -- this one pulls back
    // QuizQuestion, its Question, AND that Question's own Topic, all in
    // one query. Chaining joins like this to avoid running one query per
    // relationship, per row, is exactly the shape of problem "Relationships,
    // Fetching, and the N+1 Problem," later in this category, covers in
    // full -- this lesson only needs the JPQL syntax itself.
    @Query("select qq from QuizQuestionExample qq join fetch qq.question q join fetch q.topic " +
            "where qq.quiz.id = :quizId order by qq.position asc")
    List<QuizQuestionExample> findByQuizIdOrderByPositionAsc(Long quizId);
}

class TopicTranslationExample {
}

class QuizQuestionExample {
}

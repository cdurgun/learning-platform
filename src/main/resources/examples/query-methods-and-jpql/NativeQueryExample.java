import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

// This project's own QuestionRepository.findRandomPublishedPool -- real,
// running code behind the Practice feature's random-question selection.
interface QuestionNativeRepositoryExample extends JpaRepository<QuestionNativeExample, Long> {

    // nativeQuery = true switches from JPQL (which queries entities and
    // their fields) to REAL SQL (which queries the actual "question"
    // table and its actual columns) -- used here because JPQL has no
    // portable RANDOM() function, and this query specifically needs
    // database-level random ordering. The trade-off: a native query is
    // tied to the actual database schema and to PostgreSQL's own SQL
    // dialect, not just to the entity model -- reach for one only when a
    // JPQL query genuinely can't express what's needed, as here.
    @Query(value = "SELECT * FROM question q " +
            "WHERE q.status = 'PUBLISHED' " +
            "AND q.language = :language " +
            "AND (:topicId IS NULL OR q.topic_id = :topicId) " +
            "ORDER BY RANDOM() " +
            "LIMIT :count",
            nativeQuery = true)
    List<QuestionNativeExample> findRandomPublishedPool(@Param("topicId") Long topicId,
                                                          @Param("language") String language,
                                                          @Param("count") int count);
}

class QuestionNativeExample {
}

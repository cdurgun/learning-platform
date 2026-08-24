import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

// A DTO/record projection -- as "Record" already covers, using a record
// as a JPQL "constructor expression" target. Unlike TopicSummary's
// interface projection (Spring Data JPA proxies it automatically), a
// record projection requires the query to say EXACTLY how to build one,
// via "select new fully.qualified.RecordName(...)".
record TopicTitleView(String slug, String title) {
}

interface TopicTranslationProjectionRepositoryExample extends org.springframework.data.jpa.repository.JpaRepository<TopicTranslationProjectionExample, Long> {

    // This project's Topic entity carries no title itself -- title lives
    // on TopicTranslation, one per language (see "JPA, Hibernate, and
    // Spring Data JPA"'s and "Entities and the Repository Abstraction"'s
    // real Topic/TopicTranslation classes). This query joins across that
    // relationship and constructs a TopicTitleView directly -- pulling
    // back exactly two columns, from two tables, with no intermediate
    // entity ever loaded.
    @Query("select new com.cdurgun.learning.example.TopicTitleView(tt.topic.slug, tt.title) " +
            "from TopicTranslationProjectionExample tt " +
            "where tt.language = :language and tt.published = true")
    List<TopicTitleView> findAllPublishedTitles(String language);
}

class TopicTranslationProjectionExample {
}

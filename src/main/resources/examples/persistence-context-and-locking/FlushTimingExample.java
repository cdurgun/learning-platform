import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Id;
import jakarta.persistence.Query;

@Entity
class TopicFlushExample {
    @Id
    private Long id;
    private String difficulty;
}

class FlushTimingExample {

    // A flush is when tracked changes are actually SENT to the database
    // as SQL -- not the same moment as the change itself (setting a
    // field) or the same moment as the transaction committing.
    static void demonstrateAutoFlush(EntityManager em) {
        TopicFlushExample topic = em.find(TopicFlushExample.class, 1L);
        topic.difficulty = "ADVANCED"; // tracked, not yet sent to the database

        // Hibernate AUTO-FLUSHES before running a query whose result could
        // be affected by pending changes -- this JPQL query touches the
        // "difficulty" column, so Hibernate flushes the change above FIRST,
        // to guarantee the query sees it, even though flush() was never
        // called explicitly.
        Query query = em.createQuery("select t from TopicFlushExample t where t.difficulty = 'ADVANCED'");
        query.getResultList(); // topic (id=1) is included -- the flush already happened

        // An EXPLICIT flush forces this same thing to happen right now,
        // without waiting for a query or the transaction's own commit --
        // useful when code genuinely needs to know a change has reached
        // the database before continuing, without ending the transaction.
        em.flush();
    }
}

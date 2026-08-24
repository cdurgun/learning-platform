import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Id;

@Entity
class TopicMergeExample {
    @Id
    private Long id;
    private String slug;

    TopicMergeExample() {
    }

    TopicMergeExample(Long id, String slug) {
        this.id = id;
        this.slug = slug;
    }
}

class PersistMergeDetachExample {

    // A realistic scenario: a Topic loaded in one request (or one layer),
    // then modified and handed to a DIFFERENT persistence context later
    // -- for instance, a DTO-to-entity conversion happening outside the
    // original transaction. This "topic" object is DETACHED: it has an
    // id, but this EntityManager has never seen it.
    static void updateDetachedTopic(EntityManager em, TopicMergeExample detachedTopic) {
        // persist(...) would be WRONG here -- it's for entities that have
        // never existed in the database at all; calling it on an object
        // that already has an id representing an existing row risks a
        // duplicate-key error rather than an update.

        // merge(...) is the correct operation for a detached entity: it
        // copies this object's field values onto a MANAGED entity (loading
        // it first if needed) and returns THAT managed entity -- the
        // original "detachedTopic" parameter itself stays detached and
        // untracked.
        TopicMergeExample managed = em.merge(detachedTopic);

        managed.slug = "updated-via-merge"; // tracked, because "managed" is managed
        // detachedTopic.slug = "ignored";   // would NOT be tracked -- still detached
    }
}

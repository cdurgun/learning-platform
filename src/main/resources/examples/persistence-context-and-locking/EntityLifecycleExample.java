import jakarta.persistence.Entity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Id;

// This project's own code never touches EntityManager directly -- every
// repository method (save, findById, delete) already wraps it. But
// repository.save(...) is ITSELF built on the operations shown here --
// understanding them is what makes dirty checking (already covered in
// "Transaction Management") make sense as something more than "magic."
@Entity
class TopicLifecycleExample {
    @Id
    private Long id;
    private String slug;

    TopicLifecycleExample() {
    }

    TopicLifecycleExample(Long id, String slug) {
        this.id = id;
        this.slug = slug;
    }
}

class EntityLifecycleExample {

    static void demonstrateLifecycle(EntityManager em) {
        // TRANSIENT: a plain Java object, "new"'d up -- the persistence
        // context has never heard of it, and nothing about it is tracked.
        TopicLifecycleExample topic = new TopicLifecycleExample(1L, "records");

        // MANAGED: persist(...) hands this object to the persistence
        // context -- from this point on, any field change is tracked, and
        // will be written to the database at the next flush, with no
        // explicit save() call required (this IS dirty checking).
        em.persist(topic);
        topic.slug = "record"; // tracked automatically -- no save() needed

        // DETACHED: once the persistence context closes (the transaction
        // ends) or detach(...) is called explicitly, the entity is no
        // longer tracked -- further field changes are NOT written back
        // automatically anymore.
        em.detach(topic);
        topic.slug = "ignored-change"; // NOT tracked -- topic is detached now

        // REMOVED: remove(...) schedules a managed entity for deletion at
        // the next flush -- it must be re-attached (merged) first if it's
        // currently detached, since remove(...) only works on managed entities.
        TopicLifecycleExample managedAgain = em.merge(topic);
        em.remove(managedAgain);
    }
}

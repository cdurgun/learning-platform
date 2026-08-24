import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Version;
import org.springframework.dao.OptimisticLockingFailureException;
import org.springframework.data.jpa.repository.JpaRepository;

@Entity
class TopicVersionExample {
    @Id
    private Long id;
    private Integer estimatedMinutes;

    // @Version adds a column Hibernate manages entirely on its own -- every
    // UPDATE increments it, and every UPDATE's WHERE clause checks it still
    // matches the value this entity was loaded with:
    //   UPDATE topic SET estimated_minutes = ?, version = version + 1
    //   WHERE id = ? AND version = ?  (the version read at load time)
    @Version
    private Integer version;

    void setEstimatedMinutes(int minutes) {
        this.estimatedMinutes = minutes;
    }
}

interface TopicVersionRepositoryExample extends JpaRepository<TopicVersionExample, Long> {
}

class OptimisticLockingExample {

    // "Optimistic" because it assumes collisions are RARE -- no lock is
    // held while the entity is read and modified; the check only happens
    // at write time, at essentially no cost when nothing actually collides.
    static void demonstrateCollision(TopicVersionRepositoryExample repository) {
        TopicVersionExample loadedByUserA = repository.findById(1L).orElseThrow(); // version = 3
        TopicVersionExample loadedByUserB = repository.findById(1L).orElseThrow(); // ALSO version = 3

        loadedByUserA.setEstimatedMinutes(30);
        repository.save(loadedByUserA); // succeeds -- version 3 still matches; row becomes version 4

        loadedByUserB.setEstimatedMinutes(45);
        try {
            repository.save(loadedByUserB); // the WHERE ... AND version = 3 now matches NO row
        } catch (OptimisticLockingFailureException e) {
            // User B's save fails -- the row's version is 4 now, not 3, so
            // the UPDATE's WHERE clause matched zero rows, and Spring Data
            // JPA reports that as this exception instead of silently doing
            // nothing.
            System.out.println("Someone else already changed this topic: " + e.getMessage());
        }
    }
}

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;

@Entity
class TopicLockExample {
    @Id
    private Long id;
    private Integer estimatedMinutes;
}

interface TopicLockRepositoryExample extends JpaRepository<TopicLockExample, Long> {

    // "Pessimistic" because it assumes a collision is LIKELY enough to
    // prevent outright, rather than detect after the fact -- @Lock adds a
    // real database-level lock (PostgreSQL's SELECT ... FOR UPDATE) at
    // READ time. Any other transaction trying to read this same row with
    // its own PESSIMISTIC_WRITE lock simply WAITS until this transaction
    // commits or rolls back.
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select t from TopicLockExample t where t.id = :id")
    TopicLockExample findByIdForUpdate(Long id);
}

// Optimistic locking (the default, everyday choice) detects a collision
// after it happens and rejects the losing write. Pessimistic locking
// prevents the collision from being possible in the first place, at the
// cost of making every other transaction wait -- reach for it only for
// genuinely high-contention operations (a shared counter, a seat
// reservation), not as a default.

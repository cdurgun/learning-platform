import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import org.springframework.data.jpa.repository.JpaRepository;

@Entity
class TopicCacheExample {
    @Id
    private Long id;
    private String slug;
}

interface TopicCacheRepositoryExample extends JpaRepository<TopicCacheExample, Long> {
}

class FirstLevelCacheExample {

    static void demonstrateIdentityMap(TopicCacheRepositoryExample repository) {
        // Within the SAME persistence context (the same transaction), two
        // separate calls asking for the SAME id don't run two separate
        // SELECT queries returning two separate Java objects -- the
        // persistence context's first-level cache recognizes "id 5" is
        // already being tracked, and hands back the EXACT SAME instance.
        TopicCacheExample first = repository.findById(5L).orElseThrow();
        TopicCacheExample second = repository.findById(5L).orElseThrow();

        System.out.println(first == second);
        // true -- not just equal, but the literal same object reference.
        // Only the FIRST call actually queried the database; the second
        // was answered entirely from the first-level cache.
    }
}

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

// This is a simplified, teaching-focused look at THIS PROJECT'S OWN
// TopicRepository (see src/main/java/com/cdurgun/learning/repository/
// TopicRepository.java) -- extending JpaRepository<Topic, Long> is the
// entire implementation. No class implements this interface by hand;
// Spring Data JPA generates a working implementation at runtime.
interface TopicRepositoryExample extends JpaRepository<TopicExample, Long> {

    // save(topic), findById(id), findAll(), deleteById(id), and more all
    // come from JpaRepository for free -- none of them are written here.

    // findBySlug(...) is NOT free the same way -- Spring Data JPA reads
    // this method's NAME and derives a "WHERE slug = ?" query from it.
    // Exactly how that derivation works is the subject of "Query Methods
    // and JPQL with @Query," the lesson after next -- for now, notice only
    // that no query, no SQL, no JPQL is written here, and yet this method
    // works.
    Optional<TopicExample> findBySlug(String slug);
}

class TopicExample {
    private Long id;
    private String slug;
}

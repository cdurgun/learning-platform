import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@Entity
class TopicDataJpaExample {
    @Id
    @GeneratedValue
    private Long id;
    private String slug;

    TopicDataJpaExample() {
    }

    TopicDataJpaExample(String slug) {
        this.slug = slug;
    }

    String getSlug() {
        return slug;
    }
}

interface TopicDataJpaRepositoryExample extends JpaRepository<TopicDataJpaExample, Long> {
    Optional<TopicDataJpaExample> findBySlug(String slug);
}

// @DataJpaTest is @WebMvcTest's sibling slice test -- instead of loading
// only the web layer, it loads only the PERSISTENCE layer: entities,
// repositories, and the actual database connection, but none of this
// project's controllers or services. Each test method also runs inside
// its own transaction, rolled back automatically afterward -- one test's
// data never leaks into the next.
@DataJpaTest
class DataJpaTestWithTestEntityManagerExample {

    // TestEntityManager -- distinct from the EntityManager covered in
    // "The Persistence Context and Locking" -- is a test-focused wrapper
    // around it, with convenience methods for getting data into the
    // database WITHOUT going through the repository being tested. That
    // separation matters: if setup used the same repository method the
    // test is trying to verify, a bug in that method could hide itself.
    @org.springframework.beans.factory.annotation.Autowired
    private TestEntityManager entityManager;

    @org.springframework.beans.factory.annotation.Autowired
    private TopicDataJpaRepositoryExample repository;

    @Test
    void findBySlug_returnsTheRealPersistedTopic() {
        // persistAndFlush(...) saves the entity AND forces an immediate
        // flush (covered in "The Persistence Context and Locking") --
        // guaranteeing the row genuinely exists in the database before
        // the test calls the repository method it's actually testing.
        entityManager.persistAndFlush(new TopicDataJpaExample("records"));

        Optional<TopicDataJpaExample> found = repository.findBySlug("records");

        // Unlike MockedRepositoryLimitationExample, this genuinely
        // exercises Spring Data JPA's real query derivation, a real SQL
        // query, and a real database -- if "findBySlug" were misspelled
        // or filtered on the wrong column, THIS test would fail.
        assertThat(found).isPresent();
        assertThat(found.get().getSlug()).isEqualTo("records");
    }
}

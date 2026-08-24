import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@Entity
class CategoryQueryTestExample {
    @Id
    @GeneratedValue
    private Long id;
    private String name;

    CategoryQueryTestExample() {
    }

    CategoryQueryTestExample(String name) {
        this.name = name;
    }

    String getName() {
        return name;
    }
}

@Entity
class TopicQueryTestExample {
    @Id
    @GeneratedValue
    private Long id;
    private String slug;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private CategoryQueryTestExample category;

    TopicQueryTestExample() {
    }

    TopicQueryTestExample(String slug, CategoryQueryTestExample category) {
        this.slug = slug;
        this.category = category;
    }

    CategoryQueryTestExample getCategory() {
        return category;
    }
}

interface TopicQueryTestRepositoryExample extends JpaRepository<TopicQueryTestExample, Long> {

    @Query("select t from TopicQueryTestExample t join fetch t.category where t.slug = :slug")
    Optional<TopicQueryTestExample> findBySlugWithCategory(String slug);
}

// A hand-written @Query -- like this project's real
// TopicRepository.findBySlugWithCategoryAndCourse, covered in "Transaction
// Management" -- is exactly as easy to get syntactically wrong (a typo'd
// property path, a missing join) as a derived method name. @DataJpaTest
// verifies the JPQL itself actually runs and returns what it should.
@DataJpaTest
class CustomQueryTestExample {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private TopicQueryTestRepositoryExample repository;

    @Test
    void findBySlugWithCategory_joinsTheRelationshipCorrectly() {
        CategoryQueryTestExample category = entityManager.persistAndFlush(
                new CategoryQueryTestExample("Spring MVC"));
        entityManager.persistAndFlush(new TopicQueryTestExample("records", category));

        // If the join fetch's JPQL had a typo, this test would fail here
        // -- either with no result at all, or with a real
        // LazyInitializationException the moment the category is
        // accessed outside this still-open test transaction.
        Optional<TopicQueryTestExample> found = repository.findBySlugWithCategory("records");

        assertThat(found).isPresent();
        assertThat(found.get().getCategory().getName()).isEqualTo("Spring MVC");
    }
}

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@Entity
class CodeExampleTestExample {
    @Id
    @GeneratedValue
    private Long id;
    private Long topicId;
    private Integer sortOrder;

    CodeExampleTestExample() {
    }

    CodeExampleTestExample(Long topicId, Integer sortOrder) {
        this.topicId = topicId;
        this.sortOrder = sortOrder;
    }

    Integer getSortOrder() {
        return sortOrder;
    }
}

interface CodeExampleTestRepositoryExample extends JpaRepository<CodeExampleTestExample, Long> {
    List<CodeExampleTestExample> findByTopicIdOrderBySortOrderAsc(Long topicId);
}

// Testing this project's real CodeExampleRepository.findByTopicIdOrderBySortOrderAsc
// (covered in "Query Methods and JPQL with @Query") -- proving both that
// the FILTER is correct (only this topic's rows) and that the ORDERING is
// correct (sort_order ascending), which a mocked repository could never
// actually verify.
@DataJpaTest
class DerivedQueryMethodTestExample {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private CodeExampleTestRepositoryExample repository;

    @Test
    void findByTopicIdOrderBySortOrderAsc_filtersAndOrdersCorrectly() {
        // Data for TWO different topics, and deliberately out of order --
        // a passing test here proves the query does real filtering and
        // real ordering, not just "returns whatever was saved."
        entityManager.persist(new CodeExampleTestExample(1L, 2));
        entityManager.persist(new CodeExampleTestExample(1L, 1));
        entityManager.persist(new CodeExampleTestExample(2L, 1)); // a different topic entirely
        entityManager.flush();

        List<CodeExampleTestExample> result = repository.findByTopicIdOrderBySortOrderAsc(1L);

        assertThat(result).hasSize(2); // topic 2's row correctly excluded
        assertThat(result.get(0).getSortOrder()).isEqualTo(1); // correctly ordered
        assertThat(result.get(1).getSortOrder()).isEqualTo(2);
    }
}

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// @EntityGraph fixes the N+1 problem from NPlusOneProblemExample for THIS
// one query, without changing the relationship's fetch type globally
// (which would affect every other query using this entity too).
interface CategoryEntityGraphRepositoryExample extends JpaRepository<CategoryGraphExample, Long> {

    // attributePaths names exactly which lazy relationship(s) to pull back
    // eagerly, for this method only -- the equivalent of "join fetch t.topics"
    // in JPQL (already covered for a @ManyToOne relationship in "Transaction
    // Management"), expressed as an annotation instead.
    @EntityGraph(attributePaths = "topics")
    List<CategoryGraphExample> findAll();
}

@Entity
class CategoryGraphExample {
    @Id
    private Long id;

    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<TopicGraphExample> topics;
}

@Entity
class TopicGraphExample {
    @Id
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private CategoryGraphExample category;
}

// With this @EntityGraph in place, calling findAll() now runs ONE query
// (fetching every Category with its Topics already joined in), instead of
// the 1+N queries NPlusOneProblemExample triggered -- the loop over
// category.getTopics() no longer touches the database at all, because the
// data is already there.

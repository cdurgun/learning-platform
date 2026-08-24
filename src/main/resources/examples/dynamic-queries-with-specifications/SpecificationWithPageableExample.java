import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

// JpaSpecificationExecutor's findAll ALSO accepts a Pageable, exactly the
// same Page<T> type covered in "Pagination, Sorting, and Projections" --
// dynamic filtering and real pagination aren't separate mechanisms, they
// combine into a single call.
interface TopicSearchRepositoryExample
        extends JpaRepository<TopicSearchExample, Long>, JpaSpecificationExecutor<TopicSearchExample> {
}

class TopicSearchExample {
    String category;
    String difficulty;
}

class SpecificationWithPageableExample {

    static Specification<TopicSearchExample> hasCategory(String category) {
        return (Root<TopicSearchExample> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                cb.equal(root.get("category"), category);
    }

    public static void main(String[] args) {
        Specification<TopicSearchExample> spec = Specification.where(hasCategory("spring-mvc"));
        Pageable pageable = PageRequest.of(0, 10);

        // repository.findAll(spec, pageable) would generate a filtered,
        // paged query PLUS a filtered count query -- the same two-query
        // shape "Pagination, Sorting, and Projections" already covered,
        // now with a dynamic WHERE clause instead of a fixed one.
        System.out.println(spec != null && pageable != null);
    }
}

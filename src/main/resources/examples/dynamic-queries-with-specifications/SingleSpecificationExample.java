import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;

// A Specification<Topic> is a small functional interface -- Java code
// that BUILDS a Predicate (a WHERE condition) instead of a query being
// written out as text, the way JPQL and native SQL both are.
class SingleSpecificationExample {

    static class Topic {
        String difficulty;
    }

    // Root<Topic> is how the Criteria API refers to "the Topic being
    // queried" -- root.get("difficulty") is the Criteria API's way of
    // writing t.difficulty. CriteriaBuilder is what actually constructs a
    // Predicate -- here, an equality check -- from that path and a value.
    static Specification<Topic> hasDifficulty(String difficulty) {
        return (Root<Topic> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                cb.equal(root.get("difficulty"), difficulty);
    }

    public static void main(String[] args) {
        Specification<Topic> spec = hasDifficulty("ADVANCED");
        System.out.println(spec != null);
        // This alone doesn't run anything yet -- a Specification only
        // BUILDS a Predicate; something still has to hand it to a
        // repository, covered next in "JpaSpecificationExecutor."
    }
}

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;

class CombiningSpecificationsExample {

    static class Topic {
        String category;
        String difficulty;
    }

    static Specification<Topic> hasCategory(String category) {
        return (Root<Topic> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                cb.equal(root.get("category"), category);
    }

    static Specification<Topic> hasDifficulty(String difficulty) {
        return (Root<Topic> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                cb.equal(root.get("difficulty"), difficulty);
    }

    public static void main(String[] args) {
        // Specification.where(...) starts a chain; .and(...)/.or(...)
        // combine two Specifications into a single, larger one -- exactly
        // the way DynamicFilterExample ("REST API Design") combined two
        // Predicates with .and(...), except this builds a real SQL WHERE
        // clause instead of filtering an in-memory Stream.
        Specification<Topic> spec = Specification
                .where(hasCategory("spring-mvc"))
                .and(hasDifficulty("ADVANCED"));
        // Generates: WHERE category = 'spring-mvc' AND difficulty = 'ADVANCED'

        Specification<Topic> either = Specification
                .where(hasCategory("spring-mvc"))
                .or(hasDifficulty("ADVANCED"));
        // Generates: WHERE category = 'spring-mvc' OR difficulty = 'ADVANCED'

        System.out.println(spec != null && either != null);
    }
}

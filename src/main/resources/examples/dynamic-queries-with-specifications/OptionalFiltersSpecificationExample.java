import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;

// This is the SAME shape of problem "REST API Design"'s DynamicFilterExample
// solved with an in-memory Predicate chain -- category and difficulty are
// each OPTIONAL, and an absent filter should exclude nothing. Here, the
// exact same idea is pushed into the database instead.
class OptionalFiltersSpecificationExample {

    static class Topic {
        String category;
        String difficulty;
    }

    // Specification.where(null) is a genuinely useful starting point -- it
    // behaves as a no-op "match everything" Specification, exactly the
    // way DynamicFilterExample's absent filters defaulted to "t -> true."
    static Specification<Topic> search(String category, String difficulty) {
        Specification<Topic> spec = Specification.where(null);

        if (category != null) {
            spec = spec.and((Root<Topic> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                    cb.equal(root.get("category"), category));
        }
        if (difficulty != null) {
            spec = spec.and((Root<Topic> root, CriteriaQuery<?> query, CriteriaBuilder cb) ->
                    cb.equal(root.get("difficulty"), difficulty));
        }

        return spec;
        // category=null, difficulty=null   -> WHERE 1=1 (no filtering at all)
        // category="spring-mvc", diff=null -> WHERE category = 'spring-mvc'
        // both supplied                    -> WHERE category = ... AND difficulty = ...
    }

    public static void main(String[] args) {
        System.out.println(search("spring-mvc", null) != null);
        System.out.println(search(null, null) != null);
    }
}

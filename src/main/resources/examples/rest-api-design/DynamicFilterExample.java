import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

// Query parameters like ?difficulty=ADVANCED&category=spring-mvc filter a collection --
// each present parameter narrows the result, each absent one is simply skipped.
// A real repository would push this down into a WHERE clause (or a JPA Specification
// for cases this dynamic); this example keeps the filtering logic itself visible by
// building it as a chain of optional Predicates over an in-memory list.
class DynamicFilterExample {

    record Topic(String slug, String category, String difficulty) {
    }

    static List<Topic> filter(List<Topic> topics, String category, String difficulty) {
        Predicate<Topic> byCategory = Optional.ofNullable(category)
                .<Predicate<Topic>>map(c -> t -> t.category().equals(c))
                .orElse(t -> true);
        Predicate<Topic> byDifficulty = Optional.ofNullable(difficulty)
                .<Predicate<Topic>>map(d -> t -> t.difficulty().equals(d))
                .orElse(t -> true);

        return topics.stream().filter(byCategory.and(byDifficulty)).toList();
    }

    public static void main(String[] args) {
        List<Topic> topics = List.of(
                new Topic("advanced-spring-mvc", "spring-mvc", "ADVANCED"),
                new Topic("spring-mvc-fundamentals", "spring-mvc", "INTERMEDIATE"),
                new Topic("threads", "concurrency", "ADVANCED"));

        System.out.println(filter(topics, "spring-mvc", null));
        // [Topic[advanced-spring-mvc,...], Topic[spring-mvc-fundamentals,...]] -- category only

        System.out.println(filter(topics, "spring-mvc", "ADVANCED"));
        // [Topic[advanced-spring-mvc,...]] -- both filters applied

        System.out.println(filter(topics, null, null));
        // all three -- no filters means every predicate defaults to "true"
    }
}

import java.util.Optional;

// map() transforms the value INSIDE an Optional, without you having to check
// isPresent() first -- if the Optional is empty, map() just returns empty, the
// function is never called. flatMap() solves the same nesting problem it solves for
// Stream (the Stream Fundamentals lesson): if the mapping function itself returns an
// Optional, map() would produce an Optional<Optional<T>> -- flatMap() flattens that.
class OptionalMapFlatMapExample {
    public static void main(String[] args) {
        Optional<String> name = Optional.of("ahmet");

        Optional<String> upper = name.map(String::toUpperCase);
        System.out.println(upper.get());

        Optional<String> empty = Optional.empty();
        Optional<String> stillEmpty = empty.map(String::toUpperCase);
        System.out.println(stillEmpty.isEmpty());

        // If the lookup itself can fail, it naturally returns an Optional -- map()
        // would nest it: Optional<Optional<String>>.
        Optional<Optional<String>> nested = name.map(OptionalMapFlatMapExample::findEmail);
        System.out.println(nested.get().get());

        // flatMap() merges the inner Optional into the outer one instead of nesting.
        Optional<String> flat = name.flatMap(OptionalMapFlatMapExample::findEmail);
        System.out.println(flat.orElse("not found"));
    }

    // A lookup that might not find anything -- naturally returns Optional itself.
    static Optional<String> findEmail(String username) {
        return username.equals("ahmet") ? Optional.of("ahmet@example.com") : Optional.empty();
    }
}

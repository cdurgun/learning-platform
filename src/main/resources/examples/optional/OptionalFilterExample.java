import java.util.Optional;

// filter(Predicate) keeps the value only if it matches the condition -- otherwise it
// turns a present Optional into an empty one. It never touches an already-empty
// Optional (the Predicate is only tested when a value exists).
class OptionalFilterExample {
    public static void main(String[] args) {
        Optional<String> name = Optional.of("Ahmet");

        Optional<String> longEnough = name.filter(n -> n.length() > 3);
        System.out.println(longEnough.orElse("too short"));

        Optional<String> tooShort = name.filter(n -> n.length() > 10);
        System.out.println(tooShort.orElse("too short"));

        // filter() combines naturally with map() and orElse() into a short validation
        // chain -- no explicit isPresent()/get() calls needed anywhere.
        String result = Optional.of("ahmet")
                .filter(n -> !n.isBlank())
                .map(String::toUpperCase)
                .orElse("INVALID");
        System.out.println(result);
    }
}

import java.util.Optional;

// Optional<T> wraps a value that might be absent -- it exists to make that possibility
// visible in a method's return type, instead of silently returning null. Three factory
// methods create one: of() for a value known to be non-null, ofNullable() for a value
// that might be null, and empty() for a deliberately absent value.
class OptionalCreationExample {
    public static void main(String[] args) {
        Optional<String> present = Optional.of("hello");
        System.out.println(present.isPresent());
        System.out.println(present.isEmpty());
        System.out.println(present.get());

        // of() throws NullPointerException immediately if given null -- it's a
        // deliberate assertion that the value is never null.
        try {
            Optional.of(null);
        } catch (NullPointerException e) {
            System.out.println("caught: of(null) is not allowed");
        }

        // ofNullable() accepts null gracefully, producing an empty Optional instead.
        String maybeNull = null;
        Optional<String> fromNullable = Optional.ofNullable(maybeNull);
        System.out.println(fromNullable.isPresent());

        Optional<String> empty = Optional.empty();
        System.out.println(empty.isEmpty());

        // Calling get() on an empty Optional throws -- exactly the NullPointerException
        // risk Optional exists to make visible and force you to handle explicitly.
        try {
            empty.get();
        } catch (java.util.NoSuchElementException e) {
            System.out.println("caught: get() on empty Optional");
        }
    }
}

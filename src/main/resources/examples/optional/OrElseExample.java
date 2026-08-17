import java.util.Optional;

// orElse(value) and orElseGet(supplier) both provide a default when the Optional is
// empty -- but they differ in WHEN the default is computed. orElse()'s argument is
// evaluated EAGERLY, every time, whether the Optional is present or not. orElseGet()'s
// Supplier is only invoked LAZILY, if the Optional actually turns out to be empty.
class OrElseExample {
    public static void main(String[] args) {
        Optional<String> present = Optional.of("value");

        System.out.println(present.orElse(computeDefault("orElse, present")));
        System.out.println(present.orElseGet(() -> computeDefault("orElseGet, present")));

        Optional<String> empty = Optional.empty();
        System.out.println(empty.orElse(computeDefault("orElse, empty")));
        System.out.println(empty.orElseGet(() -> computeDefault("orElseGet, empty")));
    }

    // Printing a message lets us SEE whether this actually ran or not.
    static String computeDefault(String label) {
        System.out.println("computing default: " + label);
        return "default";
    }
}

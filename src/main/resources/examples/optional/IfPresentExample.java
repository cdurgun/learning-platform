import java.util.Optional;

// ifPresent(Consumer) runs a side effect ONLY if a value is present -- the Optional
// equivalent of "if (value != null) { ... }", without an explicit null check.
// ifPresentOrElse(Consumer, Runnable), added in Java 9, adds an "else" branch for the
// empty case, which ifPresent() alone can't express.
class IfPresentExample {
    public static void main(String[] args) {
        Optional<String> present = Optional.of("Ahmet");
        Optional<String> empty = Optional.empty();

        present.ifPresent(name -> System.out.println("found: " + name));
        empty.ifPresent(name -> System.out.println("this never prints: " + name));

        present.ifPresentOrElse(
                name -> System.out.println("present branch: " + name),
                () -> System.out.println("empty branch"));
        empty.ifPresentOrElse(
                name -> System.out.println("present branch: " + name),
                () -> System.out.println("empty branch"));
    }
}

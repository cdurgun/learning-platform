import java.util.NoSuchElementException;
import java.util.Optional;

// orElseThrow() has two forms: no-argument, which throws a plain
// NoSuchElementException (identical to what get() throws), and one-argument, which
// takes a Supplier<X extends Throwable> so you can throw a specific, meaningful
// exception for your own domain.
class OrElseThrowExample {
    public static void main(String[] args) {
        Optional<String> empty = Optional.empty();

        try {
            empty.orElseThrow();
        } catch (NoSuchElementException e) {
            System.out.println("caught: no-arg orElseThrow()");
        }

        try {
            empty.orElseThrow(() -> new IllegalStateException("user not found"));
        } catch (IllegalStateException e) {
            System.out.println("caught: " + e.getMessage());
        }

        // On a present Optional, orElseThrow() just returns the value -- the Supplier
        // is never invoked, exactly like orElseGet().
        Optional<String> present = Optional.of("Ahmet");
        System.out.println(present.orElseThrow(() -> new IllegalStateException("never thrown")));
    }
}

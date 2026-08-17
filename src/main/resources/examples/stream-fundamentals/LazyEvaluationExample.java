import java.util.List;
import java.util.stream.Stream;

// Intermediate operations (filter, map, peek, ...) are LAZY -- calling them just
// builds up a pipeline description, nothing runs yet. Only a TERMINAL operation
// (count, toList, forEach, ...) actually triggers execution, pulling elements through
// the whole pipeline one at a time. A stream is also SINGLE-USE: once a terminal
// operation runs, that stream is closed and reusing it throws.
class LazyEvaluationExample {
    public static void main(String[] args) {
        Stream<String> pipeline = Stream.of("a", "b", "c")
                .peek(s -> System.out.println("processing: " + s))
                .filter(s -> !s.equals("b"));

        System.out.println("pipeline built, nothing printed yet");
        long count = pipeline.count();
        System.out.println("count: " + count);

        // Reusing an already-consumed stream throws IllegalStateException -- each
        // Stream is meant to be built and consumed exactly once.
        Stream<String> once = Stream.of("x", "y");
        once.count();
        try {
            once.count();
        } catch (IllegalStateException e) {
            System.out.println("caught: " + e.getMessage());
        }
    }
}

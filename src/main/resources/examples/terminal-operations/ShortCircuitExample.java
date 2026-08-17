import java.util.List;
import java.util.stream.Stream;

// Some terminal operations SHORT-CIRCUIT: they stop pulling elements through the
// pipeline as soon as the answer is known, instead of processing every element. This is
// only visible in combination with lazy evaluation (previous lesson) -- peek() lets us
// observe exactly how many elements were actually pulled through.
class ShortCircuitExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8);

        // anyMatch() stops at the FIRST match -- elements after it are never touched.
        boolean hasEven = numbers.stream()
                .peek(n -> System.out.println("checking: " + n))
                .anyMatch(n -> n % 2 == 0);
        System.out.println("result: " + hasEven);

        // findFirst() stops as soon as one matching element is found -- filter() itself
        // isn't short-circuiting, but findFirst() stops asking it for more once the
        // first match arrives.
        numbers.stream()
                .peek(n -> System.out.println("scanning: " + n))
                .filter(n -> n > 5)
                .findFirst();

        // count() is a special, surprising case -- NOT because it short-circuits after
        // finding an answer mid-stream, but because the JDK can sometimes compute the
        // count directly from the source's known size, skipping the pipeline entirely.
        // When that happens, peek() is never invoked at all (this is explicitly
        // documented behavior, not a bug): running this prints NO "counting: n" lines.
        long total = Stream.of(1, 2, 3)
                .peek(n -> System.out.println("counting: " + n))
                .count();
        System.out.println("total: " + total);
    }
}

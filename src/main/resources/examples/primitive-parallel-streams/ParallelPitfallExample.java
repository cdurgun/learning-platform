import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

// A classic parallel-stream pitfall: using forEach() to add into an ordinary,
// NOT-thread-safe ArrayList. Multiple threads calling add() on the same ArrayList at
// the same time can corrupt its internal state -- the result size may come out wrong,
// or an exception may be thrown, depending on timing (a real, observable data race).
// The fix: use a proper collector, which handles thread-safety internally.
class ParallelPitfallExample {
    public static void main(String[] args) {
        List<Integer> source = IntStream.rangeClosed(1, 100_000).boxed().toList();

        List<Integer> unsafe = new ArrayList<>();
        try {
            source.parallelStream().forEach(unsafe::add);
            System.out.println("no exception, size: " + unsafe.size() + " (expected " + source.size() + ")");
        } catch (Exception e) {
            System.out.println("exception: " + e.getClass().getSimpleName());
        }

        // The safe fix: collect() handles combining thread-local partial results
        // correctly, with no shared mutable state exposed to your own code.
        List<Integer> safe = source.parallelStream().collect(Collectors.toList());
        System.out.println("safe size: " + safe.size());
    }
}

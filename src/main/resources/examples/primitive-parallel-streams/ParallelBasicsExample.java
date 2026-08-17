import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

// parallelStream() (on a Collection) or stream().parallel() splits the pipeline's work
// across multiple threads from the common ForkJoinPool, instead of running it on a
// single thread. For an associative operation like sum(), the result is identical --
// only the execution strategy changes.
class ParallelBasicsExample {
    public static void main(String[] args) {
        List<Integer> numbers = IntStream.rangeClosed(1, 1_000_000).boxed().toList();

        long sequentialSum = numbers.stream().mapToLong(Integer::longValue).sum();
        long parallelSum = numbers.parallelStream().mapToLong(Integer::longValue).sum();
        System.out.println(sequentialSum == parallelSum);

        // Proof that multiple threads are actually used: collect the distinct thread
        // names that touched the pipeline.
        Set<String> threadNames = numbers.parallelStream()
                .map(n -> Thread.currentThread().getName())
                .collect(Collectors.toSet());
        System.out.println(threadNames.size() > 1);
    }
}

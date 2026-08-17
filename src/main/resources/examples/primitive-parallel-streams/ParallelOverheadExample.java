import java.util.List;
import java.util.stream.IntStream;

// Parallel streams have real overhead: splitting the work, coordinating threads via
// the ForkJoinPool, and merging partial results all cost time. For a small dataset or
// a cheap operation, that overhead can easily outweigh the benefit.
//
// A NAIVE one-shot nanoTime() comparison is misleading, though -- the JVM interprets
// code before its JIT compiler kicks in, so whichever path runs FIRST is unfairly
// slowed down by warmup cost, not by sequential-vs-parallel execution itself. This
// example runs each path repeatedly first (to let the JIT warm up), THEN times a
// later iteration -- the only way to get a measurement that means anything.
class ParallelOverheadExample {
    public static void main(String[] args) {
        List<Integer> smallList = IntStream.rangeClosed(1, 100).boxed().toList();

        // Warm up both paths so neither is penalized for still being interpreted.
        for (int i = 0; i < 10_000; i++) {
            smallList.stream().mapToLong(Integer::longValue).sum();
            smallList.parallelStream().mapToLong(Integer::longValue).sum();
        }

        long startSequential = System.nanoTime();
        for (int i = 0; i < 10_000; i++) {
            smallList.stream().mapToLong(Integer::longValue).sum();
        }
        long sequentialNanos = System.nanoTime() - startSequential;

        long startParallel = System.nanoTime();
        for (int i = 0; i < 10_000; i++) {
            smallList.parallelStream().mapToLong(Integer::longValue).sum();
        }
        long parallelNanos = System.nanoTime() - startParallel;

        System.out.println("sequential, 10000 runs: " + (sequentialNanos / 1_000_000) + "ms");
        System.out.println("parallel, 10000 runs: " + (parallelNanos / 1_000_000) + "ms");
        System.out.println("sequential was faster: " + (sequentialNanos < parallelNanos));
    }
}

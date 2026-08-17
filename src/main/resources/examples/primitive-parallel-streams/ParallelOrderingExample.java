import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.IntStream;

// forEach() on a parallel stream does NOT guarantee encounter order -- elements are
// processed by whichever thread picks them up, in whatever order that happens.
// forEachOrdered() forces processing back into encounter order, at the cost of giving
// up most of the parallelism benefit.
class ParallelOrderingExample {
    public static void main(String[] args) {
        List<Integer> numbers = IntStream.rangeClosed(1, 10).boxed().toList();

        List<Integer> unordered = new CopyOnWriteArrayList<>();
        numbers.parallelStream().forEach(unordered::add);
        System.out.println(unordered.equals(numbers));

        List<Integer> ordered = new CopyOnWriteArrayList<>();
        numbers.parallelStream().forEachOrdered(ordered::add);
        System.out.println(ordered.equals(numbers));
    }
}

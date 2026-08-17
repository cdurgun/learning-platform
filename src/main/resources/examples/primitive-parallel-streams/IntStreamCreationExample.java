import java.util.OptionalDouble;
import java.util.stream.IntStream;

// IntStream (LongStream/DoubleStream work the same way) is a stream SPECIALIZED for a
// primitive type -- avoiding the overhead of boxing every element into an Integer
// object. It offers aggregate methods a generic Stream<Integer> doesn't have directly:
// sum(), average(), max(), min().
class IntStreamCreationExample {
    public static void main(String[] args) {
        IntStream.range(1, 5).forEach(n -> System.out.print(n + " ")); // exclusive end
        System.out.println();

        IntStream.rangeClosed(1, 5).forEach(n -> System.out.print(n + " ")); // inclusive
        System.out.println();

        int sum = IntStream.rangeClosed(1, 100).sum();
        System.out.println(sum);

        OptionalDouble average = IntStream.of(2, 4, 6, 8).average();
        System.out.println(average.orElse(0));

        int max = IntStream.of(3, 7, 2, 9, 1).max().orElse(Integer.MIN_VALUE);
        System.out.println(max);
    }
}

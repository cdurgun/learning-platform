import java.util.List;
import java.util.stream.IntStream;
import java.util.stream.Stream;

// mapToInt() converts a Stream<T> into an IntStream -- typically to run an aggregate
// like sum()/average() that a plain object Stream doesn't offer. boxed() goes the other
// way, wrapping each primitive back into its object type (int -> Integer), needed
// whenever an API requires a Stream<Integer> instead of an IntStream.
class BoxingMapToIntExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");

        int totalLength = names.stream().mapToInt(String::length).sum();
        System.out.println(totalLength);

        double averageLength = names.stream().mapToInt(String::length).average().orElse(0);
        System.out.println(averageLength);

        // boxed(): IntStream -> Stream<Integer>, needed for object-based APIs like
        // collect() with Collectors (the previous lesson).
        List<Integer> lengths = names.stream().mapToInt(String::length).boxed().toList();
        System.out.println(lengths);

        // mapToObj(): the reverse direction, IntStream -> Stream<T> for any T, not just
        // the boxed wrapper type.
        Stream<String> labeled = IntStream.rangeClosed(1, 3).mapToObj(n -> "item-" + n);
        System.out.println(labeled.toList());
    }
}

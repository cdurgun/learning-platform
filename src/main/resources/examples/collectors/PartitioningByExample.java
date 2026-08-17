import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// partitioningBy(predicate) is a special case of grouping into EXACTLY two groups --
// true and false -- based on a Predicate. Unlike groupingBy(), both keys always exist
// in the result map, even if one group is empty.
class PartitioningByExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8);

        Map<Boolean, List<Integer>> evenOrOdd = numbers.stream()
                .collect(Collectors.partitioningBy(n -> n % 2 == 0));
        System.out.println(evenOrOdd);
        System.out.println(evenOrOdd.get(true));
        System.out.println(evenOrOdd.get(false));

        // Even with no matches for one side, both keys are still present -- unlike
        // groupingBy(), which would simply omit a key with no elements.
        Map<Boolean, List<Integer>> allEven = List.of(2, 4, 6).stream()
                .collect(Collectors.partitioningBy(n -> n % 2 == 0));
        System.out.println(allEven.get(false));
    }
}

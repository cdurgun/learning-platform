import java.util.List;

// distinct() removes duplicates (using equals()). sorted() orders elements, either by
// natural ordering (Comparable) or a given Comparator. peek() runs a Consumer on each
// element WITHOUT changing the stream -- it exists to observe a pipeline, most often
// for debugging, not for production side effects.
class DistinctSortedPeekExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(3, 1, 2, 3, 1, 4);

        List<Integer> distinctSorted = numbers.stream()
                .distinct()
                .sorted()
                .toList();
        System.out.println(distinctSorted);

        // sorted(Comparator) for custom ordering -- here, longest name first.
        List<String> names = List.of("Ayse", "Ali", "Mehmet");
        List<String> byLengthDesc = names.stream()
                .sorted((a, b) -> b.length() - a.length())
                .toList();
        System.out.println(byLengthDesc);

        // peek() prints each element as it flows through the pipeline, without
        // changing what the next operation sees.
        List<Integer> result = numbers.stream()
                .distinct()
                .peek(n -> System.out.println("peeked: " + n))
                .sorted()
                .toList();
        System.out.println(result);
    }
}

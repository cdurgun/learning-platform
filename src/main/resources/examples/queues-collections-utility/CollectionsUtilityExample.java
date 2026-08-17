import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

public class CollectionsUtilityExample {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(List.of(5, 3, 8, 1, 9, 2));

        Collections.sort(numbers);
        System.out.println("Collections.sort(): " + numbers);

        Collections.reverse(numbers);
        System.out.println("Collections.reverse(): " + numbers);

        System.out.println("Collections.max(): " + Collections.max(numbers));
        System.out.println("Collections.min(): " + Collections.min(numbers));

        List<String> letters = List.of("a", "b", "a", "c", "a", "b");
        System.out.println("Collections.frequency(letters, \"a\"): " + Collections.frequency(letters, "a"));

        // binarySearch() requires a SORTED list -- O(log n) instead of a linear scan.
        Collections.sort(numbers);
        System.out.println("Sorted for binarySearch(): " + numbers);
        System.out.println("Collections.binarySearch(numbers, 8): index " + Collections.binarySearch(numbers, 8));

        // shuffle() with a seeded Random -- deterministic here only so the example's
        // output is reproducible; in real code you'd normally omit the seed.
        List<Integer> toShuffle = new ArrayList<>(List.of(1, 2, 3, 4, 5));
        Collections.shuffle(toShuffle, new Random(42));
        System.out.println("Collections.shuffle() (seeded for reproducibility): " + toShuffle);

        // Factory methods for small/special-purpose immutable collections.
        System.out.println("Collections.emptyList(): " + Collections.emptyList());
        System.out.println("Collections.singletonList(\"x\"): " + Collections.singletonList("x"));
        System.out.println("Collections.nCopies(4, \"z\"): " + Collections.nCopies(4, "z"));
    }
}

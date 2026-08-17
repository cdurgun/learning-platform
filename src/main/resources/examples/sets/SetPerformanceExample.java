import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class SetPerformanceExample {
    public static void main(String[] args) {
        // Measurement 1: the difference between List.contains() (O(n)) and
        // Set.contains() (HashSet O(1), TreeSet O(log n)) on the same 20,000-element
        // collection.
        int size = 20_000;
        List<Integer> list = new ArrayList<>();
        Set<Integer> hashSet = new HashSet<>();
        Set<Integer> treeSet = new TreeSet<>();
        for (int i = 0; i < size; i++) {
            list.add(i);
            hashSet.add(i);
            treeSet.add(i);
        }

        int target = size - 1; // worst case for List: at the very end
        int rounds = 2_000;

        // Warm-up -- run all three paths a lot before measuring.
        for (int i = 0; i < rounds; i++) {
            list.contains(target);
            hashSet.contains(target);
            treeSet.contains(target);
        }

        long listStart = System.nanoTime();
        for (int i = 0; i < rounds; i++) list.contains(target);
        long listNanos = System.nanoTime() - listStart;

        long hashSetStart = System.nanoTime();
        for (int i = 0; i < rounds; i++) hashSet.contains(target);
        long hashSetNanos = System.nanoTime() - hashSetStart;

        long treeSetStart = System.nanoTime();
        for (int i = 0; i < rounds; i++) treeSet.contains(target);
        long treeSetNanos = System.nanoTime() - treeSetStart;

        System.out.println("contains(), " + rounds + " times, a " + size + "-element collection:");
        System.out.println("  List (O(n)):        " + (listNanos / 1_000_000) + " ms");
        System.out.println("  HashSet (O(1)):     " + (hashSetNanos / 1_000_000) + " ms");
        System.out.println("  TreeSet (O(log n)): " + (treeSetNanos / 1_000_000) + " ms");

        // Measurement 2: at this scale, HashSet/TreeSet both look "instant" -- to
        // actually SEE the O(1) / O(log n) difference, we need a much bigger
        // collection and far more repetitions.
        int bigSize = 200_000;
        Set<Integer> bigHashSet = new HashSet<>();
        Set<Integer> bigTreeSet = new TreeSet<>();
        for (int i = 0; i < bigSize; i++) {
            bigHashSet.add(i);
            bigTreeSet.add(i);
        }
        int bigTarget = bigSize - 1;
        int bigRounds = 200_000;

        for (int i = 0; i < 5_000; i++) {
            bigHashSet.contains(bigTarget);
            bigTreeSet.contains(bigTarget);
        }

        long bigHashSetStart = System.nanoTime();
        for (int i = 0; i < bigRounds; i++) bigHashSet.contains(bigTarget);
        long bigHashSetNanos = System.nanoTime() - bigHashSetStart;

        long bigTreeSetStart = System.nanoTime();
        for (int i = 0; i < bigRounds; i++) bigTreeSet.contains(bigTarget);
        long bigTreeSetNanos = System.nanoTime() - bigTreeSetStart;

        System.out.println();
        System.out.println("contains(), " + bigRounds + " times, a " + bigSize + "-element collection (larger scale, to see the O(1) vs. O(log n) difference):");
        System.out.println("  HashSet (O(1)):     " + (bigHashSetNanos / 1_000_000) + " ms");
        System.out.println("  TreeSet (O(log n)): " + (bigTreeSetNanos / 1_000_000) + " ms");
    }
}

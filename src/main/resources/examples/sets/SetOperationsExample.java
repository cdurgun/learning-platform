import java.util.HashSet;
import java.util.Set;
import java.util.TreeSet;

public class SetOperationsExample {
    public static void main(String[] args) {
        Set<Integer> a = new TreeSet<>(Set.of(1, 2, 3, 4, 5));
        Set<Integer> b = new TreeSet<>(Set.of(4, 5, 6, 7, 8));

        // Union: addAll()
        Set<Integer> union = new TreeSet<>(a);
        union.addAll(b);
        System.out.println("A ∪ B (union, addAll): " + union);

        // Intersection: retainAll()
        Set<Integer> intersection = new TreeSet<>(a);
        intersection.retainAll(b);
        System.out.println("A ∩ B (intersection, retainAll): " + intersection);

        // Difference: removeAll()
        Set<Integer> difference = new TreeSet<>(a);
        difference.removeAll(b);
        System.out.println("A - B (difference, removeAll): " + difference);

        // WATCH OUT: these methods modify the SET IN PLACE -- to preserve the
        // original, you need to work on a COPY first (as we did above).
        System.out.println("Original A is still unchanged: " + a);
        System.out.println("Original B is still unchanged: " + b);

        // Subset check
        Set<Integer> subset = new TreeSet<>(Set.of(4, 5));
        System.out.println("Is {4,5} a subset of A? " + a.containsAll(subset));
    }
}

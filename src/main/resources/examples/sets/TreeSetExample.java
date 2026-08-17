import java.util.Comparator;
import java.util.NavigableSet;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {
        Set<Integer> numbers = new TreeSet<>();
        for (int n : new int[]{50, 10, 40, 20, 30}) {
            numbers.add(n);
        }
        // Unlike HashSet, TreeSet ALWAYS keeps elements sorted -- regardless of
        // insertion order.
        System.out.println("TreeSet (natural order): " + numbers);

        NavigableSet<Integer> navigable = (NavigableSet<Integer>) numbers;
        System.out.println("first(): " + navigable.first());
        System.out.println("last(): " + navigable.last());
        System.out.println("higher(20) (smallest greater than 20): " + navigable.higher(20));
        System.out.println("lower(20) (largest less than 20): " + navigable.lower(20));
        System.out.println("ceiling(25) (smallest greater than or equal to 25): " + navigable.ceiling(25));
        System.out.println("floor(25) (largest less than or equal to 25): " + navigable.floor(25));

        SortedSet<Integer> headSet = navigable.headSet(30); // EXCLUDING 30, before it
        SortedSet<Integer> tailSet = navigable.tailSet(30); // INCLUDING 30, from it onward
        System.out.println("headSet(30): " + headSet);
        System.out.println("tailSet(30): " + tailSet);

        // Reverse ordering with a custom Comparator
        TreeSet<String> reversed = new TreeSet<>(Comparator.reverseOrder());
        reversed.add("apple");
        reversed.add("pear");
        reversed.add("kiwi");
        System.out.println("Reverse-alphabetical TreeSet: " + reversed);
    }
}

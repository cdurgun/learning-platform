import java.util.List;

public class PracticalMaxFinderExample {

    // Bounding by an INTERFACE alone (no class involved) is just as
    // common as bounding by a class -- here T is only required to be
    // Comparable to itself, which is enough for a general-purpose "find
    // the largest element" utility that works for String, Integer, or any
    // other Comparable type, not just numbers.
    static <T extends Comparable<T>> T max(List<T> items) {
        T largest = items.get(0);
        for (T item : items) {
            if (item.compareTo(largest) > 0) {
                largest = item;
            }
        }
        return largest;
    }

    public static void main(String[] args) {
        System.out.println(max(List.of("banana", "apple", "cherry"))); // T = String
        System.out.println(max(List.of(5, 1, 9, 3)));                   // T = Integer
    }
}

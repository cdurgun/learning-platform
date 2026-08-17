import java.util.Comparator;
import java.util.Map;
import java.util.NavigableMap;
import java.util.SortedMap;
import java.util.TreeMap;

public class TreeMapExample {
    public static void main(String[] args) {
        Map<Integer, String> scores = new TreeMap<>();
        scores.put(50, "fifty");
        scores.put(10, "ten");
        scores.put(40, "forty");
        scores.put(20, "twenty");
        scores.put(30, "thirty");

        // Unlike HashMap, TreeMap ALWAYS keeps its keys sorted -- regardless of
        // insertion order.
        System.out.println("TreeMap (natural key order): " + scores);

        NavigableMap<Integer, String> navigable = (NavigableMap<Integer, String>) scores;
        System.out.println("firstKey(): " + navigable.firstKey());
        System.out.println("lastKey(): " + navigable.lastKey());
        System.out.println("higherKey(20) (smallest key greater than 20): " + navigable.higherKey(20));
        System.out.println("lowerKey(20) (largest key less than 20): " + navigable.lowerKey(20));
        System.out.println("ceilingKey(25) (smallest key >= 25): " + navigable.ceilingKey(25));
        System.out.println("floorKey(25) (largest key <= 25): " + navigable.floorKey(25));

        SortedMap<Integer, String> headMap = navigable.headMap(30); // EXCLUDING key 30
        SortedMap<Integer, String> tailMap = navigable.tailMap(30); // INCLUDING key 30
        System.out.println("headMap(30): " + headMap);
        System.out.println("tailMap(30): " + tailMap);

        // A custom Comparator to sort keys in reverse
        Map<String, Integer> reversed = new TreeMap<>(Comparator.reverseOrder());
        reversed.put("apple", 1);
        reversed.put("pear", 2);
        reversed.put("kiwi", 3);
        System.out.println("Reverse-alphabetical TreeMap: " + reversed);
    }
}

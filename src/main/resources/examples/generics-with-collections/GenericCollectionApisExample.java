import java.util.List;
import java.util.Map;
import java.util.Set;

public class GenericCollectionApisExample {

    public static void main(String[] args) {
        // List<T>: an ordered, index-accessible sequence of one element type.
        List<String> names = List.of("Alice", "Bob", "Charlie");

        // Set<T>: an unordered collection of one element type, with no duplicates.
        Set<String> uniqueNames = Set.of("Alice", "Bob", "Alice"); // the duplicate collapses

        // Map<K, V>: an association from one key type to one value type.
        Map<String, Integer> ages = Map.of("Alice", 30, "Bob", 25);

        System.out.println("List: " + names);
        System.out.println("Set size: " + uniqueNames.size());
        System.out.println("Map: " + ages);

        // The exact same three interfaces -- List, Set, Map -- are generic
        // over ANY type; nothing here is specific to String or Integer.
        List<Integer> scores = List.of(90, 85, 78);
        Set<Boolean> flags = Set.of(true, false);
        System.out.println("Scores: " + scores);
        System.out.println("Flags: " + flags);
    }
}

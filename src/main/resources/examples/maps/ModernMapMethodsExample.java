import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ModernMapMethodsExample {
    public static void main(String[] args) {
        Map<String, Integer> ages = new HashMap<>(Map.of("Alice", 30, "Bob", 25));

        // getOrDefault(): read a value, or fall back to a default if the key is missing
        // -- no null check needed.
        System.out.println("getOrDefault(\"Alice\", 0): " + ages.getOrDefault("Alice", 0));
        System.out.println("getOrDefault(\"Charlie\", 0): " + ages.getOrDefault("Charlie", 0));

        // putIfAbsent(): only inserts if the key is not already present -- avoids
        // accidentally overwriting an existing value.
        ages.putIfAbsent("Alice", 99); // Alice already exists -- ignored
        ages.putIfAbsent("Charlie", 40); // Charlie is new -- inserted
        System.out.println("After putIfAbsent(): " + ages);

        // merge(): the idiomatic way to count occurrences -- if the key is missing,
        // start at the given value; if it exists, combine it with the given function.
        List<String> words = List.of("apple", "banana", "apple", "kiwi", "banana", "apple");
        Map<String, Integer> wordCounts = new HashMap<>();
        for (String word : words) {
            wordCounts.merge(word, 1, Integer::sum);
        }
        System.out.println("Word counts (merge()): " + wordCounts);

        // computeIfAbsent(): the idiomatic way to group elements -- if the key is
        // missing, create a fresh container (here, an empty list) and use it.
        List<String> names = List.of("Alice", "Amy", "Bob", "Ben", "Charlie");
        Map<Character, List<String>> byFirstLetter = new HashMap<>();
        for (String name : names) {
            byFirstLetter.computeIfAbsent(name.charAt(0), key -> new ArrayList<>()).add(name);
        }
        System.out.println("Grouped by first letter (computeIfAbsent()): " + byFirstLetter);

        // computeIfPresent(): only transforms a value if the key IS already present.
        ages.computeIfPresent("Bob", (key, value) -> value + 1);
        ages.computeIfPresent("Dave", (key, value) -> value + 1); // Dave doesn't exist -- no-op
        System.out.println("After computeIfPresent(\"Bob\", +1): " + ages);
    }
}

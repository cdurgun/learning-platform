import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

public class LinkedHashSetExample {
    public static void main(String[] args) {
        String[] input = {"mango", "apple", "kiwi", "grape", "apple", "mango"};

        Set<String> hashSet = new HashSet<>();
        Set<String> linkedHashSet = new LinkedHashSet<>();
        for (String fruit : input) {
            hashSet.add(fruit);
            linkedHashSet.add(fruit);
        }

        System.out.println("Insertion order:    " + String.join(", ", input));
        System.out.println("HashSet order:       " + hashSet);
        System.out.println("LinkedHashSet order: " + linkedHashSet);

        // LinkedHashSet preserves ALL of HashSet's behavior (deduplication, O(1)
        // contains/add) but also remembers insertion order by adding a doubly-linked
        // list on top -- at a small memory/performance cost.
        System.out.println("Did both remove duplicates? " + (hashSet.size() == linkedHashSet.size()));
    }
}

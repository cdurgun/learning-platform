import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class LinkedHashMapExample {
    public static void main(String[] args) {
        String[] keys = {"mango", "apple", "kiwi", "grape"};

        Map<String, Integer> hashMap = new HashMap<>();
        Map<String, Integer> linkedHashMap = new LinkedHashMap<>();
        for (int i = 0; i < keys.length; i++) {
            hashMap.put(keys[i], i);
            linkedHashMap.put(keys[i], i);
        }

        System.out.println("Insertion order:    " + String.join(", ", keys));
        System.out.println("HashMap order:       " + hashMap.keySet());
        System.out.println("LinkedHashMap order: " + linkedHashMap.keySet());

        // Just like LinkedHashSet, LinkedHashMap preserves ALL of HashMap's behavior
        // but additionally remembers insertion order -- useful whenever the order
        // entries were added in actually matters (for example, a simple LRU cache can
        // be built on top of LinkedHashMap's access-order mode).
    }
}

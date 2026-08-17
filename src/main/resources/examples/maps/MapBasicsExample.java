import java.util.HashMap;
import java.util.Map;

public class MapBasicsExample {
    public static void main(String[] args) {
        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 30);
        ages.put("Bob", 25);
        ages.put("Charlie", 35);
        ages.put("Alice", 31); // same key -- OVERWRITES the previous value

        System.out.println("Map: " + ages);
        System.out.println("Size: " + ages.size());
        System.out.println("get(\"Bob\"): " + ages.get("Bob"));
        System.out.println("get(\"Dave\") (missing key): " + ages.get("Dave")); // null, no exception
        System.out.println("containsKey(\"Charlie\")? " + ages.containsKey("Charlie"));
        System.out.println("containsValue(31)? " + ages.containsValue(31));

        ages.remove("Bob");
        System.out.println("After remove(\"Bob\"): " + ages);

        // The idiomatic way to iterate a Map: entrySet() gives you both the key and
        // the value in one step, per entry.
        for (Map.Entry<String, Integer> entry : ages.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }

        // keySet() and values() give you just the keys or just the values, when
        // that's all you need.
        System.out.println("Keys: " + ages.keySet());
        System.out.println("Values: " + ages.values());
    }
}

import java.util.AbstractMap;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class ImmutableMapExample {
    public static void main(String[] args) {
        // Map.of(): an unmodifiable map from scratch, up to 10 key-value pairs
        Map<String, Integer> immutable = Map.of("red", 1, "green", 2, "blue", 3);
        System.out.println("Map.of(): " + immutable);

        try {
            immutable.put("yellow", 4);
        } catch (UnsupportedOperationException e) {
            System.out.println("put() on a Map.of() result: " + e.getClass().getSimpleName());
        }

        // Map.ofEntries() + Map.entry(): the way to go beyond 10 pairs, or when
        // key-value pairs are built dynamically
        Map<String, Integer> viaEntries = Map.ofEntries(
                Map.entry("one", 1),
                Map.entry("two", 2),
                new AbstractMap.SimpleEntry<>("three", 3) // any Map.Entry implementation works
        );
        System.out.println("Map.ofEntries(): " + viaEntries);

        // Collections.unmodifiableMap(): an unmodifiable VIEW of an existing map --
        // NOT an independent copy.
        Map<String, Integer> mutable = new HashMap<>(Map.of("a", 1, "b", 2));
        Map<String, Integer> readOnlyView = Collections.unmodifiableMap(mutable);
        try {
            readOnlyView.put("c", 3);
        } catch (UnsupportedOperationException e) {
            System.out.println("put() on unmodifiableMap(): " + e.getClass().getSimpleName());
        }

        mutable.put("c", 3);
        System.out.println("The view changes when the original map changes: " + readOnlyView);

        // Map.copyOf(): an independent, immutable COPY
        Map<String, Integer> independentCopy = Map.copyOf(mutable);
        mutable.put("d", 4);
        System.out.println("Original map changed: " + mutable);
        System.out.println("Map.copyOf() copy was NOT affected: " + independentCopy);
    }
}

import java.util.HashMap;
import java.util.Map;

public class AutoboxingNullPointerExample {
    public static void main(String[] args) {
        // A wrapper field that was never set (or explicitly set to null) is
        // null, just like any other object reference.
        Integer maybeScore = null;

        // SURPRISE: using a null wrapper in an arithmetic expression triggers
        // AUTOUNBOXING (Java tries to call maybeScore.intValue() behind the
        // scenes) -- which throws a real NullPointerException, not silently 0.
        try {
            int total = maybeScore + 10;
            System.out.println("unreachable: " + total);
        } catch (NullPointerException e) {
            System.out.println("Caught NullPointerException unboxing a null Integer in '+'");
        }

        // The exact same trap shows up with Map.get(), which returns null for a
        // missing key -- assigning that null result to a primitive
        // auto-unboxes it and throws.
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 90);
        try {
            int bobScore = scores.get("Bob"); // "Bob" is not in the map -> null
            System.out.println("unreachable: " + bobScore);
        } catch (NullPointerException e) {
            System.out.println("Caught NullPointerException unboxing Map.get() for a missing key");
        }

        // The safe pattern: keep the result as a wrapper (Integer, not int) and
        // check for null BEFORE unboxing, or use getOrDefault().
        Integer bobScoreSafe = scores.get("Bob");
        if (bobScoreSafe != null) {
            System.out.println("unreachable");
        } else {
            System.out.println("Safe check: bobScoreSafe is null, avoided unboxing it");
        }
        int bobScoreWithDefault = scores.getOrDefault("Bob", 0);
        System.out.println("getOrDefault(\"Bob\", 0): " + bobScoreWithDefault);
    }
}

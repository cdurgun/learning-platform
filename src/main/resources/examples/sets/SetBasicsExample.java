import java.util.HashSet;
import java.util.Set;

public class SetBasicsExample {
    public static void main(String[] args) {
        Set<String> colors = new HashSet<>();
        colors.add("red");
        colors.add("green");
        colors.add("blue");
        boolean addedAgain = colors.add("red"); // already present -- not added

        System.out.println("Set: " + colors);
        System.out.println("Size (duplicate not counted): " + colors.size());
        System.out.println("Was 'red' added again (return value)? " + addedAgain);
        System.out.println("Contains 'blue'? " + colors.contains("blue"));

        colors.remove("green");
        System.out.println("After remove(green): " + colors);

        // Unlike List, HashSet does NOT offer index-based access -- there's no get(0) method.
        // Elements can only be reached by iterating or with contains().
        for (String color : colors) {
            System.out.println("iterating: " + color);
        }

        // HashSet does NOT preserve insertion order -- iteration order is based on the
        // elements' positions in the internal hash table, and that order isn't guaranteed.
        Set<Integer> numbers = new HashSet<>();
        for (int i = 10; i >= 1; i--) {
            numbers.add(i);
        }
        System.out.println("Added 10 down to 1 in REVERSE, HashSet iteration order: " + numbers);
    }
}

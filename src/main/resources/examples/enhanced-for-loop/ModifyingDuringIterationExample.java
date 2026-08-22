import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.List;

public class ModifyingDuringIterationExample {
    public static void main(String[] args) {
        // The loop variable is a COPY of each value -- reassigning it does
        // NOT change the underlying array. A common misconception.
        int[] numbers = {1, 2, 3};
        for (int n : numbers) {
            n = n * 10; // only changes the LOCAL copy, not numbers[]
        }
        System.out.println("Array after the loop (unchanged): " + numbers[0] + ", " + numbers[1] + ", " + numbers[2]);

        // Removing an element from a List WHILE iterating it with enhanced
        // for throws ConcurrentModificationException -- the loop detects
        // that the collection's structure changed underneath it.
        List<String> items = new ArrayList<>();
        items.add("remove-me");
        items.add("keep");
        items.add("keep");

        try {
            for (String item : items) {
                if (item.equals("remove-me")) {
                    items.remove(item);
                }
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName());
        }
    }
}

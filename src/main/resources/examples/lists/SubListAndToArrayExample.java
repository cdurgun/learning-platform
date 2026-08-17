import java.util.ArrayList;
import java.util.List;

public class SubListAndToArrayExample {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(List.of(0, 1, 2, 3, 4, 5, 6, 7, 8, 9));

        // subList(from, to): from inclusive, to exclusive -- NOT an independent copy, it's
        // a "view" of the original list.
        List<Integer> middle = numbers.subList(3, 6);
        System.out.println("subList(3, 6): " + middle);

        // Changes made through the subList also change the ORIGINAL list
        middle.set(0, 999);
        System.out.println("Original list after set(0, 999) via subList: " + numbers);

        middle.clear();
        System.out.println("Original list after clear() via subList: " + numbers);

        // toArray(): two ways to convert a List to an array
        List<String> letters = List.of("x", "y", "z");

        Object[] rawArray = letters.toArray();
        System.out.println("toArray() (Object[]): " + rawArray.length + " elements");

        String[] typedArray = letters.toArray(new String[0]);
        System.out.println("toArray(new String[0]) (String[]): " + String.join(", ", typedArray));

        // toArray(IntFunction) -- Java 11+, a type-safe array without specifying the size
        String[] typedArray2 = letters.toArray(String[]::new);
        System.out.println("toArray(String[]::new): " + String.join(", ", typedArray2));
    }
}

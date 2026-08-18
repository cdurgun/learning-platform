import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ArraysVsCollectionsExample {
    public static void main(String[] args) {
        String[] fruitsArray = {"apple", "banana", "cherry"};

        // Arrays.asList() does NOT copy -- it wraps the ORIGINAL array in a
        // fixed-size List VIEW. Writing through the list writes through to the
        // array, and vice versa.
        List<String> fruitsView = Arrays.asList(fruitsArray);
        System.out.println("View before: " + fruitsView);
        fruitsArray[0] = "avocado";
        System.out.println("View after modifying the array directly: " + fruitsView);

        // Because the view is backed by a FIXED-SIZE array, add()/remove() are
        // NOT supported -- only set() (replacing an existing index) is.
        try {
            fruitsView.add("date");
            System.out.println("unreachable");
        } catch (UnsupportedOperationException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName()
                    + " -- Arrays.asList() does not support add()/remove()");
        }

        // To get a REAL, independent, resizable list, wrap the view in a new
        // ArrayList.
        List<String> realList = new ArrayList<>(Arrays.asList(fruitsArray));
        realList.add("date");
        System.out.println("Independent ArrayList (add() works): " + realList);

        // The reverse conversion: List -> array, with toArray(new String[0]).
        String[] backToArray = realList.toArray(new String[0]);
        System.out.println("List.toArray(new String[0]): " + Arrays.toString(backToArray));

        System.out.println();
        System.out.println("Array: fixed size, can hold primitives, index access is the fastest option.");
        System.out.println("List (e.g. ArrayList): resizable, only reference types, richer API.");
    }
}

import java.util.Arrays;

public class ArraysUtilityExample {
    public static void main(String[] args) {
        int[] numbers = {5, 3, 8, 1, 9, 2};
        System.out.println("Original: " + Arrays.toString(numbers));

        // sort() sorts IN PLACE -- it doesn't return a new array.
        Arrays.sort(numbers);
        System.out.println("After Arrays.sort(): " + Arrays.toString(numbers));

        // binarySearch() requires a SORTED array -- O(log n) lookup.
        System.out.println("Arrays.binarySearch(numbers, 8): index " + Arrays.binarySearch(numbers, 8));

        // equals() compares CONTENT (element by element) -- this is the array
        // equivalent of the == vs equals() String lesson: == on two arrays
        // compares references, Arrays.equals() compares values.
        int[] copy = Arrays.copyOf(numbers, numbers.length);
        System.out.println("numbers == copy (reference): " + (numbers == copy));
        System.out.println("Arrays.equals(numbers, copy) (content): " + Arrays.equals(numbers, copy));

        // fill() sets every element to the same value.
        int[] filled = new int[4];
        Arrays.fill(filled, 7);
        System.out.println("Arrays.fill(new int[4], 7): " + Arrays.toString(filled));

        // copyOf() with a length LONGER than the original pads with default
        // values (0 for int); SHORTER truncates.
        int[] longer = Arrays.copyOf(numbers, 8);
        int[] shorter = Arrays.copyOf(numbers, 3);
        System.out.println("copyOf(numbers, 8) (padded with 0): " + Arrays.toString(longer));
        System.out.println("copyOf(numbers, 3) (truncated): " + Arrays.toString(shorter));

        // copyOfRange() extracts a sub-array (end index is EXCLUSIVE, just like
        // String.substring()).
        int[] range = Arrays.copyOfRange(numbers, 1, 4);
        System.out.println("copyOfRange(numbers, 1, 4): " + Arrays.toString(range));
    }
}

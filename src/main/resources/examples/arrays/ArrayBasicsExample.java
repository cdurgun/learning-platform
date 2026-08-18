import java.util.Arrays;

public class ArrayBasicsExample {
    public static void main(String[] args) {
        // A fixed-size array of 5 ints -- size is decided at creation and can
        // NEVER change afterward.
        int[] numbers = new int[5];
        System.out.println("Freshly created int[5]: " + Arrays.toString(numbers));
        System.out.println("(uninitialized elements default to 0 for numeric types)");

        // An array LITERAL -- size and content given at once.
        String[] fruits = {"apple", "banana", "cherry"};
        System.out.println("Array literal: " + Arrays.toString(fruits));
        System.out.println("(uninitialized elements of a reference-type array default to null)");

        // Index-based access -- O(1), reading or writing by position.
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[4] = 50;
        System.out.println("After setting a few indices: " + Arrays.toString(numbers));
        System.out.println("numbers[1]: " + numbers[1]);

        // .length is a FIELD, not a method (unlike String.length() or List.size()).
        System.out.println("fruits.length: " + fruits.length);

        // Arrays are OBJECTS in Java -- printing one directly (without Arrays.
        // toString()) does NOT show its contents, just a type + hashcode string.
        System.out.println("Printing the array directly (not useful!): " + numbers);

        // Going out of bounds throws a real runtime exception, it does NOT
        // silently return null/0 or wrap around.
        try {
            int oops = numbers[10];
            System.out.println("unreachable: " + oops);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName() + " -- " + e.getMessage());
        }
    }
}

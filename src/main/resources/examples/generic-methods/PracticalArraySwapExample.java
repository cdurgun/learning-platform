public class PracticalArraySwapExample {

    // A single, practical generic method that works on an array of ANY
    // reference type -- no casting, no duplicating this method once per
    // element type.
    static <T> void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    public static void main(String[] args) {
        String[] names = {"Alice", "Bob", "Charlie"};
        swap(names, 0, 2);
        System.out.println(String.join(", ", names));

        Integer[] numbers = {1, 2, 3};
        swap(numbers, 0, 1); // the exact same method, now working on Integer[]
        for (int n : numbers) {
            System.out.print(n + " ");
        }
    }
}

import java.util.List;

public class MultipleBoundsExample {

    // Multiple bounds are joined with "&": T must satisfy ALL of them at
    // once. At most one bound may be a class (and it must come first if
    // present); the rest must be interfaces. Here T must be both a Number
    // AND Comparable to itself, so the method can use doubleValue() from
    // Number and compareTo(...) from Comparable in the same method.
    static <T extends Number & Comparable<T>> T max(List<T> values) {
        T largest = values.get(0);
        for (T value : values) {
            if (value.compareTo(largest) > 0) {
                largest = value;
            }
        }
        return largest;
    }

    public static void main(String[] args) {
        System.out.println(max(List.of(3, 7, 2, 9, 4)));      // T = Integer
        System.out.println(max(List.of(1.5, 3.2, 0.8)));       // T = Double
    }
}

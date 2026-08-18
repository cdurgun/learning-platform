import java.util.ArrayList;
import java.util.List;

public class WrapperInCollectionsExample {
    public static void main(String[] args) {
        // Generics like List<T> only work with REFERENCE types -- `List<int>`
        // does not compile. Wrapper classes are what make it possible to put
        // numbers into a generic collection at all: `List<Integer>`.
        List<Integer> scores = new ArrayList<>();

        // Adding a primitive int autoboxes it into an Integer automatically.
        scores.add(90);
        scores.add(85);
        scores.add(77);
        System.out.println("scores: " + scores);

        // Reading it back out with the enhanced for-loop as `int` autounboxes
        // each element automatically.
        int total = 0;
        for (int score : scores) {
            total += score;
        }
        System.out.println("Sum via autounboxing in a for-each loop: " + total);

        // This is exactly why generic type erasure (see the "Reflection"
        // lesson) plus autoboxing (Java 5) together made collections like
        // List<Integer> practical -- before Java 5, you had to store Integer
        // objects explicitly and box/unbox by hand every time.
        List<Double> prices = new ArrayList<>();
        prices.add(19.99);
        prices.add(5.49);
        double totalPrice = 0.0;
        for (double price : prices) {
            totalPrice += price;
        }
        System.out.println("prices: " + prices + ", total: " + totalPrice);
    }
}

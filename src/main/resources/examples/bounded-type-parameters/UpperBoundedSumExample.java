import java.util.List;

public class UpperBoundedSumExample {

    // "T extends Number" is an UPPER BOUND: T can be Number itself or any
    // subclass of it (Integer, Double, Long, ...) -- nothing else is
    // allowed. In exchange, the compiler now knows every T value has every
    // method Number declares, like doubleValue().
    static <T extends Number> double sum(List<T> numbers) {
        double total = 0;
        for (T number : numbers) {
            total += number.doubleValue(); // only legal because of the bound
        }
        return total;
    }

    public static void main(String[] args) {
        System.out.println(sum(List.of(1, 2, 3)));       // T = Integer
        System.out.println(sum(List.of(1.5, 2.5)));       // T = Double

        // sum(List.of("a", "b")); // would NOT compile -- String isn't a Number
    }
}

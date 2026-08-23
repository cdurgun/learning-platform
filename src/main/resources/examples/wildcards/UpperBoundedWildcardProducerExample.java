import java.util.List;

public class UpperBoundedWildcardProducerExample {

    // List<? extends Number> accepts a List of Number OR any of its
    // subtypes -- List<Integer>, List<Double>, List<Number> itself, all
    // qualify. This method only ever READS from the list -- it PRODUCES
    // values for the caller -- which is exactly what "extends" is for.
    static double sum(List<? extends Number> numbers) {
        double total = 0;
        for (Number n : numbers) { // reading is always safe: every element IS a Number
            total += n.doubleValue();
        }
        return total;

        // numbers.add(42); // would NOT compile -- the compiler doesn't
        //     know the list's REAL type (it could be a List<Double>), so
        //     it can't verify an Integer is safe to insert.
    }

    public static void main(String[] args) {
        System.out.println(sum(List.of(1, 2, 3)));      // List<Integer>
        System.out.println(sum(List.of(1.5, 2.5)));      // List<Double>
        System.out.println(sum(List.of(1, 2.5, 3L)));     // List<Number>
    }
}

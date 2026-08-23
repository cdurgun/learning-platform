import java.util.List;

public class WildcardMotivationExample {

    // Generics are INVARIANT: even though Integer IS-A Number, List<Integer>
    // is NOT a List<Number>. A parameter typed List<Number> only accepts
    // exactly that -- a List<Number> -- nothing else, no matter how closely
    // related the element types are.
    static double sumNumbers(List<Number> numbers) {
        double total = 0;
        for (Number n : numbers) {
            total += n.doubleValue();
        }
        return total;
    }

    public static void main(String[] args) {
        List<Number> mixed = List.of(1, 2.5, 3L);
        System.out.println(sumNumbers(mixed)); // fine -- this really is a List<Number>

        List<Integer> integers = List.of(1, 2, 3);
        // System.out.println(sumNumbers(integers)); // would NOT compile --
        //     List<Integer> is not a List<Number>, even though every
        //     Integer is a Number. This is exactly the problem wildcards
        //     exist to solve.
    }
}

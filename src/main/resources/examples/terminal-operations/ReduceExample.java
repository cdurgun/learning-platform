import java.util.List;
import java.util.Optional;

// reduce() combines all elements into a SINGLE value, using a BinaryOperator that
// combines two values into one, applied repeatedly. Three overloads exist, differing in
// whether a starting value (identity) is given.
class ReduceExample {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5);

        // reduce(identity, accumulator): starts from `identity`, always returns a value
        // (never empty), even for an empty stream (it just returns the identity).
        int sum = numbers.stream().reduce(0, Integer::sum);
        System.out.println(sum);

        // reduce(accumulator) with no identity: since an empty stream would have no
        // value to return, this overload returns Optional<T> instead of T.
        Optional<Integer> product = numbers.stream().reduce((a, b) -> a * b);
        System.out.println(product.orElse(0));

        // Building a single String out of multiple strings -- reduce() isn't limited to
        // numbers, any associative combining operation works.
        List<String> words = List.of("Java", "Stream", "API");
        String joined = words.stream().reduce("", (a, b) -> a.isEmpty() ? b : a + " " + b);
        System.out.println(joined);
    }
}

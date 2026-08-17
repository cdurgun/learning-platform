import java.util.function.Function;

// Function<T, R>: a single method, apply(T) -> R -- represents a transformation from
// one type to another.
class FunctionExample {
    public static void main(String[] args) {
        Function<String, Integer> length = String::length;
        Function<Integer, Integer> square = n -> n * n;

        System.out.println(length.apply("hello"));

        // andThen(): run THIS function first, feed its result into the next one.
        Function<String, Integer> lengthThenSquare = length.andThen(square);
        System.out.println(lengthThenSquare.apply("hello"));

        // compose(): run the ARGUMENT first, feed its result into THIS one -- the
        // mirror image of andThen().
        Function<Integer, String> intToLabel = n -> "n=" + n;
        Function<Integer, Integer> labelThenLength = length.compose(intToLabel);
        System.out.println(labelThenLength.apply(5));
    }
}

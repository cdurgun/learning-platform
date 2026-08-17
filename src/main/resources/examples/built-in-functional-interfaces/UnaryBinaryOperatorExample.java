import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.UnaryOperator;

// UnaryOperator<T> extends Function<T, T> -- input and output are the SAME type.
// BinaryOperator<T> extends BiFunction<T, T, T> -- two inputs of the same type, one
// output of that same type. Both exist purely to make a signature more specific and
// self-documenting; Function<T, T> would compile just as well.
class UnaryBinaryOperatorExample {
    public static void main(String[] args) {
        UnaryOperator<String> shout = s -> s.toUpperCase() + "!";
        System.out.println(shout.apply("hi"));

        // A UnaryOperator IS-A Function -- this assignment compiles because of that.
        Function<String, String> asFunction = shout;
        System.out.println(asFunction.apply("hey"));

        BinaryOperator<Integer> max = (a, b) -> a > b ? a : b;
        System.out.println(max.apply(3, 9));

        // BinaryOperator.maxBy()/minBy() are static factory methods that build a
        // BinaryOperator FROM a Comparator -- a small but common convenience.
        BinaryOperator<String> longer = BinaryOperator.maxBy((a, b) -> a.length() - b.length());
        System.out.println(longer.apply("hi", "hello"));
    }
}

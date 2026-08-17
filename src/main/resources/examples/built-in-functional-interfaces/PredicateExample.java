import java.util.function.Predicate;

// Predicate<T>: a single method, test(T) -> boolean -- represents a yes/no condition
// about a value, without the caller needing to describe HOW to check it.
class PredicateExample {
    public static void main(String[] args) {
        Predicate<String> isBlank = String::isBlank;
        Predicate<String> isLong = s -> s.length() > 5;

        System.out.println(isBlank.test(""));
        System.out.println(isBlank.test("hello"));

        // negate(), and(), or() are default methods -- they combine predicates
        // without writing a new lambda from scratch.
        Predicate<String> isNotBlank = isBlank.negate();
        Predicate<String> isBlankOrLong = isBlank.or(isLong);
        Predicate<String> isNotBlankAndLong = isBlank.negate().and(isLong);

        System.out.println(isNotBlank.test("hi"));
        System.out.println(isBlankOrLong.test("hello world"));
        System.out.println(isNotBlankAndLong.test("hi"));
    }
}

import java.util.function.Predicate;

// Exactly one abstract method (SAM) — default/static methods don't count
// toward that limit, so a functional interface can still have plenty of them.
@FunctionalInterface
interface Validator<T> {
    boolean isValid(T value);

    default Validator<T> negate() {
        return value -> !isValid(value);
    }
}

class FunctionalInterfaceExample {
    public static void main(String[] args) {
        // A lambda IS an instance of the functional interface — no named
        // implementing class needed.
        Validator<String> notBlank = value -> value != null && !value.isBlank();

        System.out.println(notBlank.isValid("hello")); // true
        System.out.println(notBlank.isValid("   "));   // false
        System.out.println(notBlank.negate().isValid("   ")); // true

        // java.util.function.Predicate is the exact same shape (T -> boolean)
        // as our own Validator — in real code, prefer the JDK's built-in
        // functional interfaces over hand-rolled ones whenever they fit.
        Predicate<String> notBlankPredicate = value -> value != null && !value.isBlank();
        System.out.println(notBlankPredicate.test("hi")); // true
    }
}

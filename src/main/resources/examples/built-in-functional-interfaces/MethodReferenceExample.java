import java.util.function.BiFunction;
import java.util.function.Function;

// The three method reference forms that refer to an EXISTING method (the fourth,
// Class::new, refers to a constructor instead -- see ConstructorReferenceExample).
class MethodReferenceExample {
    public static void main(String[] args) {
        // Class::staticMethod -- refers to a static method; the functional
        // interface's parameter list maps directly onto the static method's own.
        Function<String, Integer> parse = Integer::parseInt;
        System.out.println(parse.apply("42"));

        // object::instanceMethod ("bound") -- refers to an instance method on a
        // SPECIFIC, already-existing object; that object is captured, just like a
        // lambda capturing a variable from its enclosing scope.
        String greeting = "Hello";
        Function<String, String> concatWithGreeting = greeting::concat;
        System.out.println(concatWithGreeting.apply(", world"));

        // Class::instanceMethod ("unbound") -- refers to an instance method with NO
        // specific receiver; the functional interface's FIRST parameter becomes the
        // receiver the method is called ON, the rest become the method's own arguments.
        BiFunction<String, String, Boolean> startsWith = String::startsWith;
        System.out.println(startsWith.apply("hello world", "hello"));
    }
}

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.BiFunction;

// The SAME lambda literal has no type of its own -- the compiler decides what it
// becomes purely from context (its "target type": a variable's declared type, a
// method parameter's type, or a return type). Two functional interfaces with the
// exact same shape (two Strings in, one int out) can both host this literal.
class TargetTypingExample {
    public static void main(String[] args) {
        // Target type: Comparator<String> -- int compare(String, String)
        Comparator<String> byLength = (a, b) -> a.length() - b.length();
        System.out.println(byLength.compare("hi", "hello"));

        // Target type: BiFunction<String, String, Integer> -- structurally identical
        // shape, a completely different interface, the exact same lambda syntax.
        BiFunction<String, String, Integer> lengthDiff = (a, b) -> a.length() - b.length();
        System.out.println(lengthDiff.apply("hi", "hello"));

        // Passing a lambda directly as a method argument -- the target type comes
        // from the parameter's declared type, List.sort(Comparator<? super E>).
        List<String> names = new ArrayList<>(List.of("Ahmet", "Al", "Ayse"));
        names.sort((a, b) -> a.length() - b.length());
        System.out.println(names);
    }
}

import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

// A lambda can read any local variable from its enclosing scope -- but ONLY if that
// variable is "effectively final": never reassigned after its first assignment, even
// if it's never explicitly marked `final`.
class EffectivelyFinalExample {
    public static void main(String[] args) {
        String prefix = "Order #"; // never reassigned -> effectively final, capturable

        Supplier<String> label = () -> prefix + "42";
        System.out.println(label.get());

        // The line below would NOT compile if uncommented -- reassigning "prefix"
        // anywhere after the lambda captures it makes it no longer effectively final:
        // prefix = "Ticket #";

        // A mutable object (not a local variable) sidesteps the restriction entirely
        // -- this is the usual escape hatch when a lambda genuinely needs to
        // accumulate state across multiple calls.
        List<String> collected = new ArrayList<>(); // the REFERENCE never changes
        Runnable addOne = () -> collected.add("item"); // mutating the LIST is fine
        addOne.run();
        addOne.run();
        System.out.println(collected);
    }
}

// A genuinely surprising, real Java behavior -- and exactly why "Best
// Practices" recommends never putting a return (or another throw) inside a
// finally block. If finally itself returns a value, that value SILENTLY
// REPLACES whatever the try or catch block was about to return -- and if
// finally throws, it SILENTLY REPLACES whatever exception was already
// propagating, discarding it completely.
public class FinallyOverridingReturnExample {
    public static void main(String[] args) {
        System.out.println("brokenDivide(10, 0) returned: " + brokenDivide(10, 0));
        // Prints -1, NOT the ArithmeticException you might expect --
        // finally's "return -1" swallowed the exception entirely. The
        // catch block never even got a chance to run its own return.
    }

    private static int brokenDivide(int a, int b) {
        try {
            return a / b;              // throws ArithmeticException when b == 0
        } catch (ArithmeticException e) {
            System.out.println("Caught: " + e.getMessage());
            return -1;
        } finally {
            // This return DISCARDS the catch block's "return -1" (in this
            // case, coincidentally the same value) -- but more importantly,
            // it would ALSO discard a genuinely uncaught, unrelated
            // exception from anywhere in the try/catch, silently, with no
            // trace of it ever happening. That's the real danger, not the
            // duplicate value here.
            return -1;
        }
    }
}

// Compare this to UncaughtExceptionExample from "Introduction to Exceptions" --
// same idea (dividing by zero), but this time wrapped in a try-catch block.
// The exception is still thrown, still created with the same class and
// message -- the only difference is that something now intercepts it BEFORE
// it reaches main() uncaught, so the program keeps running instead of
// terminating.
public class BasicTryCatchExample {
    public static void main(String[] args) {
        System.out.println("About to divide...");
        int result = safeDivide(10, 0);
        // Unlike UncaughtExceptionExample, this line DOES run -- the
        // exception was handled, so execution continues normally after the
        // try-catch block.
        System.out.println("Result: " + result);
        System.out.println("Program continues normally.");
    }

    private static int safeDivide(int a, int b) {
        try {
            return a / b;   // throws ArithmeticException when b == 0
        } catch (ArithmeticException e) {
            // "e" is the SAME kind of exception object described in
            // "Introduction to Exceptions" -- it has a message, a class, and
            // a stack trace. Here we just read its message.
            System.out.println("Caught it: " + e.getMessage());
            return 0;   // a sensible fallback value
        }
    }
}

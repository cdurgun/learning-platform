// finally runs in EVERY case -- whether the try block succeeds, throws an
// exception that gets caught, or (as the last call below shows) throws an
// exception that DOESN'T get caught at all. This is what makes finally the
// right place for cleanup code that must run no matter what happened.
public class FinallyAlwaysRunsExample {
    public static void main(String[] args) {
        System.out.println("--- Case 1: no exception ---");
        process(10, 2);

        System.out.println("--- Case 2: caught exception ---");
        process(10, 0);

        System.out.println("--- Case 3: uncaught exception ---");
        processWithoutCatch(10, 0);   // finally STILL runs, then the
                                      // exception propagates anyway (see
                                      // "Introduction to Exceptions")
    }

    private static void process(int a, int b) {
        try {
            System.out.println("Result: " + (a / b));
        } catch (ArithmeticException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {
            System.out.println("finally: cleanup runs either way");
        }
    }

    private static void processWithoutCatch(int a, int b) {
        try {
            System.out.println("Result: " + (a / b));
        } finally {
            // try WITHOUT a catch, paired only with finally, is completely
            // legal -- finally still runs, then the exception (having no
            // catch to stop it) continues propagating exactly as if there
            // were no try block at all.
            System.out.println("finally: cleanup runs even without a catch block");
        }
    }
}

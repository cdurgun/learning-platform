// No try/catch anywhere in this file on purpose -- this lesson is about what
// happens BEFORE you learn to handle an exception (see "Try-Catch and
// Finally" for that). When an exception is thrown and nothing along the way
// catches it, the JVM does three specific things, in order: (1) it stops
// running the current thread at the exact point the exception was thrown,
// (2) it prints the exception's class, message, and full stack trace to
// standard error, (3) it terminates that thread -- for a single-threaded
// program like this one, that means the whole program exits, with a
// non-zero exit code (run "echo $?" right after this program exits on
// Linux/macOS to see it -- conventionally 1 for an uncaught exception).
public class UncaughtExceptionExample {
    public static void main(String[] args) {
        System.out.println("About to divide...");
        int result = divide(10, 0);
        // This line NEVER runs -- the exception thrown inside divide(...)
        // aborts main() before control ever returns here.
        System.out.println("Result: " + result);
    }

    private static int divide(int a, int b) {
        return a / b;   // b == 0 here -- the JVM itself creates and throws an
                        // ArithmeticException, we never wrote "throw" ourselves
    }
}

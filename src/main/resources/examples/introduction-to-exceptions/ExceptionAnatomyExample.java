// Every exception object carries three things worth knowing about before we
// ever write a single try/catch (that's the next lesson): a MESSAGE (a
// human-readable description), a CAUSE (an optional reference to another
// Throwable that triggered this one -- covered fully in "Exception Handling
// Best Practices"), and a STACK TRACE (a snapshot of exactly which method
// calls were active when the exception was created).
//
// We haven't covered try/catch yet, so this example uses a completely
// different, genuinely real mechanism to inspect an exception object:
// Thread.setDefaultUncaughtExceptionHandler. The JVM calls this handler with
// the exact Throwable it's about to report, right before terminating the
// program -- a legitimate way to EXAMINE an exception's anatomy without
// handling it.
public class ExceptionAnatomyExample {
    public static void main(String[] args) {
        Thread.setDefaultUncaughtExceptionHandler((thread, exception) -> {
            System.out.println("Caught by the handler, not by our own code:");
            System.out.println("Class: " + exception.getClass().getName());
            System.out.println("Message: " + exception.getMessage());
            System.out.println("First stack trace line: " + exception.getStackTrace()[0]);
        });

        int[] scores = {90, 85, 78};
        // Deliberately out of bounds -- this creates an
        // ArrayIndexOutOfBoundsException object, throws it, nothing catches
        // it, and the handler above receives it right before the JVM exits.
        System.out.println(scores[5]);
    }
}

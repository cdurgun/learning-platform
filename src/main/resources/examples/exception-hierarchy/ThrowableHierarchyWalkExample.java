// Every exception you've seen so far -- ArithmeticException, NumberFormatException,
// ArrayIndexOutOfBoundsException, IllegalArgumentException -- is a REAL class,
// and every one of those classes extends SOMETHING, all the way up to a single
// shared root: Throwable. This example walks that chain using reflection
// (getSuperclass(), see the Reflection lesson for the full API) to print it
// out directly, instead of just describing it.
public class ThrowableHierarchyWalkExample {
    public static void main(String[] args) {
        printHierarchy(new NumberFormatException("example"));
        System.out.println();
        printHierarchy(new ArithmeticException("example"));
        System.out.println();
        printHierarchy(new StackOverflowError());
    }

    private static void printHierarchy(Throwable throwable) {
        System.out.println("Hierarchy for " + throwable.getClass().getSimpleName() + ":");
        Class<?> current = throwable.getClass();
        while (current != null) {
            System.out.println("  " + current.getName());
            current = current.getSuperclass();
        }
        // Output for NumberFormatException, for example:
        //   java.lang.NumberFormatException
        //   java.lang.IllegalArgumentException
        //   java.lang.RuntimeException
        //   java.lang.Exception
        //   java.lang.Throwable
        //   java.lang.Object
    }
}

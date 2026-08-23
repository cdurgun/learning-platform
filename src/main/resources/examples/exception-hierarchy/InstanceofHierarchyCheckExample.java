// instanceof asks "is this object a member of this branch of the hierarchy?"
// at runtime -- true for the exact class AND every ancestor. This is useful
// when a single catch block needs to react differently depending on how
// specific the caught exception actually is, without writing a separate
// catch clause for every possible subtype.
public class InstanceofHierarchyCheckExample {
    public static void main(String[] args) {
        describe(new NumberFormatException("example"));
        describe(new IllegalArgumentException("example"));
        describe(new ArithmeticException("example"));
        describe(new Exception("example"));
    }

    private static void describe(Exception exception) {
        // Checked broadest-relevant-to-narrowest is not required here since
        // each branch just prints a label -- but in real code, ordering
        // instanceof checks (or catch clauses) from MOST specific to LEAST
        // specific matters, or a broader check would shadow a narrower one.
        if (exception instanceof NumberFormatException) {
            System.out.println(exception.getClass().getSimpleName() + " -> is a NumberFormatException");
        } else if (exception instanceof IllegalArgumentException) {
            System.out.println(exception.getClass().getSimpleName() + " -> is an IllegalArgumentException, but not a NumberFormatException");
        } else if (exception instanceof RuntimeException) {
            System.out.println(exception.getClass().getSimpleName() + " -> is some other RuntimeException");
        } else {
            System.out.println(exception.getClass().getSimpleName() + " -> is not a RuntimeException at all");
        }

        // Every exception here also passes this check, since Exception sits
        // above all of them in the hierarchy -- instanceof against a common
        // ancestor is always true for every descendant.
        System.out.println("  instanceof Exception: " + (exception instanceof Exception));
    }
}

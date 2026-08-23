// StackOverflowError is a REAL, common Error every Java developer eventually
// sees -- not from broken hardware or a JVM bug, but from something as
// ordinary as a recursive method with no base case. It extends Error, NOT
// Exception (see ThrowableHierarchyWalkExample for what that chain actually
// looks like) -- a structural signal that this represents a problem with the
// RUNTIME ENVIRONMENT itself (the call stack ran out of space), not a
// recoverable application-level condition.
public class StackOverflowErrorExample {
    public static void main(String[] args) {
        try {
            recurseForever(0);
        } catch (StackOverflowError e) {
            // Technically legal -- Error extends Throwable, and any Throwable
            // CAN be caught. But see "Best Practices": catching an Error is
            // almost never the right response, because the JVM is often in a
            // degraded state by the time one is thrown (the stack was
            // already nearly exhausted). This catch exists here purely to
            // demonstrate that it's possible, not to recommend it.
            System.out.println("Caught: " + e.getClass().getName());
        }
    }

    private static void recurseForever(int depth) {
        // No base case, no termination condition -- every call adds another
        // frame to the call stack (see "Reading a Stack Trace: Propagation
        // Through the Call Chain" in "Introduction to Exceptions" for what a
        // stack frame is) until the JVM has nowhere left to put one.
        recurseForever(depth + 1);
    }
}

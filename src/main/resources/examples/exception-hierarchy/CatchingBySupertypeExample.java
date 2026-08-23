// A catch block doesn't have to name the exact exception type that was
// thrown -- it can name any TYPE IN ITS HIERARCHY, and it will still catch
// it, because a NumberFormatException genuinely IS-A RuntimeException (that's
// what "extends" means). This example throws three completely different
// concrete exception types and catches all of them with a SINGLE
// catch (RuntimeException e) block.
public class CatchingBySupertypeExample {
    public static void main(String[] args) {
        attempt(() -> Integer.parseInt("not-a-number"));
        attempt(() -> { int[] values = new int[2]; int x = values[5]; });
        attempt(() -> { int x = 10 / 0; });
    }

    private static void attempt(Runnable riskyOperation) {
        try {
            riskyOperation.run();
        } catch (RuntimeException e) {
            // Whichever concrete type was actually thrown, e.getClass()
            // reveals it -- the catch block itself only cares that it's
            // SOME RuntimeException.
            System.out.println("Caught " + e.getClass().getSimpleName()
                    + " via catch (RuntimeException e)");
        }
    }
}

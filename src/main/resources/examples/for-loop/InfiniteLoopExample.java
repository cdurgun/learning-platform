public class InfiniteLoopExample {
    public static void main(String[] args) {
        // Leaving out all three parts (for (;;)) creates a loop with no
        // built-in stopping condition -- it is intentionally infinite unless
        // something INSIDE the body breaks out of it.
        int attempts = 0;

        for (;;) {
            attempts++;
            System.out.println("Attempt " + attempts);

            if (attempts >= 3) {
                System.out.println("Condition met -- breaking out.");
                break;
            }
        }

        System.out.println("Done after " + attempts + " attempts.");

        // A common ACCIDENTAL infinite loop: forgetting the update step, or
        // writing an update that never makes the condition false. This is
        // shown as a comment, not run, because it would hang forever:
        //
        // for (int i = 0; i < 5; ) {
        //     System.out.println(i);
        //     // missing i++ -- the condition (i < 5) is NEVER updated
        // }
    }
}

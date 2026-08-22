public class BreakContinueInNestedLoopExample {
    public static void main(String[] args) {
        // An unlabeled break only exits the loop it's directly written
        // inside -- the INNER loop here. The outer loop is completely
        // unaffected and keeps running its remaining iterations.
        System.out.println("break in a nested loop:");
        for (int row = 1; row <= 3; row++) {
            System.out.println("Starting row " + row);
            for (int col = 1; col <= 5; col++) {
                if (col == 3) {
                    System.out.println("  breaking inner loop at col = " + col);
                    break;
                }
                System.out.println("  col = " + col);
            }
            System.out.println("Finished row " + row);
        }

        // Just like break, an unlabeled continue only affects the loop it's
        // directly written inside. It skips the rest of the current inner
        // iteration and moves on -- the outer loop's iteration count is
        // untouched.
        System.out.println("continue in a nested loop:");
        for (int row = 1; row <= 2; row++) {
            for (int col = 1; col <= 4; col++) {
                if (col % 2 == 0) {
                    continue;
                }
                System.out.println("row=" + row + ", col=" + col);
            }
        }
    }
}

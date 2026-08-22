public class LabeledBreakContinueExample {
    public static void main(String[] args) {
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };

        // A label (an identifier followed by ':') placed right before a loop
        // lets break/continue target THAT loop specifically, even from
        // inside a nested loop. Without the label, break/continue could only
        // ever affect the innermost loop they're written in.
        int target = 5;
        boolean found = false;

        searchLoop:
        for (int row = 0; row < matrix.length; row++) {
            for (int col = 0; col < matrix[row].length; col++) {
                if (matrix[row][col] == target) {
                    System.out.println("Found " + target + " at [" + row + "][" + col + "]");
                    found = true;
                    break searchLoop; // exits BOTH loops immediately
                }
            }
        }
        if (!found) {
            System.out.println(target + " not found");
        }

        // Labeled continue: skip straight to the outer loop's next
        // iteration as soon as any negative number is found in a row.
        int[][] withNegatives = {
            {1, 2, -3},
            {4, -5, 6},
            {7, 8, 9}
        };

        rowLoop:
        for (int row = 0; row < withNegatives.length; row++) {
            for (int col = 0; col < withNegatives[row].length; col++) {
                if (withNegatives[row][col] < 0) {
                    System.out.println("Row " + row + " has a negative value, skipping it");
                    continue rowLoop; // jumps straight to row + 1
                }
            }
            System.out.println("Row " + row + " is all non-negative");
        }
    }
}

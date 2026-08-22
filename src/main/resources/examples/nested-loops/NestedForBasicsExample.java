public class NestedForBasicsExample {
    public static void main(String[] args) {
        // The outer loop runs 3 times; for EACH of those, the inner loop runs
        // 3 full times -- so the body executes 3 * 3 = 9 times in total.
        int totalIterations = 0;

        for (int row = 1; row <= 3; row++) {
            for (int col = 1; col <= 3; col++) {
                System.out.print("(" + row + "," + col + ") ");
                totalIterations++;
            }
            System.out.println();
        }

        System.out.println("Total iterations: " + totalIterations);
    }
}

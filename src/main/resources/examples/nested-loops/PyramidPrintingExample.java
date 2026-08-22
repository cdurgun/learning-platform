public class PyramidPrintingExample {
    /**
     * Prints a pyramid of stars, centered with leading spaces.
     * For rows = 4:
     *    *
     *   ***
     *  *****
     * *******
     *
     * This is still just ONE level of nesting -- the "spaces" loop and the
     * "stars" loop each sit one level inside the outer row loop and run one
     * after another, not inside each other.
     */
    public static void main(String[] args) {
        int rows = 4;

        for (int i = 0; i < rows; i++) {
            // Row i needs (rows - i - 1) leading spaces...
            for (int j = 0; j < rows - i - 1; j++) {
                System.out.print(" ");
            }
            // ...followed by (2 * i + 1) stars.
            for (int k = 0; k < 2 * i + 1; k++) {
                System.out.print("*");
            }
            System.out.println();
        }
    }
}

import java.util.Arrays;

public class MultiDimensionalArrayExample {
    public static void main(String[] args) {
        // A "2D array" in Java is really an array OF arrays -- here, a
        // rectangular 3x3 grid.
        int[][] grid = {
                {1, 2, 3},
                {4, 5, 6},
                {7, 8, 9}
        };
        System.out.println("grid[1][2] (row 1, column 2): " + grid[1][2]);

        // Arrays.toString() does NOT recurse into nested arrays -- it just
        // prints each row's default "type@hashcode" string. Arrays.deepToString()
        // is the one that actually recurses.
        System.out.println("Arrays.toString(grid) (WRONG tool for nested arrays): " + Arrays.toString(grid));
        System.out.println("Arrays.deepToString(grid) (correct tool): " + Arrays.deepToString(grid));

        // Because each "row" is its own independent array object, rows don't
        // have to be the same length -- this is a "jagged" array.
        int[][] jagged = new int[3][];
        jagged[0] = new int[]{1};
        jagged[1] = new int[]{1, 2, 3};
        jagged[2] = new int[]{1, 2};
        System.out.println("Jagged array: " + Arrays.deepToString(jagged));
        for (int i = 0; i < jagged.length; i++) {
            System.out.println("  row " + i + " length: " + jagged[i].length);
        }

        // A 3D array works the same way, one more level of nesting.
        int[][][] cube = new int[2][2][2];
        cube[1][1][1] = 42;
        System.out.println("cube[1][1][1]: " + cube[1][1][1]);
        System.out.println("cube[0][0][0] (never set, still default 0): " + cube[0][0][0]);
    }
}

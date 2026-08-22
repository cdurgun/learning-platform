public class TwoDArrayExample {
    public static void main(String[] args) {
        // A 2D array is really an array of arrays -- matrix[row] is itself an
        // int[]. Nested loops are the natural way to visit every cell: the
        // outer loop walks the rows, the inner loop walks the columns of
        // whichever row we're currently on.
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };

        int sum = 0;
        for (int row = 0; row < matrix.length; row++) {
            for (int col = 0; col < matrix[row].length; col++) {
                System.out.print(matrix[row][col] + " ");
                sum += matrix[row][col];
            }
            System.out.println();
        }

        System.out.println("Sum of all elements: " + sum);
    }
}

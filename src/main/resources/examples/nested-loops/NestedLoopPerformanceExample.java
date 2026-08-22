public class NestedLoopPerformanceExample {
    public static void main(String[] args) {
        // Every extra level of nesting multiplies the work. One loop over n
        // elements is O(n). Nest a second loop of the same size inside it,
        // and the body now runs n * n times -- O(n^2). This example doesn't
        // measure wall-clock time (unreliable on a shared machine); instead
        // it counts actual operations to make the growth concrete.
        int[] sizes = {10, 100, 1000};

        for (int n : sizes) {
            long operations = 0;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    operations++;
                }
            }
            System.out.println("n = " + n + " -> " + operations + " operations (n^2 = " + ((long) n * n) + ")");
        }
    }
}

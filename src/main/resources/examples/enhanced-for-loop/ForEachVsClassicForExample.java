public class ForEachVsClassicForExample {
    public static void main(String[] args) {
        int[] numbers = {2, 4, 6, 8, 10};

        // Same result, two ways.
        System.out.println("Classic for (has an index, more to write):");
        int classicTotal = 0;
        for (int i = 0; i < numbers.length; i++) {
            classicTotal += numbers[i];
        }
        System.out.println("Total: " + classicTotal);

        System.out.println("Enhanced for (no index, less to write):");
        int enhancedTotal = 0;
        for (int number : numbers) {
            enhancedTotal += number;
        }
        System.out.println("Total: " + enhancedTotal);
    }
}

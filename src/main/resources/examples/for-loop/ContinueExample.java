public class ContinueExample {
    public static void main(String[] args) {
        System.out.println("Odd numbers from 1 to 10:");
        for (int i = 1; i <= 10; i++) {
            // continue skips the REST of this iteration's body and jumps
            // straight to the update step -- the loop keeps running, unlike
            // break which would exit it entirely.
            if (i % 2 == 0) {
                continue;
            }
            System.out.print(i + " ");
        }
        System.out.println();

        // A common real use: skipping invalid entries while summing valid ones.
        int[] scores = {85, -1, 92, -1, 78, 60};
        int sum = 0;
        int validCount = 0;

        for (int i = 0; i < scores.length; i++) {
            if (scores[i] < 0) {
                continue; // -1 marks a missing score -- skip it
            }
            sum += scores[i];
            validCount++;
        }

        System.out.println("Valid scores: " + validCount + ", average: " + (sum / validCount));
    }
}

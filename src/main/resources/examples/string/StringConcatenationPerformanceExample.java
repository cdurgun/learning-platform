public class StringConcatenationPerformanceExample {
    public static void main(String[] args) {
        int rounds = 30_000;

        // Warm-up -- run both paths a lot before measuring, so the JIT compiler has
        // already optimized both loops by the time we time them.
        for (int i = 0; i < 3_000; i++) {
            concatenateWithPlus(rounds / 10);
            concatenateWithStringBuilder(rounds / 10);
        }

        long plusStart = System.nanoTime();
        String plusResult = concatenateWithPlus(rounds);
        long plusNanos = System.nanoTime() - plusStart;

        long builderStart = System.nanoTime();
        String builderResult = concatenateWithStringBuilder(rounds);
        long builderNanos = System.nanoTime() - builderStart;

        System.out.println("Building a String out of " + rounds + " pieces in a loop:");
        System.out.println("  '+' operator in a loop: " + (plusNanos / 1_000_000) + " ms");
        System.out.println("  StringBuilder.append(): " + (builderNanos / 1_000_000) + " ms");
        System.out.println("Same final length? " + (plusResult.length() == builderResult.length()));
    }

    // Each `+=` on a String inside a loop creates a BRAND-NEW String object (since
    // String is immutable) -- for N iterations this is roughly O(n^2) total work,
    // because every intermediate result gets copied again.
    private static String concatenateWithPlus(int rounds) {
        String result = "";
        for (int i = 0; i < rounds; i++) {
            result += "x";
        }
        return result;
    }

    // StringBuilder keeps ONE mutable internal char array and grows it as needed
    // (amortized O(1) per append) -- this is the recommended way to build a String
    // piece by piece in a loop.
    private static String concatenateWithStringBuilder(int rounds) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < rounds; i++) {
            result.append("x");
        }
        return result.toString();
    }
}

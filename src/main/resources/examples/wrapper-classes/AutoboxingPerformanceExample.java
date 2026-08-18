public class AutoboxingPerformanceExample {
    public static void main(String[] args) {
        int rounds = 20_000_000;

        // Warm-up -- run both paths a lot before measuring.
        for (int i = 0; i < 2_000_000; i++) {
            sumWithPrimitive(1000);
            sumWithBoxedLong(1000);
        }

        long primitiveStart = System.nanoTime();
        long primitiveResult = sumWithPrimitive(rounds);
        long primitiveNanos = System.nanoTime() - primitiveStart;

        long boxedStart = System.nanoTime();
        long boxedResult = sumWithBoxedLong(rounds);
        long boxedNanos = System.nanoTime() - boxedStart;

        System.out.println("Summing " + rounds + " numbers in a loop:");
        System.out.println("  primitive long accumulator: " + (primitiveNanos / 1_000_000) + " ms");
        System.out.println("  boxed Long accumulator: " + (boxedNanos / 1_000_000) + " ms");
        System.out.println("Same result? " + (primitiveResult == boxedResult));
        System.out.println("(every += on a boxed Long unboxes it, adds, then autoboxes a NEW Long");
        System.out.println(" object right back -- a primitive long accumulator never allocates)");
    }

    private static long sumWithPrimitive(int rounds) {
        long total = 0; // a primitive -- no object allocation per iteration
        for (int i = 0; i < rounds; i++) {
            total += i;
        }
        return total;
    }

    private static long sumWithBoxedLong(int rounds) {
        Long total = 0L; // a wrapper -- every += autoboxes a brand-new Long
        for (int i = 0; i < rounds; i++) {
            total += i;
        }
        return total;
    }
}

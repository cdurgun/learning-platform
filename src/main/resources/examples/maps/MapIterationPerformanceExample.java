import java.util.HashMap;
import java.util.Map;

public class MapIterationPerformanceExample {
    public static void main(String[] args) {
        int size = 200_000;
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < size; i++) {
            map.put(i, i);
        }

        int rounds = 50;

        // Warm-up -- run both iteration styles a lot before measuring.
        for (int r = 0; r < rounds; r++) {
            long sum = 0;
            for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                sum += entry.getValue();
            }
            long sum2 = 0;
            for (Integer key : map.keySet()) {
                sum2 += map.get(key);
            }
        }

        long entrySetStart = System.nanoTime();
        for (int r = 0; r < rounds; r++) {
            long sum = 0;
            for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                sum += entry.getValue();
            }
        }
        long entrySetNanos = System.nanoTime() - entrySetStart;

        long keySetGetStart = System.nanoTime();
        for (int r = 0; r < rounds; r++) {
            long sum = 0;
            for (Integer key : map.keySet()) {
                sum += map.get(key); // a SECOND lookup for every key -- redundant
            }
        }
        long keySetGetNanos = System.nanoTime() - keySetGetStart;

        System.out.println("Summing all values, " + rounds + " times, a " + size + "-entry map:");
        System.out.println("  entrySet():        " + (entrySetNanos / 1_000_000) + " ms");
        System.out.println("  keySet() + get():  " + (keySetGetNanos / 1_000_000) + " ms");
    }
}

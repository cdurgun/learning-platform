import java.util.ArrayDeque;
import java.util.Deque;
import java.util.LinkedList;

public class ArrayDequeVsLinkedListPerformanceExample {
    public static void main(String[] args) {
        int rounds = 5_000_000;

        Deque<Integer> arrayDeque = new ArrayDeque<>();
        Deque<Integer> linkedList = new LinkedList<>();

        // Warm-up -- run both paths a lot before measuring.
        for (int i = 0; i < 500_000; i++) {
            arrayDeque.offer(i);
            arrayDeque.poll();
            linkedList.offer(i);
            linkedList.poll();
        }

        long arrayDequeStart = System.nanoTime();
        for (int i = 0; i < rounds; i++) {
            arrayDeque.offer(i);
            arrayDeque.poll();
        }
        long arrayDequeNanos = System.nanoTime() - arrayDequeStart;

        long linkedListStart = System.nanoTime();
        for (int i = 0; i < rounds; i++) {
            linkedList.offer(i);
            linkedList.poll();
        }
        long linkedListNanos = System.nanoTime() - linkedListStart;

        System.out.println("offer()+poll() pairs, " + rounds + " times:");
        System.out.println("  ArrayDeque: " + (arrayDequeNanos / 1_000_000) + " ms");
        System.out.println("  LinkedList: " + (linkedListNanos / 1_000_000) + " ms");
        System.out.println("(both are O(1) for these operations -- ArrayDeque wins mainly on constant");
        System.out.println(" factors: no per-element node objects, better memory locality)");
    }
}

import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Queue;

public class PriorityQueueExample {
    public static void main(String[] args) {
        Queue<Integer> pq = new PriorityQueue<>();
        for (int n : new int[]{50, 10, 40, 20, 30}) {
            pq.offer(n);
        }

        // SURPRISE: a PriorityQueue's toString()/iterator does NOT print elements in
        // sorted order -- it only guarantees that the HEAD (peek()) is the smallest.
        // The rest of the internal heap array can be in any order.
        System.out.println("PriorityQueue printed directly (NOT necessarily sorted!): " + pq);
        System.out.println("peek() (always the smallest): " + pq.peek());

        // The only way to actually get elements out in sorted order is to poll()
        // repeatedly.
        System.out.print("Polling one by one (this IS sorted): ");
        Queue<Integer> copy = new PriorityQueue<>(pq);
        while (!copy.isEmpty()) {
            System.out.print(copy.poll() + " ");
        }
        System.out.println();

        // A custom Comparator reverses the priority -- now the LARGEST is the head.
        Queue<Integer> maxHeap = new PriorityQueue<>(Comparator.reverseOrder());
        maxHeap.offer(50);
        maxHeap.offer(10);
        maxHeap.offer(40);
        System.out.println("Max-heap peek() (largest is now the head): " + maxHeap.peek());
    }
}

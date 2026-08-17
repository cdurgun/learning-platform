import java.util.ArrayDeque;
import java.util.Deque;

public class DequeExample {
    public static void main(String[] args) {
        Deque<String> deque = new ArrayDeque<>();

        // A Deque (double-ended queue) can insert and remove at BOTH ends.
        deque.addFirst("b");
        deque.addFirst("a"); // now the front
        deque.addLast("c");
        deque.addLast("d"); // now the back

        System.out.println("Deque: " + deque);
        System.out.println("peekFirst(): " + deque.peekFirst());
        System.out.println("peekLast(): " + deque.peekLast());

        System.out.println("removeFirst(): " + deque.removeFirst());
        System.out.println("removeLast(): " + deque.removeLast());
        System.out.println("Deque after removing both ends: " + deque);

        // Just like Queue, Deque also has an "offer" family that returns a boolean
        // instead of throwing (offerFirst/offerLast, pollFirst/pollLast).
        deque.offerFirst("x");
        deque.offerLast("y");
        System.out.println("After offerFirst(x)/offerLast(y): " + deque);
    }
}

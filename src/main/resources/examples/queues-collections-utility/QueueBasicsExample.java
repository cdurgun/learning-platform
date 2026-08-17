import java.util.LinkedList;
import java.util.NoSuchElementException;
import java.util.Queue;

public class QueueBasicsExample {
    public static void main(String[] args) {
        Queue<String> queue = new LinkedList<>();
        queue.offer("first");
        queue.offer("second");
        queue.offer("third");

        System.out.println("Queue: " + queue);
        System.out.println("peek() (look at the head, don't remove): " + queue.peek());
        System.out.println("poll() (remove and return the head): " + queue.poll());
        System.out.println("Queue after poll(): " + queue);

        // Queue has TWO parallel method families: one throws on failure, one returns
        // a special value (null or false). Draining the queue with poll() shows the
        // "special value" family:
        while (queue.poll() != null) {
            // draining
        }
        System.out.println("poll() on an empty queue: " + queue.poll()); // null, no exception
        System.out.println("peek() on an empty queue: " + queue.peek()); // null, no exception

        // The "throwing" family: add()/remove()/element() throw instead of returning
        // null/false on failure.
        try {
            queue.remove(); // empty queue -- throws
        } catch (NoSuchElementException e) {
            System.out.println("remove() on an empty queue: " + e.getClass().getSimpleName());
        }
        try {
            queue.element(); // empty queue -- throws
        } catch (NoSuchElementException e) {
            System.out.println("element() on an empty queue: " + e.getClass().getSimpleName());
        }
    }
}

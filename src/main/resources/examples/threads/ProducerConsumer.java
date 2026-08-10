import java.util.LinkedList;
import java.util.Queue;

class SharedQueue {
    private final Queue<Integer> queue = new LinkedList<>();
    private final int capacity;

    SharedQueue(int capacity) {
        this.capacity = capacity;
    }

    synchronized void put(int value) throws InterruptedException {
        while (queue.size() == capacity) {
            wait(); // queue is full -- wait for the consumer to make room
        }
        queue.add(value);
        System.out.println("produced: " + value);
        notifyAll(); // wake up any consumer waiting in take()
    }

    synchronized int take() throws InterruptedException {
        while (queue.isEmpty()) {
            wait(); // queue is empty -- wait for the producer to add something
        }
        int value = queue.poll();
        System.out.println("consumed: " + value);
        notifyAll(); // wake up any producer waiting in put()
        return value;
    }
}

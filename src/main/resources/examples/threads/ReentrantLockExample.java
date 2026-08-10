import java.util.concurrent.locks.ReentrantLock;

class LockedCounter {
    private int count = 0;
    private final ReentrantLock lock = new ReentrantLock();

    void increment() {
        lock.lock();
        try {
            count++;
        } finally {
            lock.unlock(); // MUST run even if the body throws
        }
    }

    int getCount() {
        return count;
    }
}

class ReentrantLockExample {
    public static void main(String[] args) throws InterruptedException {
        LockedCounter counter = new LockedCounter();

        Runnable incrementTask = () -> {
            for (int i = 0; i < 1000; i++) {
                counter.increment();
            }
        };

        Thread t1 = new Thread(incrementTask);
        Thread t2 = new Thread(incrementTask);
        t1.start();
        t2.start();
        t1.join();
        t2.join();

        System.out.println("Expected: 2000, Actual: " + counter.getCount()); // always 2000

        // tryLock() -- give up immediately instead of blocking forever
        ReentrantLock another = new ReentrantLock();
        another.lock();
        try {
            Thread attempt = new Thread(() -> {
                if (another.tryLock()) {
                    System.out.println("acquired the lock");
                    another.unlock();
                } else {
                    System.out.println("lock was busy, giving up instead of blocking");
                }
            });
            attempt.start();
            attempt.join();
        } finally {
            another.unlock();
        }
    }
}

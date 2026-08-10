class SafeCounter {
    private int count = 0;

    synchronized void increment() { // only one thread can be inside this method at a time
        count++;
    }

    int getCount() {
        return count;
    }
}

class SynchronizationExample {
    public static void main(String[] args) throws InterruptedException {
        SafeCounter counter = new SafeCounter();

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
    }
}

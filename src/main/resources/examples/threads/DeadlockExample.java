class DeadlockExample {
    static final Object lockA = new Object();
    static final Object lockB = new Object();

    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            synchronized (lockA) {
                System.out.println("Thread 1: locked A, waiting for B");
                sleepQuietly(50);
                synchronized (lockB) {
                    System.out.println("Thread 1: locked B too");
                }
            }
        });

        Thread t2 = new Thread(() -> {
            synchronized (lockB) {
                System.out.println("Thread 2: locked B, waiting for A");
                sleepQuietly(50);
                synchronized (lockA) {
                    System.out.println("Thread 2: locked A too");
                }
            }
        });

        // Daemon so the JVM can still exit after main() returns, even though
        // a real deadlock would leave these two threads stuck forever.
        t1.setDaemon(true);
        t2.setDaemon(true);
        t1.start();
        t2.start();

        // A watchdog so this demo doesn't hang forever when you run it --
        // in a real deadlock there is no such safety net.
        t1.join(2000);
        t2.join(2000);
        if (t1.isAlive() || t2.isAlive()) {
            System.out.println("DEADLOCK DETECTED: both threads are still stuck after 2 seconds");
        }
    }

    static void sleepQuietly(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

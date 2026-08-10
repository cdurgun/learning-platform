class VolatileExample {
    private static volatile boolean running = true;

    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> {
            long iterations = 0;
            while (running) { // without volatile, this might loop forever
                iterations++;
            }
            System.out.println("worker stopped after seeing running = false, iterations=" + iterations);
        });

        worker.start();
        Thread.sleep(100);
        running = false; // must be visible to the worker thread immediately
        worker.join();
        System.out.println("main confirmed worker stopped");
    }
}

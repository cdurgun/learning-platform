class ThreadLifecycleExample {
    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        System.out.println("Before start: " + worker.getState()); // NEW

        worker.start();
        Thread.sleep(50); // give the worker time to enter sleep()
        System.out.println("While sleeping: " + worker.getState()); // TIMED_WAITING

        worker.join(); // main waits here until worker finishes
        System.out.println("After join: " + worker.getState()); // TERMINATED
    }
}

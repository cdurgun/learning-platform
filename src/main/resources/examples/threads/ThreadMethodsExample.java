class ThreadMethodsExample {
    public static void main(String[] args) throws InterruptedException {
        Thread worker = new Thread(() -> {
            try {
                for (int i = 1; i <= 3; i++) {
                    System.out.println("working... " + i);
                    Thread.sleep(50);
                }
            } catch (InterruptedException e) {
                System.out.println("interrupted before finishing!");
                Thread.currentThread().interrupt(); // restore the interrupted status
            }
        });

        worker.start();
        worker.join(); // main blocks here until worker fully finishes
        System.out.println("worker is done, main continues");

        Thread another = new Thread(() -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                System.out.println("another was interrupted");
            }
        });
        another.start();
        another.interrupt(); // request cancellation while it's sleeping
        another.join();
    }
}

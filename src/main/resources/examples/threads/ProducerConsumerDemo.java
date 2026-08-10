class ProducerConsumerDemo {
    public static void main(String[] args) throws InterruptedException {
        SharedQueue queue = new SharedQueue(3); // small capacity to force waiting on both sides

        Thread producer = new Thread(() -> {
            try {
                for (int i = 1; i <= 6; i++) {
                    queue.put(i);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        Thread consumer = new Thread(() -> {
            try {
                for (int i = 1; i <= 6; i++) {
                    queue.take();
                    Thread.sleep(30); // consume a bit slower than it's produced
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        producer.start();
        consumer.start();
        producer.join();
        consumer.join();

        System.out.println("all 6 items produced and consumed");
    }
}

class MessageBox {
    private String message;
    private boolean hasMessage = false;

    synchronized void put(String message) throws InterruptedException {
        while (hasMessage) {
            wait(); // release the lock and sleep until notified
        }
        this.message = message;
        hasMessage = true;
        notifyAll(); // wake up any thread waiting in take()
    }

    synchronized String take() throws InterruptedException {
        while (!hasMessage) {
            wait();
        }
        hasMessage = false;
        notifyAll(); // wake up any thread waiting in put()
        return message;
    }
}

class WaitNotifyExample {
    public static void main(String[] args) throws InterruptedException {
        MessageBox box = new MessageBox();

        Thread producer = new Thread(() -> {
            try {
                box.put("hello from producer");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        Thread consumer = new Thread(() -> {
            try {
                System.out.println("consumer received: " + box.take());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        consumer.start();
        Thread.sleep(50); // let the consumer start waiting first
        producer.start();

        producer.join();
        consumer.join();
    }
}

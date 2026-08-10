class Task implements Runnable {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + ": running a task");
    }
}

class RunnableExample {
    public static void main(String[] args) throws InterruptedException {
        Task task = new Task();
        Thread thread = new Thread(task); // the Thread is GIVEN the work, it doesn't BE the work
        thread.start();
        thread.join();

        // Modern style: a lambda, since Runnable has exactly one abstract method
        Thread lambdaThread = new Thread(() ->
            System.out.println(Thread.currentThread().getName() + ": running a lambda task"));
        lambdaThread.start();
        lambdaThread.join();
    }
}

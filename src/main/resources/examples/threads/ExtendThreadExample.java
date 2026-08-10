class GreetingThread extends Thread {
    @Override
    public void run() {
        System.out.println(Thread.currentThread().getName() + ": Hello from a thread!");
    }
}

class ExtendThreadExample {
    public static void main(String[] args) {
        GreetingThread thread = new GreetingThread();
        thread.start(); // runs run() on a NEW thread, not on main

        System.out.println(Thread.currentThread().getName() + ": Hello from main!");
    }
}

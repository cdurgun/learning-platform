class BankAccountDemo {
    static void drainWithThreads(Runnable withdrawTask) throws InterruptedException {
        Thread t1 = new Thread(withdrawTask);
        Thread t2 = new Thread(withdrawTask);
        t1.start();
        t2.start();
        t1.join();
        t2.join();
    }

    public static void main(String[] args) throws InterruptedException {
        UnsafeBankAccount unsafe = new UnsafeBankAccount(1000);
        drainWithThreads(() -> {
            for (int i = 0; i < 1000; i++) {
                unsafe.withdraw(1);
            }
        });
        // Starting balance 1000, two threads each attempt 1000 withdrawals of 1.
        // A correct implementation stops exactly at 0 -- the check-then-act race
        // here often lets both threads slip past the check, driving it BELOW zero.
        System.out.println("Unsafe balance: " + unsafe.getBalance());

        SafeBankAccount safe = new SafeBankAccount(1000);
        drainWithThreads(() -> {
            for (int i = 0; i < 1000; i++) {
                safe.withdraw(1);
            }
        });
        System.out.println("Safe balance: " + safe.getBalance()); // always exactly 0
    }
}

class UnsafeBankAccount {
    private int balance;

    UnsafeBankAccount(int balance) {
        this.balance = balance;
    }

    void withdraw(int amount) {
        if (balance >= amount) { // check ...
            Thread.yield();      // widen the race window so the bug reliably shows up here
            balance -= amount;   // ... then act -- another thread can slip in between
        }
    }

    int getBalance() {
        return balance;
    }
}

class SafeBankAccount {
    private int balance;

    SafeBankAccount(int balance) {
        this.balance = balance;
    }

    synchronized void withdraw(int amount) {
        if (balance >= amount) { // check and act are now one atomic operation
            balance -= amount;
        }
    }

    synchronized int getBalance() {
        return balance;
    }
}

abstract class Account {
    protected String owner;
    protected double balance;

    // An abstract class CAN have a constructor -- you just can never call it
    // with `new` directly. It only ever runs as part of building a concrete
    // subclass instance, to initialize the shared state the subclass inherits.
    Account(String owner, double balance) {
        this.owner = owner;
        this.balance = balance;
        System.out.println("Account constructor running for " + owner);
    }

    abstract double interestRate();
}

class SavingsAccount extends Account {
    SavingsAccount(String owner, double balance) {
        super(owner, balance); // must be the first statement in the subclass constructor
        System.out.println("SavingsAccount constructor running");
    }

    @Override
    double interestRate() {
        return 0.05;
    }
}

class ConstructorExample {
    public static void main(String[] args) {
        SavingsAccount account = new SavingsAccount("Ada", 1000);
        // Output order proves Account's constructor runs FIRST:
        // Account constructor running for Ada
        // SavingsAccount constructor running
        System.out.println(account.interestRate()); // 0.05
    }
}

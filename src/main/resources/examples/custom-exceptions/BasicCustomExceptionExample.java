public class BasicCustomExceptionExample {

    // A custom checked exception: extends Exception (not RuntimeException),
    // so every caller of a method that throws it must catch it or declare
    // it with "throws" -- the same compiler-enforced contract you saw with
    // built-in checked exceptions like IOException.
    static class InsufficientFundsException extends Exception {
        InsufficientFundsException(String message) {
            super(message);
        }
    }

    public static void main(String[] args) {
        try {
            withdraw(100.0, 250.0);
        } catch (InsufficientFundsException e) {
            System.out.println("Withdrawal failed: " + e.getMessage());
        }
    }

    static void withdraw(double balance, double amount) throws InsufficientFundsException {
        if (amount > balance) {
            throw new InsufficientFundsException(
                    "cannot withdraw " + amount + ", balance is only " + balance);
        }
        System.out.println("withdrew " + amount);
    }
}

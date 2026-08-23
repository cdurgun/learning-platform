public class CustomExceptionWithContextExample {

    // A custom unchecked exception: extends RuntimeException, so no
    // "throws" declaration is required at call sites. It carries an EXTRA
    // field beyond the inherited message -- the invalid value itself --
    // giving a catch block structured data to act on, not just text.
    static class InvalidOrderQuantityException extends RuntimeException {
        private final int quantity;

        InvalidOrderQuantityException(int quantity) {
            super("order quantity must be positive, was " + quantity);
            this.quantity = quantity;
        }

        int getQuantity() {
            return quantity;
        }
    }

    public static void main(String[] args) {
        try {
            placeOrder(-3);
        } catch (InvalidOrderQuantityException e) {
            System.out.println(e.getMessage());
            System.out.println("rejected quantity was: " + e.getQuantity());
        }
    }

    static void placeOrder(int quantity) {
        if (quantity <= 0) {
            throw new InvalidOrderQuantityException(quantity);
        }
        System.out.println("order placed for " + quantity);
    }
}

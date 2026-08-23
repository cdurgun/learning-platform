public class FailFastValidationExample {

    public static void main(String[] args) {
        System.out.println(applyDiscount(100.0, 10));

        try {
            applyDiscount(100.0, -5);
        } catch (IllegalArgumentException e) {
            System.out.println("Rejected: " + e.getMessage());
        }
    }

    static double applyDiscount(double price, int percent) {
        // Fail fast: validate arguments first and throw immediately, before
        // any real work happens -- this keeps the rest of the method free of
        // defensive checks and makes the bad input's origin obvious.
        if (percent < 0 || percent > 100) {
            throw new IllegalArgumentException("percent must be between 0 and 100, was " + percent);
        }

        return price - (price * percent / 100);
    }
}

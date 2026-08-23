public class CustomExceptionHierarchyExample {

    // A small hierarchy of your own, built the same way Java's own
    // exception classes are: one shared base type, several specific
    // subclasses. Code that only cares about "some payment problem
    // happened" can catch the base type; code that needs to react
    // differently to each cause can catch the specific subclasses instead.
    static class PaymentException extends RuntimeException {
        PaymentException(String message) {
            super(message);
        }
    }

    static class CardDeclinedException extends PaymentException {
        CardDeclinedException(String message) {
            super(message);
        }
    }

    static class PaymentGatewayTimeoutException extends PaymentException {
        PaymentGatewayTimeoutException(String message) {
            super(message);
        }
    }

    public static void main(String[] args) {
        // Catching by the shared base type, exactly like catching by
        // RuntimeException in "Exception Hierarchy" -- both subclasses
        // match, without listing each one.
        for (String scenario : new String[] {"declined", "timeout"}) {
            try {
                charge(scenario);
            } catch (PaymentException e) {
                System.out.println("payment failed (" + e.getClass().getSimpleName() + "): " + e.getMessage());
            }
        }
    }

    static void charge(String scenario) {
        if (scenario.equals("declined")) {
            throw new CardDeclinedException("card was declined by the issuer");
        }
        throw new PaymentGatewayTimeoutException("gateway did not respond in time");
    }
}

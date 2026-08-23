public class OnlyCatchWhatYouCanHandleExample {

    public static void main(String[] args) {
        // The top of the call chain is where a retry decision actually
        // makes sense -- it's the only place with enough context (should
        // we ask the user again? give up? fall back to a default?) to
        // decide what "handling" the failure even means.
        try {
            System.out.println("price: " + readPriceWithRetry());
        } catch (IllegalStateException e) {
            System.out.println("giving up: " + e.getMessage());
        }
    }

    static double readPriceWithRetry() {
        int attempts = 0;
        while (attempts < 3) {
            attempts++;
            try {
                return parsePrice(attempts < 3 ? "bad-input" : "19.99");
            } catch (NumberFormatException e) {
                // This layer CAN meaningfully handle the failure -- it
                // knows how to retry, so it catches, reacts, and moves on
                // instead of letting the exception propagate needlessly.
                System.out.println("attempt " + attempts + " failed, retrying...");
            }
        }
        throw new IllegalStateException("could not read a valid price after 3 attempts");
    }

    static double parsePrice(String text) {
        // This method has no useful response to a malformed price -- it
        // isn't the one deciding whether to retry or give up, so it does
        // NOT catch NumberFormatException here. Catching it just to
        // immediately rethrow the same thing would add a try/catch that
        // does nothing.
        return Double.parseDouble(text);
    }
}

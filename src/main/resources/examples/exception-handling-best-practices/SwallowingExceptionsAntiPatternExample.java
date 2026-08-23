public class SwallowingExceptionsAntiPatternExample {

    public static void main(String[] args) {
        System.out.println("bad result:  " + parsePort_bad("not-a-number"));
        try {
            parsePort_good("not-a-number");
        } catch (IllegalArgumentException e) {
            System.out.println("good result: rejected with a clear reason -- " + e.getMessage());
        }
    }

    // BAD: an empty catch block swallows the exception entirely -- the
    // failure leaves no trace anywhere, and the caller gets a silently
    // wrong value (0) with no way to tell it apart from a genuinely
    // configured port 0.
    static int parsePort_bad(String text) {
        int port = 0;
        try {
            port = Integer.parseInt(text);
        } catch (NumberFormatException e) {
            // swallowed -- nothing here at all
        }
        return port;
    }

    // GOOD: if there's truly nothing useful this method can do about the
    // failure, don't catch it at all here -- let it propagate, or catch it
    // only to translate it into a clearer, more specific failure for this
    // method's own caller.
    static int parsePort_good(String text) {
        try {
            return Integer.parseInt(text);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("'" + text + "' is not a valid port number", e);
        }
    }
}

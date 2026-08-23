import java.io.IOException;

// A common, real pattern: catch a checked exception and re-throw it wrapped inside
// an unchecked one, when the surrounding method's signature can't (or shouldn't)
// declare `throws IOException` itself -- for example, because it overrides an
// interface method that doesn't declare it (see the next example in this lesson).
public class WrappingCheckedAsUncheckedExample {
    public static void main(String[] args) {
        loadRequiredSetting("missing");
    }

    // No `throws` clause needed here -- RuntimeException is unchecked, so this
    // compiles even though readSetting(...) itself can throw a checked exception.
    private static void loadRequiredSetting(String key) {
        try {
            readSetting(key);
        } catch (IOException e) {
            // The constructor's second argument is the ORIGINAL exception, passed
            // as the "cause" -- nothing about the checked exception's message or
            // stack trace is lost, it's just no longer something the caller is
            // FORCED to handle.
            throw new RuntimeException("failed to load required setting: " + key, e);
        }
    }

    private static String readSetting(String key) throws IOException {
        if (key.equals("missing")) {
            throw new IOException("setting not found: " + key);
        }
        return "30s";
    }
}

import java.io.IOException;

// A checked exception is anything that extends Exception but NOT RuntimeException
// (see "Exception Hierarchy" for that split). The compiler enforces a real contract
// around it: if a method can throw one, every caller must either catch it or declare
// it with `throws` in its own signature -- there is no way to call this method and
// silently ignore that possibility, the way you can with an unchecked exception.
public class CheckedExceptionHandlingExample {
    public static void main(String[] args) {
        try {
            System.out.println("Loaded: " + readSetting("timeout"));
            System.out.println("Loaded: " + readSetting("missing"));
        } catch (IOException e) {
            // Forced by the compiler -- removing this catch (or a `throws IOException`
            // on main) would not compile.
            System.out.println("Caught checked exception: " + e.getMessage());
        }
    }

    // IOException is used here purely as a familiar, real checked exception to
    // demonstrate the COMPILER'S enforcement -- no actual file I/O happens (see the
    // File Reading lesson for real IOException scenarios from disk access).
    private static String readSetting(String key) throws IOException {
        if (key.equals("missing")) {
            throw new IOException("setting not found: " + key);
        }
        return "30s";
    }
}

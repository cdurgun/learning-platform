public class RethrowingCaughtExceptionExample {

    public static void main(String[] args) {
        try {
            loadConfiguration("settings.cfg");
        } catch (IllegalStateException e) {
            System.out.println("Startup failed: " + e.getMessage());
        }
    }

    static void loadConfiguration(String path) {
        try {
            parse(path);
        } catch (NumberFormatException e) {
            // Rethrowing: catch a specific, low-level exception and throw a
            // different, higher-level one in its place -- the caller sees a
            // failure described in terms this method's contract, not in
            // terms of an internal detail (a malformed number) it never
            // promised to expose. The original is kept as the "cause" so
            // no diagnostic information is lost.
            throw new IllegalStateException("configuration file is corrupt: " + path, e);
        }
    }

    static void parse(String path) {
        Integer.parseInt("not-a-number");
    }
}

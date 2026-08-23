public class ThrowStatementBasicsExample {

    public static void main(String[] args) {
        try {
            reject();
        } catch (IllegalStateException e) {
            System.out.println("Caught: " + e.getMessage());
        }
    }

    static void reject() {
        // "throw" is a statement: it executes right now, immediately handing
        // a Throwable instance to the JVM. Execution of this method stops here.
        throw new IllegalStateException("this operation is not allowed right now");

        // Any code placed here would be UNREACHABLE and would not even compile
        // -- the compiler knows the throw above always transfers control away.
    }
}

// An unchecked exception is any RuntimeException (or subclass of it). The compiler
// places NO obligation on a caller to catch it or declare it -- this file compiles
// and runs perfectly fine with no try/catch anywhere and no `throws` on main, even
// though divide(...) can clearly fail.
public class UncheckedExceptionExample {
    public static void main(String[] args) {
        System.out.println("Before calling divide(...)");
        int result = divide(10, 0);
        System.out.println("This line never runs: " + result);
    }

    private static int divide(int a, int b) {
        return a / b; // throws ArithmeticException -- unchecked, no `throws` clause needed
    }
}

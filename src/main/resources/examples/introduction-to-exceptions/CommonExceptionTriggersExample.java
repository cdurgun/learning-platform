// A survey of exceptions that occur NATURALLY in everyday code, without
// anyone deliberately writing "throw" -- the JVM itself creates and throws
// these the moment it detects the problem. Only ONE of these can actually
// run and terminate the program per execution (nothing after an uncaught
// exception runs) -- main() calls divideByZero() below; comment it out and
// uncomment a different call to see each one in turn.
public class CommonExceptionTriggersExample {
    public static void main(String[] args) {
        divideByZero();
        // accessInvalidArrayIndex();
        // dereferenceNull();
        // parseInvalidNumber();
        // castToWrongType();
    }

    private static void divideByZero() {
        int result = 10 / 0;   // ArithmeticException: "/ by zero"
        System.out.println(result);
    }

    private static void accessInvalidArrayIndex() {
        int[] values = {1, 2, 3};
        System.out.println(values[3]);   // ArrayIndexOutOfBoundsException --
                                          // valid indices here are 0, 1, 2
    }

    private static void dereferenceNull() {
        String text = null;
        System.out.println(text.length());   // NullPointerException -- the
                                              // single most common exception
                                              // in real Java code
    }

    private static void parseInvalidNumber() {
        int quantity = Integer.parseInt("not-a-number");   // NumberFormatException --
                                                             // extremely common when
                                                             // parsing user/file input
        System.out.println(quantity);
    }

    private static void castToWrongType() {
        Object value = "a String, not an Integer";
        Integer number = (Integer) value;   // ClassCastException
        System.out.println(number);
    }
}

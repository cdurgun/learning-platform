// PROPAGATION: when a method doesn't handle an exception (again, we haven't
// covered how to yet -- see "Try-Catch and Finally"), the exception moves
// UP to whichever method called it, then to whichever method called THAT
// one, and so on, until either something handles it or it reaches main()
// and the program terminates (see UncaughtExceptionExample). This is called
// "unwinding the stack" -- each frame the exception passes through gets
// added to its stack trace, in order.
//
// Run this and read the stack trace top to bottom: the FIRST line is where
// the exception was actually created (validateQuantity), and each line
// after it is one more frame it propagated through on its way back to
// main() -- processOrder, then main itself. The stack trace is a direct,
// readable record of the call chain at the moment of failure.
public class PropagationThroughCallChainExample {
    public static void main(String[] args) {
        processOrder("Keyboard", -3);
    }

    private static void processOrder(String productName, int quantity) {
        System.out.println("Processing order for: " + productName);
        validateQuantity(quantity);   // the exception thrown here has to pass
                                       // THROUGH this method to reach main()
        System.out.println("Order processed.");   // never reached
    }

    private static void validateQuantity(int quantity) {
        if (quantity <= 0) {
            // We ARE writing "throw" here -- a brief, necessary preview.
            // "Throw and Throws" covers this keyword properly; here it's
            // only a vehicle to demonstrate propagation.
            throw new IllegalArgumentException("Quantity must be positive, got: " + quantity);
        }
    }
}

// A single try block can be followed by SEVERAL catch blocks -- Java checks
// them TOP TO BOTTOM and runs the FIRST one whose type matches the thrown
// exception, then skips every catch block after it. Only ONE catch block
// ever runs per exception, never more than one.
public class MultipleCatchBlocksExample {
    public static void main(String[] args) {
        parseAndDivide("100", "0");     // triggers the ArithmeticException catch
        parseAndDivide("abc", "5");     // triggers the NumberFormatException catch
        parseAndDivide("100", "5");     // triggers neither -- prints the result
    }

    private static void parseAndDivide(String numeratorText, String denominatorText) {
        try {
            int numerator = Integer.parseInt(numeratorText);
            int denominator = Integer.parseInt(denominatorText);
            System.out.println(numeratorText + " / " + denominatorText + " = " + (numerator / denominator));
        } catch (ArithmeticException e) {
            // Matches ONLY division-related failures (denominator == 0).
            System.out.println("Cannot divide: " + e.getMessage());
        } catch (NumberFormatException e) {
            // Matches ONLY invalid number text -- NOTE: this catch block
            // must come AFTER any catch for a SUPERCLASS of
            // NumberFormatException, or the compiler rejects it as
            // unreachable (see "Common Mistakes").
            System.out.println("Not a valid number: " + e.getMessage());
        }
    }
}

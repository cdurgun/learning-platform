// Multi-catch (Java 7+): when two or more DIFFERENT exception types need the
// EXACT SAME handling code, "|" lets one catch block handle all of them,
// instead of duplicating the same body in separate catch blocks (compare to
// MultipleCatchBlocksExample, where the two blocks needed genuinely
// DIFFERENT handling).
public class MultiCatchExample {
    public static void main(String[] args) {
        parseAndDivide("100", "0");     // ArithmeticException -- caught below
        parseAndDivide("abc", "5");     // NumberFormatException -- caught below, SAME handling
        parseAndDivide("100", "5");     // neither -- prints the result
    }

    private static void parseAndDivide(String numeratorText, String denominatorText) {
        try {
            int numerator = Integer.parseInt(numeratorText);
            int denominator = Integer.parseInt(denominatorText);
            System.out.println(numeratorText + " / " + denominatorText + " = " + (numerator / denominator));
        } catch (ArithmeticException | NumberFormatException e) {
            // Both exception types land here -- "e" is typed as their
            // nearest common supertype for anything they share (in this
            // case, RuntimeException -- see "Exception Hierarchy" for what
            // that means precisely). The two types in a multi-catch can
            // NEVER be one a subclass of the other -- the compiler rejects
            // that as redundant.
            System.out.println("Could not complete the calculation: " + e.getMessage());
        }
    }
}

public class WrapperUtilityMethodsExample {
    public static void main(String[] args) {
        // Parsing text into numbers -- each numeric wrapper has a parseXxx()
        // static method.
        System.out.println("Integer.parseInt(\"123\"): " + Integer.parseInt("123"));
        System.out.println("Double.parseDouble(\"3.14\"): " + Double.parseDouble("3.14"));

        // A malformed number throws NumberFormatException -- a real, checked
        // failure, not a silent 0.
        try {
            Integer.parseInt("not-a-number");
        } catch (NumberFormatException e) {
            System.out.println("Caught NumberFormatException parsing \"not-a-number\"");
        }

        // compare() and compareTo() give ordering without boxing overhead --
        // useful before Comparator.comparingInt() existed, still handy today.
        System.out.println("Integer.compare(5, 10): " + Integer.compare(5, 10));
        System.out.println("Integer.compare(10, 5): " + Integer.compare(10, 5));
        System.out.println("Integer.compare(7, 7): " + Integer.compare(7, 7));

        // Base conversions.
        System.out.println("Integer.toBinaryString(42): " + Integer.toBinaryString(42));
        System.out.println("Integer.toHexString(255): " + Integer.toHexString(255));
        System.out.println("Integer.toOctalString(8): " + Integer.toOctalString(8));

        // Character has its own family of classification helpers.
        System.out.println("Character.isDigit('7'): " + Character.isDigit('7'));
        System.out.println("Character.isLetter('A'): " + Character.isLetter('A'));
        System.out.println("Character.isWhitespace(' '): " + Character.isWhitespace(' '));
        System.out.println("Character.toUpperCase('a'): " + Character.toUpperCase('a'));

        // sum()/max()/min() static helpers (added in Java 8) avoid manually
        // unboxing to compare/combine two values.
        System.out.println("Integer.sum(3, 4): " + Integer.sum(3, 4));
        System.out.println("Integer.max(3, 4): " + Integer.max(3, 4));
    }
}

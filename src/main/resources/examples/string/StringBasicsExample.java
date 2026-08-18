public class StringBasicsExample {
    public static void main(String[] args) {
        // A String literal -- Java interns literals in the "string pool" automatically.
        String greeting = "Hello, World!";

        // Basic inspection methods.
        System.out.println("Value: " + greeting);
        System.out.println("length(): " + greeting.length());
        System.out.println("charAt(7): " + greeting.charAt(7));
        System.out.println("isEmpty(): " + greeting.isEmpty());
        System.out.println("isBlank(): " + "   ".isBlank());

        // Strings are IMMUTABLE -- every "modifying" method returns a NEW String,
        // it never changes the original.
        String upper = greeting.toUpperCase();
        System.out.println("Original after toUpperCase(): " + greeting);
        System.out.println("New uppercase String: " + upper);
        System.out.println("Same object? " + (greeting == upper));

        // substring(), indexOf(), contains().
        System.out.println("substring(7): " + greeting.substring(7));
        System.out.println("substring(0, 5): " + greeting.substring(0, 5));
        System.out.println("indexOf(\"World\"): " + greeting.indexOf("World"));
        System.out.println("contains(\"World\"): " + greeting.contains("World"));

        // Concatenation with + creates yet another new String.
        String combined = greeting + " Nice to meet you.";
        System.out.println("Concatenated: " + combined);
    }
}

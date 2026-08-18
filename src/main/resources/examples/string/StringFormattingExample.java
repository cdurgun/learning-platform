public class StringFormattingExample {
    public static void main(String[] args) {
        String name = "Alice";
        int age = 30;
        double price = 19.999;

        // String.format() -- printf-style placeholders: %s (String), %d (int),
        // %.2f (double with 2 decimal places), etc.
        String formatted = String.format("%s is %d years old.", name, age);
        System.out.println(formatted);

        String priceLine = String.format("Price: $%.2f", price);
        System.out.println(priceLine);

        // Padding and alignment: %-10s left-aligns in a 10-char field, %10s
        // right-aligns.
        System.out.println(String.format("[%-10s][%10s]", "left", "right"));

        // formatted() (Java 15+) is the same thing as an instance method on the
        // format String itself -- purely a matter of style.
        String sameThing = "%s is %d years old.".formatted(name, age);
        System.out.println("Same result via formatted(): " + sameThing.equals(formatted));

        // Text blocks (Java 15+): a multi-line String literal delimited by """,
        // useful for embedded JSON/SQL/HTML without escaping every quote and
        // newline.
        String json = """
                {
                  "name": "%s",
                  "age": %d
                }""".formatted(name, age);
        System.out.println("Text block (formatted JSON):");
        System.out.println(json);

        // Text blocks strip "incidental" leading whitespace based on the least
        // indented line, and a trailing "\"\"\"" on its own line adds a final
        // newline -- both demonstrated by comparing lengths here.
        String withTrailingNewline = """
                line one
                line two
                """;
        String withoutTrailingNewline = """
                line one
                line two""";
        System.out.println("With trailing newline, length: " + withTrailingNewline.length());
        System.out.println("Without trailing newline, length: " + withoutTrailingNewline.length());
    }
}

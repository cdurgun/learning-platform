public class CatchOrderAndSpecificityExample {

    public static void main(String[] args) {
        process("42");
        process("not-a-number");
        process(null);
    }

    static void process(String text) {
        try {
            System.out.println("length: " + text.length() + ", parsed: " + Integer.parseInt(text));
        } catch (NumberFormatException e) {
            // Specific: this failure has one clear, targeted response.
            System.out.println("'" + text + "' is not a number");
        } catch (NullPointerException e) {
            // Also specific: a completely different failure, a different
            // targeted response -- listing it separately (instead of
            // folding it into a broad catch below) keeps each response
            // honest about what it's actually reacting to.
            System.out.println("no input was provided");
        } catch (RuntimeException e) {
            // A broad catch-all, placed LAST (the compiler would reject
            // it above the more specific catches, since it's a
            // supertype of both). Reserved for genuinely unanticipated
            // failures -- not a substitute for handling the two known
            // ones above.
            System.out.println("unexpected failure: " + e);
        }
    }
}

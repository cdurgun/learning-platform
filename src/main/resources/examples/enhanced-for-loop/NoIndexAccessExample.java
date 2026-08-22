public class NoIndexAccessExample {
    public static void main(String[] args) {
        String[] winners = {"Alice", "Bob", "Carol"};

        // Enhanced for gives you each VALUE, but never its position -- there
        // is no built-in way to print "1st place: Alice" from inside the loop.
        System.out.println("Without an index (position is missing):");
        for (String winner : winners) {
            System.out.println("Winner: " + winner);
        }

        // A manual counter alongside enhanced for works, but at that point a
        // classic for loop (see the "for Loop" lesson) is usually clearer --
        // you're already tracking an index by hand.
        System.out.println("With a manual counter:");
        int place = 1;
        for (String winner : winners) {
            System.out.println("Place " + place + ": " + winner);
            place++;
        }
    }
}

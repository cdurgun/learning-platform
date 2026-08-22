public class ForLoopBasicsExample {
    public static void main(String[] args) {
        // The three parts of a for loop, separated by semicolons:
        // initialization (runs once) ; condition (checked before each iteration) ; update (runs after each iteration)
        for (int i = 1; i <= 5; i++) {
            System.out.println("i = " + i);
        }

        // The loop variable declared in the header is scoped to the loop --
        // it does not exist after the loop ends.
        int total = 0;
        for (int i = 1; i <= 5; i++) {
            total += i;
        }
        System.out.println("Sum 1..5 = " + total);

        // Counting downward works the same way, with a decrementing update.
        for (int i = 5; i >= 1; i--) {
            System.out.print(i + " ");
        }
        System.out.println();
    }
}

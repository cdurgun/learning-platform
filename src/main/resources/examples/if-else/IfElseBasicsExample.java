public class IfElseBasicsExample {
    public static void main(String[] args) {
        int number = 7;

        if (number % 2 == 0) {
            System.out.println(number + " is even.");
        } else {
            System.out.println(number + " is odd.");
        }

        int age = 16;

        if (age >= 18) {
            System.out.println("Eligible to vote.");
        } else {
            System.out.println("Not eligible to vote yet.");
        }

        // A single-statement if/else WITHOUT braces -- legal, but risky.
        // See "Common Mistakes" for why braces should be used anyway.
        int score = 42;
        if (score > 50)
            System.out.println("Passed.");
        else
            System.out.println("Failed.");
    }
}

import java.util.Scanner;

public class NumberGuessingGameExample {
    public static void main(String[] args) {
        // In a real game this would be random (new Random().nextInt(100) + 1) --
        // fixed here so the walkthrough below is reproducible.
        int target = 42;
        Scanner scanner = new Scanner(System.in);
        int guess;
        int attempts = 0;

        System.out.println("Guess a number between 1 and 100.");

        do {
            System.out.print("Your guess: ");
            guess = scanner.nextInt();
            attempts++;

            if (guess < target) {
                System.out.println("Too low!");
            } else if (guess > target) {
                System.out.println("Too high!");
            } else {
                System.out.println("Correct! You guessed it in " + attempts + " attempts.");
            }
        } while (guess != target);

        scanner.close();
    }
}

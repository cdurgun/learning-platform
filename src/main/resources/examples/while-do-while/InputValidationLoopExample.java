import java.util.Scanner;

public class InputValidationLoopExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int age;

        // do-while is the natural fit here: you must ask AT LEAST once,
        // and keep re-asking only if the input turns out to be invalid.
        do {
            System.out.print("Enter your age (1-120): ");
            age = scanner.nextInt();

            if (age < 1 || age > 120) {
                System.out.println("Invalid age, try again.");
            }
        } while (age < 1 || age > 120);

        System.out.println("Valid age received: " + age);
        scanner.close();
    }
}

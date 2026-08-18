import java.util.InputMismatchException;
import java.util.NoSuchElementException;
import java.util.Scanner;

public class ScannerExceptionHandlingExample {
    public static void main(String[] args) {
        // Calling nextInt() when the next token is NOT a valid int throws a
        // real InputMismatchException -- it does not return 0 or null.
        Scanner scanner = new Scanner("42 not-a-number 100");
        System.out.println("First nextInt(): " + scanner.nextInt());

        try {
            int oops = scanner.nextInt();
            System.out.println("unreachable: " + oops);
        } catch (InputMismatchException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName() + " on the second token");
        }

        // IMPORTANT: after an InputMismatchException, the bad token is NOT
        // consumed -- it's still sitting there waiting to be read (as a plain
        // token via next()), which is exactly how you recover from it.
        System.out.println("Recovering with next(): " + scanner.next());
        System.out.println("Then nextInt() again: " + scanner.nextInt());
        scanner.close();

        // Calling next()/nextInt() when there are NO MORE tokens throws
        // NoSuchElementException -- the SAFE pattern is always checking
        // hasNext()/hasNextInt() first, exactly like the Queue lesson's
        // offer()/poll() vs add()/remove() distinction (checkable result vs.
        // exception for a normal "nothing left" condition).
        Scanner emptyScanner = new Scanner("");
        try {
            emptyScanner.next();
        } catch (NoSuchElementException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName() + " on an exhausted Scanner");
        }
        System.out.println("Safe check first -- hasNext(): " + emptyScanner.hasNext());
        emptyScanner.close();
    }
}

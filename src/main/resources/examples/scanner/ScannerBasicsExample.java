import java.util.Scanner;

public class ScannerBasicsExample {
    public static void main(String[] args) {
        // Scanner can read from ANY source that implements Readable, or from an
        // InputStream -- here we use a plain String as the source, but the same
        // API works identically for System.in (keyboard input) or a File.
        String input = "Alice 30 5.6 true";
        Scanner scanner = new Scanner(input);

        // By default, Scanner splits tokens on WHITESPACE and parses each token
        // according to the method you call: next() for a word, nextInt() for an
        // int, nextDouble() for a double, nextBoolean() for a boolean.
        String name = scanner.next();
        int age = scanner.nextInt();
        double height = scanner.nextDouble();
        boolean active = scanner.nextBoolean();

        System.out.println("name: " + name);
        System.out.println("age: " + age);
        System.out.println("height: " + height);
        System.out.println("active: " + active);

        scanner.close();

        // hasNext()/hasNextInt()/etc. let you check WITHOUT consuming -- the
        // safe way to loop through tokens of unknown count.
        Scanner tokenScanner = new Scanner("10 20 thirty 40");
        System.out.print("Looping with hasNextInt(): ");
        while (tokenScanner.hasNext()) {
            if (tokenScanner.hasNextInt()) {
                System.out.print(tokenScanner.nextInt() + " ");
            } else {
                System.out.print("[skipping non-int: " + tokenScanner.next() + "] ");
            }
        }
        System.out.println();
        tokenScanner.close();
    }
}

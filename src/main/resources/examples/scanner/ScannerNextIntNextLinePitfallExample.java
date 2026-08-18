import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class ScannerNextIntNextLinePitfallExample {
    public static void main(String[] args) {
        // Simulating typed console input: the user types "25", presses Enter,
        // then types "Alice" and presses Enter. This works identically with
        // `new Scanner(System.in)` reading real keyboard input.
        String simulatedTyping = "25\nAlice\n";
        InputStream fakeConsole = new ByteArrayInputStream(simulatedTyping.getBytes(StandardCharsets.UTF_8));

        System.out.println("--- THE BUG ---");
        Scanner buggyScanner = new Scanner(fakeConsole);
        int age = buggyScanner.nextInt();
        // SURPRISE: nextInt() only consumes the digits "25", NOT the newline
        // character right after them -- that leftover "\n" is still sitting in
        // the input. The very next nextLine() call reads up to that leftover
        // newline, which means it reads an EMPTY string instead of "Alice".
        String name = buggyScanner.nextLine();
        System.out.println("age: " + age);
        System.out.println("name (BUG -- empty, not \"Alice\"): [" + name + "]");
        buggyScanner.close();

        System.out.println();
        System.out.println("--- THE FIX ---");
        InputStream fixedConsole = new ByteArrayInputStream(simulatedTyping.getBytes(StandardCharsets.UTF_8));
        Scanner fixedScanner = new Scanner(fixedConsole);
        int age2 = fixedScanner.nextInt();
        fixedScanner.nextLine(); // consume the leftover newline left by nextInt()
        String name2 = fixedScanner.nextLine();
        System.out.println("age: " + age2);
        System.out.println("name (fixed): [" + name2 + "]");
        fixedScanner.close();
    }
}

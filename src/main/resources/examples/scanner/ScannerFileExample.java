import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class ScannerFileExample {
    public static void main(String[] args) throws IOException {
        // Create a small temp file to read from, so this example is
        // self-contained and reproducible.
        File tempFile = File.createTempFile("scanner-demo", ".txt");
        tempFile.deleteOnExit();
        try (FileWriter writer = new FileWriter(tempFile)) {
            writer.write("Alice,30\n");
            writer.write("Bob,25\n");
            writer.write("Charlie,35\n");
        }

        // Scanner can read directly from a File -- try-with-resources makes
        // sure the underlying file handle is closed even if something throws.
        try (Scanner fileScanner = new Scanner(tempFile)) {
            int lineNumber = 1;
            while (fileScanner.hasNextLine()) {
                String line = fileScanner.nextLine();
                System.out.println("line " + lineNumber + ": " + line);
                lineNumber++;
            }
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        }

        // A second pass, this time parsing each line's fields with a nested
        // Scanner and a comma delimiter.
        System.out.println();
        System.out.println("Parsed fields:");
        try (Scanner fileScanner = new Scanner(tempFile)) {
            while (fileScanner.hasNextLine()) {
                String line = fileScanner.nextLine();
                Scanner lineScanner = new Scanner(line);
                lineScanner.useDelimiter(",");
                String name = lineScanner.next();
                int age = lineScanner.nextInt();
                System.out.println("  " + name + " is " + age + " years old");
                lineScanner.close();
            }
        }

        tempFile.delete();
    }
}

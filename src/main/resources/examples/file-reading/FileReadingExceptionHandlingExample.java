import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;

public class FileReadingExceptionHandlingExample {
    public static void main(String[] args) {
        Path missing = Path.of("this-file-does-not-exist.txt");

        // SURPRISE: for the modern java.nio.file API (Files.readString(),
        // Files.readAllLines(), etc.), a missing file throws
        // NoSuchFileException, NOT the classic java.io FileNotFoundException.
        // The two are UNRELATED sibling exceptions (both extend IOException),
        // even though they mean the same thing in practice.
        try {
            Files.readString(missing);
        } catch (NoSuchFileException e) {
            System.out.println("Caught NoSuchFileException (the java.nio.file exception): " + e.getFile());
        } catch (IOException e) {
            System.out.println("unreachable for this case: " + e.getClass().getSimpleName());
        }

        // A multi-catch of BOTH exception types still compiles and is
        // harmless -- but for a Files.* call, the FileNotFoundException
        // branch will never actually fire, because Files.* never throws it.
        try {
            String content = Files.readString(missing);
            System.out.println("unreachable: " + content);
        } catch (FileNotFoundException e) {
            System.out.println("unreachable: FileNotFoundException never comes from Files.*");
        } catch (NoSuchFileException e) {
            System.out.println("This branch fires instead, for the SAME missing-file case");
        } catch (IOException e) {
            System.out.println("unreachable: " + e.getClass().getSimpleName());
        }

        // FileNotFoundException DOES come from the legacy java.io classes,
        // like the FileReader used in the "BufferedReader" section.
        try {
            new java.io.FileReader(missing.toFile());
        } catch (FileNotFoundException e) {
            System.out.println("Caught FileNotFoundException (the classic java.io exception, from FileReader)");
        }

        // The safe, general pattern: catch IOException as a fallback for
        // anything that isn't specifically handled above.
        String result = readSafely(missing);
        System.out.println("Safe helper result: " + result);
    }

    private static String readSafely(Path path) {
        try {
            return Files.readString(path);
        } catch (NoSuchFileException e) {
            return "File not found: " + path;
        } catch (IOException e) {
            return "Error reading file: " + e.getMessage();
        }
    }
}

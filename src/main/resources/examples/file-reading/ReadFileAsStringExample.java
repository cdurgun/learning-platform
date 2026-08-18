import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class ReadFileAsStringExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-whole-file.txt");
        Files.writeString(path, "Line A\nLine B\nLine C");

        // Files.readString() (Java 11+) reads the ENTIRE file into a single
        // String, newlines and all -- the simplest option when you need the
        // raw text as one value (for example, to pass to a JSON parser or
        // display as-is), rather than a List<String> of separate lines.
        String wholeFile = Files.readString(path);
        System.out.println("Whole file as one String:");
        System.out.println(wholeFile);
        System.out.println("Total length: " + wholeFile.length() + " characters");

        // Files.readAllLines() vs Files.readString(): readAllLines() strips
        // the line separators and gives you a List; readString() keeps them
        // and gives you one String. Pick based on whether you need to work
        // line by line or need the raw text.
        System.out.println();
        System.out.println("Contains newline characters? " + wholeFile.contains("\n"));

        Files.deleteIfExists(path);
    }
}

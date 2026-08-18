import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class PathAndFilesBasicsExample {
    public static void main(String[] args) throws IOException {
        // Path.of() builds a platform-independent file path -- it does NOT
        // touch the filesystem by itself, it's just a representation of a
        // location.
        Path path = Path.of("demo-input.txt");

        // Files.exists() actually checks the filesystem.
        System.out.println("Exists before creating it? " + Files.exists(path));

        // Files.writeString() creates the file (see the "File Writing" lesson
        // for the full picture) -- used here just to set up something to read.
        Files.writeString(path, "Hello World\nJava is great\nPractice makes perfect\nHello again\nJava rocks!");
        System.out.println("Exists after creating it? " + Files.exists(path));

        // Files.readAllLines() reads the ENTIRE file into memory as a
        // List<String>, one element per line -- the simplest way to read a
        // small-to-medium text file.
        List<String> lines = Files.readAllLines(path);
        System.out.println("Number of lines read: " + lines.size());
        lines.forEach(System.out::println);

        // Path carries useful metadata methods too.
        System.out.println("getFileName(): " + path.getFileName());
        System.out.println("toAbsolutePath(): " + path.toAbsolutePath());

        Files.deleteIfExists(path);
    }
}

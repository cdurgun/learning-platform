import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class AppendToFileExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-append.txt");
        Files.writeString(path, "First line");

        // By default Files.writeString() OVERWRITES -- passing
        // StandardOpenOption.APPEND changes that behavior to add onto the
        // END of the existing content instead of replacing it.
        Files.writeString(path, "\nSecond line", StandardOpenOption.APPEND);
        Files.writeString(path, "\nThird line", StandardOpenOption.APPEND);

        System.out.println("Final content after two appends:");
        System.out.println(Files.readString(path));

        // Trying to append to a file that doesn't exist yet fails, UNLESS you
        // also pass StandardOpenOption.CREATE -- APPEND alone assumes the file
        // is already there.
        Path newPath = Path.of("demo-append-new.txt");
        Files.writeString(newPath, "Created via CREATE + APPEND",
                StandardOpenOption.CREATE, StandardOpenOption.APPEND);
        System.out.println("New file via CREATE + APPEND: " + Files.readString(newPath));

        Files.deleteIfExists(path);
        Files.deleteIfExists(newPath);
    }
}

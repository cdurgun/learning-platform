import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class WriteStringExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-write.txt");

        // Files.writeString() is the simplest way to write text to a file --
        // it CREATES the file if it doesn't exist, or OVERWRITES it entirely
        // if it does. There is no accumulation here: calling it twice in a row
        // leaves only the SECOND call's content.
        Files.writeString(path, "Hello, File!");
        System.out.println("After first write: " + Files.readString(path));

        Files.writeString(path, "This REPLACES the previous content entirely.");
        System.out.println("After second write (overwritten): " + Files.readString(path));

        Files.deleteIfExists(path);
    }
}

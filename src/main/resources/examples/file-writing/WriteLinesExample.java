import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class WriteLinesExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-lines.txt");

        // Files.write(path, list) takes a List<String> and writes each
        // element as its own line -- the line-separator handling is done for
        // you, unlike manually joining with "\n".
        List<String> fruits = List.of("Apple", "Banana", "Cherry");
        Files.write(path, fruits);

        System.out.println("File content:");
        System.out.println(Files.readString(path));

        System.out.println("Read back as a List:");
        Files.readAllLines(path).forEach(line -> System.out.println("  " + line));

        Files.deleteIfExists(path);
    }
}

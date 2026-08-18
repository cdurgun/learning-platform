import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class SearchWordInFileExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-search.txt");
        Files.writeString(path,
                "Hello World\nJava is great\nPractice makes perfect\nHello again\nJava rocks!");

        // Combining Files.readAllLines() with the Stream API (see the "Stream
        // Fundamentals" lesson) makes searching a file for a keyword a
        // one-liner: filter the lines, keep only the ones that contain the
        // word.
        List<String> matches = Files.readAllLines(path).stream()
                .filter(line -> line.contains("Java"))
                .toList();

        System.out.println("Lines containing \"Java\":");
        matches.forEach(line -> System.out.println("  " + line));
        System.out.println("Match count: " + matches.size());

        // Case-insensitive search is a small variation -- lowercase both
        // sides before comparing.
        List<String> caseInsensitiveMatches = Files.readAllLines(path).stream()
                .filter(line -> line.toLowerCase().contains("hello"))
                .toList();
        System.out.println("Lines containing \"hello\" (case-insensitive): " + caseInsensitiveMatches);

        Files.deleteIfExists(path);
    }
}

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.stream.Stream;

public class FileReadingStreamAndCountExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-count.txt");
        Files.writeString(path, "one\ntwo\nthree\nfour\nfive");

        // Simplest way to count lines: read everything into a List, then ask
        // its size. Fine for small files, but it loads the WHOLE file into
        // memory just to get a count.
        long countViaReadAllLines = Files.readAllLines(path).size();
        System.out.println("Count via Files.readAllLines().size(): " + countViaReadAllLines);

        // Files.lines() returns a LAZY Stream<String> -- it doesn't load the
        // whole file at once, it reads as the stream is consumed. This scales
        // to files far larger than available memory.
        //
        // CRITICAL: Files.lines() opens a real file handle under the hood, so
        // the Stream it returns is Closeable and MUST be used inside
        // try-with-resources -- forgetting to close it leaks a file handle,
        // exactly like forgetting to close a Scanner or BufferedReader.
        long countViaLines;
        try (Stream<String> lineStream = Files.lines(path)) {
            countViaLines = lineStream.count();
        }
        System.out.println("Count via Files.lines().count() (lazy, must be closed): " + countViaLines);

        Files.deleteIfExists(path);
    }
}

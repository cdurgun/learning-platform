import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class BufferedReaderExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-buffered.txt");
        Files.writeString(path, "line one\nline two\nline three");

        // BufferedReader is the classic java.io way to read a file line by
        // line -- it wraps a FileReader and buffers reads internally, which is
        // much faster than reading one character at a time.
        //
        // try-with-resources guarantees close() is called even if an
        // exception is thrown mid-read -- this matters because BufferedReader
        // holds a real file handle open until it's closed.
        try (BufferedReader reader = new BufferedReader(new FileReader(path.toFile()))) {
            String line;
            int lineNumber = 1;
            // readLine() returns null exactly once, when there's nothing left
            // to read -- that's the loop's natural termination condition.
            while ((line = reader.readLine()) != null) {
                System.out.println(lineNumber + ": " + line);
                lineNumber++;
            }
        }

        Files.deleteIfExists(path);
    }
}

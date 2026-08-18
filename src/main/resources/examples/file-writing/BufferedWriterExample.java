import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class BufferedWriterExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-buffered-write.txt");

        // BufferedWriter is the classic java.io counterpart to
        // BufferedReader -- it wraps a FileWriter and buffers writes
        // internally. write() does NOT add a line separator by itself;
        // newLine() does that explicitly (and uses the platform's correct
        // separator, "\n" on Linux/macOS, "\r\n" on Windows).
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(path.toFile()))) {
            writer.write("Line 1");
            writer.newLine();
            writer.write("Line 2");
            writer.newLine();
            writer.write("Line 3");
            // No trailing newLine() here -- the file ends right after "Line 3".
        }

        System.out.println("File content:");
        System.out.println(Files.readString(path));

        Files.deleteIfExists(path);
    }
}

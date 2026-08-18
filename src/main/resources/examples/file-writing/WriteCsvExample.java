import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class WriteCsvExample {
    public static void main(String[] args) throws IOException {
        Path path = Path.of("demo-data.csv");

        String[] headers = {"Name", "Age", "City"};
        String[][] rows = {
                {"Alice", "30", "London"},
                {"Bob", "25", "Paris"},
                {"Charlie", "35", "Tokyo"}
        };

        writeCsv(path, headers, rows);

        System.out.println("CSV file content:");
        System.out.println(Files.readString(path));

        Files.deleteIfExists(path);
    }

    private static void writeCsv(Path path, String[] headers, String[][] rows) throws IOException {
        // String.join(",", array) turns an array into a single comma-joined
        // line -- the same helper used for the header row and every data row.
        StringBuilder csv = new StringBuilder();
        csv.append(String.join(",", headers)).append('\n');
        for (String[] row : rows) {
            csv.append(String.join(",", row)).append('\n');
        }

        // Writing the fully-built content in ONE Files.writeString() call is
        // more efficient than writing line by line -- fewer individual I/O
        // operations against the filesystem.
        Files.writeString(path, csv.toString());
    }
}

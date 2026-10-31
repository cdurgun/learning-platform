import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

// Sandbox self-test: an example that uses files by relative name runs in a fresh, EMPTY,
// writable working directory (/tmp), cannot leave it with "..", and the compiled classes
// are not inside it. selftest runs it once per generate variant, in order, so a file one run
// leaves behind would be visible to the next.
class WorkdirProbe {
    public static void main(String[] args) throws Exception {
        List<String> problems = new ArrayList<>();
        Path cwd = Path.of("").toAbsolutePath();
        if (!cwd.equals(Path.of("/tmp"))) {
            problems.add("working directory is " + cwd);
        }
        try (Stream<Path> entries = Files.list(Path.of(""))) {
            List<Path> found = entries.toList();
            if (!found.isEmpty()) {
                problems.add("working directory not empty: " + found);
            }
        }
        if (cwd.startsWith(Path.of("/classes")) || Path.of("/classes").startsWith(cwd)) {
            problems.add("classes inside the working directory");
        }
        // Appends like AppendToFileExample's CREATE + APPEND: run in every variant, one after
        // the other, a file left behind by an earlier run would show up here as "x\nx\n".
        try {
            Path marker = Path.of("marker.txt");
            Files.writeString(marker, "x\n", StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            String content = Files.readString(marker);
            if (!content.equals("x\n")) {
                problems.add("marker.txt holds an earlier run's content: " + content.replace("\n", "\\n"));
            }
        } catch (Exception e) {
            problems.add("relative file not writable");
        }
        for (String escape : List.of("../escape.txt", "../../escape.txt", "../classes/escape.txt")) {
            try {
                Files.writeString(Path.of(escape), "x");
                problems.add("writable " + escape);
            } catch (Exception e) {
                // expected: only the working directory is writable
            }
        }
        System.out.println(problems.isEmpty() ? "workdir: ok" : "workdir: " + problems);
    }
}

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Comparator;

public class CopyAndDirectoryExample {
    public static void main(String[] args) throws IOException {
        // Files.createDirectories() creates a directory AND any missing
        // parent directories along the way (like "mkdir -p") -- it does
        // NOT fail if the directory already exists.
        Path baseDir = Files.createDirectories(Path.of("demo-output"));
        System.out.println("Created directory: " + baseDir.getFileName());

        Path original = baseDir.resolve("original.txt");
        Files.writeString(original, "Content to be copied.");

        Path copy = baseDir.resolve("copy.txt");
        // Files.copy() copies a file's content in one call -- but by default
        // it throws FileAlreadyExistsException if the destination already
        // exists. StandardCopyOption.REPLACE_EXISTING makes it overwrite
        // instead.
        Files.copy(original, copy, StandardCopyOption.REPLACE_EXISTING);
        System.out.println("Copied content: " + Files.readString(copy));

        // Copying again to the SAME destination without REPLACE_EXISTING
        // would throw -- demonstrating why the option matters.
        try {
            Files.copy(original, copy); // no REPLACE_EXISTING this time
            System.out.println("unreachable");
        } catch (java.nio.file.FileAlreadyExistsException e) {
            System.out.println("Caught FileAlreadyExistsException without REPLACE_EXISTING");
        }

        // Cleaning up an entire directory tree requires walking it and
        // deleting from the DEEPEST entries first -- you can't delete a
        // non-empty directory. Files.walk() + Comparator.reverseOrder()
        // (files/subdirectories before their parent) is the standard pattern
        // for this.
        try (var paths = Files.walk(baseDir)) {
            paths.sorted(Comparator.reverseOrder())
                    .forEach(p -> {
                        try {
                            Files.delete(p);
                        } catch (IOException e) {
                            System.out.println("Failed to delete: " + p);
                        }
                    });
        }
        System.out.println("Directory exists after cleanup? " + Files.exists(baseDir));
    }
}

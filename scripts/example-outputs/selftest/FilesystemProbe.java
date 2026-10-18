import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

// Sandbox self-test: only the small /tmp tmpfs is writable; the class directory is a
// read-only mount, and nothing from the host besides it is visible.
class FilesystemProbe {
    public static void main(String[] args) {
        List<String> problems = new ArrayList<>();
        for (String path : List.of("/classes/probe.txt", "/probe.txt", "/etc/probe.txt", "/opt/probe.txt")) {
            if (canWrite(path)) {
                problems.add("writable " + path);
            }
        }
        if (!canWrite("/tmp/probe.txt")) {
            problems.add("/tmp not writable");
        }
        for (String path : List.of("/Users", "/src", "/host", "/var/run/docker.sock")) {
            if (Files.exists(Path.of(path))) {
                problems.add("visible " + path);
            }
        }
        System.out.println(problems.isEmpty() ? "filesystem: ok" : "filesystem: " + problems);
    }

    static boolean canWrite(String path) {
        try {
            Files.writeString(Path.of(path), "x");
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

// Sandbox self-test: runs as nobody (65534), with no capabilities, no-new-privileges,
// and without any of the host's environment variables.
class IdentityProbe {
    public static void main(String[] args) throws Exception {
        List<String> problems = new ArrayList<>();
        String status = Files.readString(Path.of("/proc/self/status"));
        if (!status.matches("(?s).*\\nUid:\\s+65534\\s+65534\\s+65534\\s+65534\\n.*")) {
            problems.add("uid is not 65534");
        }
        if (!status.matches("(?s).*\\nCapEff:\\s+0000000000000000\\n.*")) {
            problems.add("effective capabilities present");
        }
        if (!status.matches("(?s).*\\nNoNewPrivs:\\s+1\\n.*")) {
            problems.add("no-new-privileges not set");
        }
        for (String key : List.of("USER", "SSH_AUTH_SOCK", "JAVA_TOOL_OPTIONS", "QUIZ_INGEST_API_KEY")) {
            if (System.getenv(key) != null) {
                problems.add("host env leaked: " + key);
            }
        }
        String home = System.getenv("HOME");
        if (home != null && home.startsWith("/Users")) {
            problems.add("host HOME leaked");
        }
        System.out.println(problems.isEmpty() ? "identity: ok" : "identity: " + problems);
    }
}

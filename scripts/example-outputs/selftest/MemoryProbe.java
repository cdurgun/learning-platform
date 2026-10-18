import java.util.ArrayList;
import java.util.List;

// Sandbox self-test: memory is bounded; this must fail with OutOfMemoryError.
class MemoryProbe {
    public static void main(String[] args) {
        List<long[]> hog = new ArrayList<>();
        while (true) {
            hog.add(new long[1_000_000]);
        }
    }
}

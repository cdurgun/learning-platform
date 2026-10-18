// Sandbox self-test: output beyond the stdout cap must be cut off, not stored.
class FloodProbe {
    public static void main(String[] args) {
        String line = "x".repeat(99);
        for (int i = 0; i < 2_000; i++) {
            System.out.println(line);
        }
    }
}

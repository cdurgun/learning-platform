// Sandbox self-test: a program that never ends must be killed by the run timeout.
class InfiniteLoopProbe {
    public static void main(String[] args) {
        long counter = 0;
        while (true) {
            counter++;
        }
    }
}

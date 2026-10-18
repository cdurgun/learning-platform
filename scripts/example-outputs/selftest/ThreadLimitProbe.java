import java.util.concurrent.CountDownLatch;

// Sandbox self-test: --pids-limit caps how many threads/processes the program can start.
class ThreadLimitProbe {
    public static void main(String[] args) {
        CountDownLatch never = new CountDownLatch(1);
        int started = 0;
        try {
            for (int i = 0; i < 10_000; i++) {
                Thread thread = new Thread(() -> {
                    try {
                        never.await();
                    } catch (InterruptedException ignored) {
                    }
                });
                thread.setDaemon(true);
                thread.start();
                started++;
            }
        } catch (Throwable expected) {
        }
        System.out.println(started < 200 ? "threads: limited" : "threads: NOT limited (" + started + ")");
    }
}

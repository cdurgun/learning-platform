class DaemonThreadExample {
    public static void main(String[] args) throws InterruptedException {
        Thread backgroundLogger = new Thread(() -> {
            int i = 0;
            while (true) {
                System.out.println("background log #" + i++);
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    return;
                }
            }
        });

        backgroundLogger.setDaemon(true); // must be set BEFORE start()
        backgroundLogger.start();

        Thread.sleep(500); // main does a little "work"
        System.out.println("main is done -- JVM exits even though backgroundLogger never finished");
    }
}

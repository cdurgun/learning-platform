public class WhileVsDoWhileExample {
    public static void main(String[] args) {
        int x = 100;

        System.out.println("while (condition is false from the start):");
        int whileRuns = 0;
        while (x < 10) {
            whileRuns++;
        }
        System.out.println("Body ran " + whileRuns + " times.");

        System.out.println("do-while (same condition, false from the start):");
        int doWhileRuns = 0;
        do {
            doWhileRuns++;
        } while (x < 10);
        System.out.println("Body ran " + doWhileRuns + " times.");
    }
}

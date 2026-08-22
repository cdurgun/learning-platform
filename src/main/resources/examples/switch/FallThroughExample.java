public class FallThroughExample {
    public static void main(String[] args) {
        System.out.println("Without break (BUGGY):");
        printDayBuggy(2);

        System.out.println();
        System.out.println("With break (FIXED):");
        printDayFixed(2);
    }

    // Missing break statements -- once a case matches, execution keeps
    // running into every case BELOW it until a break (or the end) is hit.
    private static void printDayBuggy(int day) {
        switch (day) {
            case 1:
                System.out.println("Monday");
            case 2:
                System.out.println("Tuesday");
            case 3:
                System.out.println("Wednesday");
            default:
                System.out.println("Unknown");
        }
    }

    private static void printDayFixed(int day) {
        switch (day) {
            case 1:
                System.out.println("Monday");
                break;
            case 2:
                System.out.println("Tuesday");
                break;
            case 3:
                System.out.println("Wednesday");
                break;
            default:
                System.out.println("Unknown");
                break;
        }
    }
}

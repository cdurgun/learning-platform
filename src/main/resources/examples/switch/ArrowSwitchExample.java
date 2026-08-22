public class ArrowSwitchExample {
    public static void main(String[] args) {
        printDayType(3);
        printDayType(6);
        printDayType(7);
    }

    // The arrow (->) form never falls through -- each case runs ONLY its own
    // branch, no break needed. Multiple labels can share one branch.
    private static void printDayType(int day) {
        switch (day) {
            case 1, 2, 3, 4, 5 -> System.out.println(day + " is a weekday.");
            case 6, 7 -> System.out.println(day + " is a weekend day.");
            default -> System.out.println(day + " is not a valid day.");
        }
    }
}

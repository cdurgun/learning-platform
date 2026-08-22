public class LogicalOperatorsExample {
    public static void main(String[] args) {
        int age = 25;
        boolean hasLicense = true;

        System.out.println("Can drive: " + (age >= 18 && hasLicense));

        boolean isWeekend = false;
        boolean isHoliday = true;

        System.out.println("Day off: " + (isWeekend || isHoliday));
        System.out.println("Not a day off: " + !(isWeekend || isHoliday));

        // Short-circuit evaluation: && skips the right-hand side once the
        // left-hand side is already false; || skips it once the left-hand
        // side is already true.
        System.out.println("Short-circuit && demo:");
        System.out.println(checkFirst() && checkSecond());

        System.out.println("Short-circuit || demo:");
        System.out.println(checkThird() || checkFourth());
    }

    private static boolean checkFirst() {
        System.out.println("  checkFirst() called");
        return false;
    }

    private static boolean checkSecond() {
        System.out.println("  checkSecond() called -- should NOT print, short-circuited");
        return true;
    }

    private static boolean checkThird() {
        System.out.println("  checkThird() called");
        return true;
    }

    private static boolean checkFourth() {
        System.out.println("  checkFourth() called -- should NOT print, short-circuited");
        return false;
    }
}

import java.time.LocalDate;

class DateCalculationsExample {
    public static void main(String[] args) {
        LocalDate jan31 = LocalDate.of(2026, 1, 31);

        LocalDate result = jan31.plusMonths(1); // January 31 + 1 month
        System.out.println("Jan 31 + 1 month: " + result); // clamped -- 2026 is not a leap year

        LocalDate chained = jan31.plusYears(1).minusDays(5);
        System.out.println("Chained calculation: " + chained);
        System.out.println("Original still unchanged: " + jan31);
    }
}

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

class ChronoUnitExample {
    public static void main(String[] args) {
        LocalDate start = LocalDate.of(2024, 1, 10);
        LocalDate end = LocalDate.of(2026, 4, 20);

        long totalDays = ChronoUnit.DAYS.between(start, end);
        long totalMonths = ChronoUnit.MONTHS.between(start, end);
        long totalYears = ChronoUnit.YEARS.between(start, end);

        System.out.println("Total days: " + totalDays);
        System.out.println("Total months: " + totalMonths);
        System.out.println("Total years: " + totalYears);
    }
}

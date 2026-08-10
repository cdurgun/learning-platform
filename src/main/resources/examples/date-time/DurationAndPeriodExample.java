import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.Period;

class DurationAndPeriodExample {
    public static void main(String[] args) {
        Instant start = Instant.parse("2026-01-01T09:00:00Z");
        Instant end = Instant.parse("2026-01-01T17:30:00Z");

        Duration workDay = Duration.between(start, end);
        System.out.println("Duration: " + workDay);
        System.out.println("Hours: " + workDay.toHours());
        System.out.println("Minutes: " + workDay.toMinutes());

        LocalDate projectStart = LocalDate.of(2024, 1, 10);
        LocalDate projectEnd = LocalDate.of(2026, 4, 20);

        Period projectLength = Period.between(projectStart, projectEnd);
        System.out.println("Period: " + projectLength.getYears() + " years, "
            + projectLength.getMonths() + " months, " + projectLength.getDays() + " days");
    }
}

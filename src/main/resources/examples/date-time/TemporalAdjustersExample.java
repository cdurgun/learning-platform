import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;

class TemporalAdjustersExample {
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2026, 3, 15);
        System.out.println("Starting date: " + date + " (" + date.getDayOfWeek() + ")");

        LocalDate nextMonday = date.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        System.out.println("Next Monday: " + nextMonday);

        LocalDate lastDayOfMonth = date.with(TemporalAdjusters.lastDayOfMonth());
        System.out.println("Last day of the month: " + lastDayOfMonth);

        LocalDate firstDayOfYear = date.with(TemporalAdjusters.firstDayOfYear());
        System.out.println("First day of the year: " + firstDayOfYear);
    }
}

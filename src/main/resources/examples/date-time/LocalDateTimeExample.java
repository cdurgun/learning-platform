import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

class LocalDateTimeExample {
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2026, 3, 15);
        LocalTime time = LocalTime.of(14, 30);

        LocalDateTime combinedA = date.atTime(time);
        LocalDateTime combinedB = LocalDateTime.of(date, time);
        System.out.println("Same result either way? " + combinedA.equals(combinedB));

        System.out.println("Combined: " + combinedA);
        System.out.println("Back to date: " + combinedA.toLocalDate());
        System.out.println("Back to time: " + combinedA.toLocalTime());
    }
}

import java.time.LocalDate;

class LocalDateExample {
    public static void main(String[] args) {
        LocalDate today = LocalDate.now(); // varies depending on when you run this
        System.out.println("Today: " + today);

        LocalDate fixedDate = LocalDate.of(2026, 3, 15);
        System.out.println("Fixed date: " + fixedDate);

        LocalDate nextWeek = fixedDate.plusDays(7); // returns a NEW LocalDate, doesn't mutate fixedDate
        System.out.println("A week later: " + nextWeek);
        System.out.println("Original unchanged: " + fixedDate);

        System.out.println("Day of week: " + fixedDate.getDayOfWeek());
        System.out.println("Is 2026 a leap year? " + fixedDate.isLeapYear());
    }
}

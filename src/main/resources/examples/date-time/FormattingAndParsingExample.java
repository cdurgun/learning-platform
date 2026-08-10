import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

class FormattingAndParsingExample {
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2026, 3, 15);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String formatted = date.format(formatter);
        System.out.println("Formatted: " + formatted);

        LocalDate parsedBack = LocalDate.parse(formatted, formatter);
        System.out.println("Parsed back: " + parsedBack);
        System.out.println("Round-trip matches original? " + parsedBack.equals(date));

        try {
            LocalDate.parse("2026-13-45"); // invalid month and day
        } catch (DateTimeParseException e) {
            System.out.println("Caught expected parse failure: " + e.getMessage());
        }
    }
}

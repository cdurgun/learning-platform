import java.time.LocalDate;

class ComparingDatesExample {
    public static void main(String[] args) {
        LocalDate first = LocalDate.of(2026, 3, 15);
        LocalDate second = LocalDate.of(2026, 6, 1);

        System.out.println("first isBefore second? " + first.isBefore(second));
        System.out.println("first isAfter second? " + first.isAfter(second));
        System.out.println("compareTo: " + first.compareTo(second)); // negative -- first comes before second

        LocalDate sameAsFirst = LocalDate.of(2026, 3, 15);
        System.out.println("equals (value comparison): " + first.equals(sameAsFirst));
    }
}

import java.time.LocalTime;

class LocalTimeExample {
    public static void main(String[] args) {
        LocalTime now = LocalTime.now(); // varies depending on when you run this
        System.out.println("Now: " + now);

        LocalTime openingTime = LocalTime.of(9, 0); // seconds and nanos default to 0
        System.out.println("Opening time: " + openingTime);

        LocalTime closingTime = openingTime.plusHours(8);
        System.out.println("Closing time: " + closingTime);

        System.out.println("Closing hour: " + closingTime.getHour());
        System.out.println("Is opening time before noon? " + openingTime.isBefore(LocalTime.NOON));
    }
}

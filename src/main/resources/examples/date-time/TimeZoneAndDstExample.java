import java.time.ZoneId;
import java.time.ZonedDateTime;

class TimeZoneAndDstExample {
    public static void main(String[] args) {
        // Istanbul stopped observing DST in 2016 -- fixed at UTC+3 year round.
        ZonedDateTime istanbulWinter = ZonedDateTime.of(2026, 1, 15, 12, 0, 0, 0, ZoneId.of("Europe/Istanbul"));
        ZonedDateTime istanbulSummer = ZonedDateTime.of(2026, 7, 15, 12, 0, 0, 0, ZoneId.of("Europe/Istanbul"));
        System.out.println("Istanbul winter offset: " + istanbulWinter.getOffset());
        System.out.println("Istanbul summer offset: " + istanbulSummer.getOffset() + " (same -- no DST anymore)");

        // New York still observes DST -- the offset differs between winter and summer.
        ZonedDateTime newYorkWinter = ZonedDateTime.of(2026, 1, 15, 12, 0, 0, 0, ZoneId.of("America/New_York"));
        ZonedDateTime newYorkSummer = ZonedDateTime.of(2026, 7, 15, 12, 0, 0, 0, ZoneId.of("America/New_York"));
        System.out.println("New York winter offset: " + newYorkWinter.getOffset());
        System.out.println("New York summer offset: " + newYorkSummer.getOffset() + " (different!)");
    }
}

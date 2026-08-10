import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;

class ZonedDateTimeExample {
    public static void main(String[] args) {
        LocalDateTime local = LocalDateTime.of(2026, 7, 15, 15, 0);
        ZonedDateTime istanbul = local.atZone(ZoneId.of("Europe/Istanbul"));
        System.out.println("Istanbul: " + istanbul);

        // withZoneSameInstant -- the INSTANT stays the same, the local time changes
        ZonedDateTime newYorkSameInstant = istanbul.withZoneSameInstant(ZoneId.of("America/New_York"));
        System.out.println("Same instant in New York: " + newYorkSameInstant);

        // withZoneSameLocal -- the LOCAL time stays "15:00", the instant changes
        ZonedDateTime newYorkSameLocal = istanbul.withZoneSameLocal(ZoneId.of("America/New_York"));
        System.out.println("Same local time relabeled to New York (different instant): " + newYorkSameLocal);

        System.out.println("Istanbul and 'same instant' New York represent the same instant? "
            + istanbul.toInstant().equals(newYorkSameInstant.toInstant()));
        System.out.println("Istanbul and 'same local' New York represent the same instant? "
            + istanbul.toInstant().equals(newYorkSameLocal.toInstant()));
    }
}

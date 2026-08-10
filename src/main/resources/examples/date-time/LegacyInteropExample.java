import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;

class LegacyInteropExample {
    public static void main(String[] args) {
        Date legacyDate = new Date(1_700_000_000_000L); // old API, milliseconds since epoch

        Instant instant = legacyDate.toInstant(); // lossless -- Date is just an epoch timestamp underneath
        System.out.println("Converted to Instant: " + instant);

        ZonedDateTime inIstanbul = instant.atZone(ZoneId.of("Europe/Istanbul"));
        System.out.println("Viewed in Istanbul: " + inIstanbul);

        Date backToLegacy = Date.from(instant); // bridging back, for an old API that still needs a Date
        System.out.println("Round-trip matches original? " + backToLegacy.equals(legacyDate));
    }
}

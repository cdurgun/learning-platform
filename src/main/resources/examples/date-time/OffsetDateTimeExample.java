import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

class OffsetDateTimeExample {
    public static void main(String[] args) {
        LocalDateTime local = LocalDateTime.of(2026, 3, 15, 14, 30);

        OffsetDateTime withOffset = local.atOffset(ZoneOffset.of("+03:00"));
        System.out.println("With fixed offset: " + withOffset);

        // A ZoneOffset is just a fixed number -- it carries no DST transition rules,
        // unlike a ZoneId region such as "Europe/Istanbul".
        System.out.println("Offset: " + withOffset.getOffset());
    }
}

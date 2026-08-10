import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;

class MeetingScheduler {
    private final String title;
    private final Instant scheduledAt; // single source of truth -- an unambiguous instant

    MeetingScheduler(String title, Instant scheduledAt) {
        this.title = title;
        this.scheduledAt = scheduledAt;
    }

    ZonedDateTime viewIn(ZoneId zone) {
        return scheduledAt.atZone(zone);
    }

    String getTitle() {
        return title;
    }
}

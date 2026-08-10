import java.time.Duration;
import java.util.Date;

class EventDurationTrackerDemo {
    public static void main(String[] args) {
        // A modern record, created directly with Instant.
        EventDurationTracker modern = new EventDurationTracker(
            "Modern Conference",
            java.time.Instant.parse("2026-05-01T09:00:00Z"),
            java.time.Instant.parse("2026-05-01T17:00:00Z")
        );

        // A "legacy" record, as if it came from an old system using java.util.Date.
        Date legacyStart = new Date(1_700_000_000_000L);
        Date legacyEnd = new Date(1_700_010_800_000L);
        EventDurationTracker legacy = EventDurationTracker.fromLegacyDates("Legacy Workshop", legacyStart, legacyEnd);

        for (EventDurationTracker tracker : new EventDurationTracker[] { modern, legacy }) {
            Duration d = tracker.duration();
            System.out.println(tracker.getName() + ": " + d.toHours() + "h " + (d.toMinutes() % 60) + "m");
        }
    }
}

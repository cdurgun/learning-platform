import java.time.Duration;
import java.time.Instant;
import java.util.Date;

class EventDurationTracker {
    private final String name;
    private final Instant start;
    private final Instant end;

    EventDurationTracker(String name, Instant start, Instant end) {
        this.name = name;
        this.start = start;
        this.end = end;
    }

    static EventDurationTracker fromLegacyDates(String name, Date legacyStart, Date legacyEnd) {
        // Bridging old java.util.Date records into the modern API -- lossless,
        // because a Date is already just an epoch timestamp underneath.
        return new EventDurationTracker(name, legacyStart.toInstant(), legacyEnd.toInstant());
    }

    Duration duration() {
        return Duration.between(start, end);
    }

    String getName() {
        return name;
    }
}

import java.time.Instant;
import java.time.LocalDate;

class Event {
    private final String name;
    private final Instant createdAt; // absolute timestamp -- what Jackson/Hibernate map automatically
    private final LocalDate eventDate; // calendar date -- no time zone needed for "which day"

    Event(String name, Instant createdAt, LocalDate eventDate) {
        this.name = name;
        this.createdAt = createdAt;
        this.eventDate = eventDate;
    }

    @Override
    public String toString() {
        return name + " (created " + createdAt + ", scheduled for " + eventDate + ")";
    }
}

class EventExample {
    public static void main(String[] args) {
        Event event = new Event(
            "Java Meetup",
            Instant.parse("2026-03-01T10:15:30Z"),
            LocalDate.of(2026, 4, 12)
        );

        System.out.println(event);
        // In a real Spring Boot app, this exact class (with @Entity/@JsonFormat added)
        // would serialize createdAt as ISO-8601 JSON and map to a PostgreSQL timestamptz
        // column -- no special handling needed for the java.time types themselves.
    }
}

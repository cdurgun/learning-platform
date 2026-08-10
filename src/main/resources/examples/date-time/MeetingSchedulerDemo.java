import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;

class MeetingSchedulerDemo {
    public static void main(String[] args) {
        MeetingScheduler meeting = new MeetingScheduler(
            "Sprint Planning",
            Instant.parse("2026-07-15T12:00:00Z")
        );

        ZonedDateTime inIstanbul = meeting.viewIn(ZoneId.of("Europe/Istanbul"));
        ZonedDateTime inNewYork = meeting.viewIn(ZoneId.of("America/New_York"));
        ZonedDateTime inTokyo = meeting.viewIn(ZoneId.of("Asia/Tokyo"));

        System.out.println(meeting.getTitle() + " local times:");
        System.out.println("  Istanbul: " + inIstanbul);
        System.out.println("  New York: " + inNewYork);
        System.out.println("  Tokyo: " + inTokyo);

        // All three represent the exact same instant, just expressed differently.
        boolean sameInstant = inIstanbul.toInstant().equals(inNewYork.toInstant())
            && inNewYork.toInstant().equals(inTokyo.toInstant());
        System.out.println("Same instant everywhere? " + sameInstant);
    }
}

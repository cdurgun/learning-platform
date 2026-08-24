import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

// A cron expression describes a SCHEDULE (specific times/days), unlike
// fixedRate/fixedDelay, which describe an INTERVAL relative to the
// previous run -- reach for cron when the requirement is genuinely
// calendar-based ("every night at 2 AM," "every Monday morning"), not
// just "repeat every N minutes."
@Component
class DailyCleanupJob {

    // Spring's six-field cron format: second minute hour day-of-month month day-of-week.
    // "0 0 2 * * *" -- second 0, minute 0, hour 2, every day-of-month,
    // every month, every day-of-week -- runs once, every day, at 2:00:00 AM.
    @Scheduled(cron = "0 0 2 * * *")
    public void purgeExpiredSessions() {
        System.out.println("Purging expired sessions at 2 AM");
    }

    // "0 0 9 * * MON-FRI" -- 9:00:00 AM, but only Monday through Friday --
    // cron expressions can restrict to specific days the way a fixed
    // interval never could.
    @Scheduled(cron = "0 0 9 * * MON-FRI")
    public void sendWeekdayDigest() {
        System.out.println("Sending weekday digest at 9 AM");
    }
}

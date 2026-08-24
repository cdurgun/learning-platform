import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

// @EnableScheduling turns on Spring's scheduling infrastructure for the
// whole application, the same way @EnableAsync does for @Async.
@Component
class MetricsReporter {

    // fixedRate: a new run starts every 5 seconds, measured from the
    // START of the previous run -- if a run takes longer than the rate,
    // the next one starts as soon as the current one finishes (it does
    // NOT overlap by default), but runs can end up "catching up" back to
    // back with no gap between them.
    @Scheduled(fixedRate = 5000)
    public void reportMetrics() {
        System.out.println("Reporting metrics at " + System.currentTimeMillis());
    }

    // fixedDelay: a new run starts 10 seconds after the PREVIOUS run
    // actually FINISHED, not from when it started -- this guarantees a
    // real gap between runs regardless of how long each one takes.
    //
    // initialDelay: the scheduler waits 30 seconds after the application
    // starts before the very first run -- useful when a task depends on
    // other startup work (a cache warming up, a connection pool
    // initializing) finishing first.
    @Scheduled(initialDelay = 30000, fixedDelay = 10000)
    public void syncWithExternalSystem() {
        System.out.println("Syncing with external system at " + System.currentTimeMillis());
    }
}

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

// @EnableAsync turns on Spring's async proxying for the whole application
// -- without it, @Async is silently ignored and every method runs
// synchronously, on the calling thread, exactly as if the annotation
// weren't there at all.
@Configuration
@EnableAsync
class AsyncConfig {
}

@Service
class ReportService {

    // @Async makes THIS method run on a separate thread (from the
    // configured TaskExecutor) whenever it's called through Spring, and
    // dispatches the WHOLE method body -- including the sleep below --
    // there. Thread.sleep(...) here is only a stand-in for genuinely slow
    // work (a large query, rendering a PDF, a slow external call) -- never
    // use Thread.sleep in real application code; it's used here purely to
    // make the asynchronous timing visible.
    @Async
    public CompletableFuture<String> generateReport(String reportId) {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // By this line, the "slow work" is already done -- on the
        // separate thread @Async already dispatched this method to.
        // completedFuture(...) does NOT make anything asynchronous by
        // itself; it just packages a value Java already has into the
        // CompletableFuture shape this method's signature promises to
        // return.
        return CompletableFuture.completedFuture("Report " + reportId + " ready");
    }
}

// The caller's side of the same interaction -- what actually happens with
// the CompletableFuture generateReport(...) hands back.
class ReportRequestHandler {

    private final ReportService reportService;

    ReportRequestHandler(ReportService reportService) {
        this.reportService = reportService;
    }

    public String handle(String reportId) {
        // generateReport(...) returns IMMEDIATELY -- before the sleep,
        // before the report is actually ready -- because @Async already
        // sent the real work to another thread. "future" is NOT that
        // other thread; it's a placeholder object this thread can hold
        // onto right now, representing a result that will exist later.
        CompletableFuture<String> future = reportService.generateReport(reportId);

        System.out.println("Report generation started, request thread continues...");

        // thenAccept(...) registers a callback -- "when a result
        // eventually lands in this future, run this code with it" --
        // WITHOUT blocking this thread to wait for that moment.
        future.thenAccept(result -> System.out.println("Async result: " + result));

        return "Report " + reportId + " is being generated";
    }
}

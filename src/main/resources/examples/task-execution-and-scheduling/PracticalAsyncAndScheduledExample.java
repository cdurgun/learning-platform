import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CompletableFuture;
import java.util.Map;

// A realistic pairing of both mechanisms in one small feature: a REST
// endpoint that must respond IMMEDIATELY (task execution -- @Async), and
// a nightly job that cleans up stale data left behind by it (scheduling
// -- @Scheduled). Neither annotation could do the other's job: the
// controller can't afford to wait for a slow email send, and the cleanup
// isn't triggered by any request at all -- it just needs to run at 3 AM.
@Service
class SignupConfirmationService {

    private final Map<String, LocalDateTime> pendingConfirmations = new ConcurrentHashMap<>();

    @Async
    public CompletableFuture<Void> sendConfirmationEmail(String email) {
        pendingConfirmations.put(email, LocalDateTime.now());
        System.out.println("Sending confirmation email to " + email
                + " on thread " + Thread.currentThread().getName());
        return CompletableFuture.completedFuture(null);
    }

    @Scheduled(cron = "0 0 3 * * *")
    public void purgeStaleUnconfirmedSignups() {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(7);
        pendingConfirmations.entrySet().removeIf(entry -> entry.getValue().isBefore(cutoff));
        System.out.println("Purged stale unconfirmed signups older than 7 days");
    }
}

@RestController
class SignupController {

    private final SignupConfirmationService confirmationService;

    SignupController(SignupConfirmationService confirmationService) {
        this.confirmationService = confirmationService;
    }

    @PostMapping("/signup")
    public String signup(@RequestParam String email) {
        confirmationService.sendConfirmationEmail(email); // returns instantly, email sends in the background
        return "Signup received for " + email;
    }
}

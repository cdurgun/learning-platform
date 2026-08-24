import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

// @Async works through the exact same PROXY mechanism as @Transactional
// (see "Transaction Management") -- Spring wraps a proxy around the real
// bean, and the proxy is what actually intercepts a call and dispatches
// it to a separate thread. Calling an @Async method through that proxy
// (from OUTSIDE the class) works; calling it directly on "this" (from
// INSIDE the class) bypasses the proxy entirely, and @Async is silently
// ignored -- the method just runs like any ordinary method call, on the
// current thread. This is the identical self-invocation pitfall already
// covered there for @Transactional, now showing up for @Async instead.
@Service
class NotificationService {

    @Async
    public void sendPushNotification(String userId) {
        System.out.println("Sending push notification to " + userId
                + " on thread " + Thread.currentThread().getName());
    }

    // BROKEN: calling sendPushNotification(...) from another method in
    // the SAME class goes through "this", not through Spring's proxy --
    // @Async has no effect here, and this runs synchronously.
    public void processOrder_broken(String userId) {
        sendPushNotification(userId); // runs on the CALLING thread, not async
    }
}

@Service
class OrderService {

    private final NotificationService notificationService;

    OrderService(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    // WORKING: notificationService here is the Spring-managed PROXY,
    // injected from a separate bean -- calling through it correctly
    // dispatches to a separate thread, exactly as @Async promises.
    public void processOrder_working(String userId) {
        notificationService.sendPushNotification(userId); // genuinely async
    }
}

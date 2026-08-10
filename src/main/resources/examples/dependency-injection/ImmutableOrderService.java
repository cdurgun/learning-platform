import java.util.Objects;

// Constructor injection lets every dependency be `final` -- once built, an
// OrderService can never end up pointing at a different (or missing)
// NotificationSender. Combined with an explicit null-check, a broken wiring
// attempt fails immediately and loudly, not with a mysterious NPE three
// method calls later (compare with "Setter Injection").
interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class OrderService {
    private final NotificationSender notificationSender;

    OrderService(NotificationSender notificationSender) {
        // Fail fast: if the caller passes null, we find out right here, at
        // the exact line that got it wrong -- not somewhere deep inside
        // placeOrder() later.
        this.notificationSender = Objects.requireNonNull(notificationSender, "notificationSender must not be null");
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class ImmutableOrderService {
    public static void main(String[] args) {
        OrderService orderService = new OrderService(new EmailNotificationSender());
        orderService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.

        try {
            new OrderService(null);
        } catch (NullPointerException e) {
            System.out.println("Failed immediately: " + e.getMessage());
            // Failed immediately: notificationSender must not be null
        }
    }
}

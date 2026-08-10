import java.util.ArrayList;
import java.util.List;

// The payoff of depending on an interface: in a test, we can swap the real
// EmailNotificationSender for a tiny in-memory fake that just records what it
// was asked to send -- no real email is sent, and the test can assert on
// exactly what OrderService tried to do.
interface NotificationSender {
    void send(String to, String message);
}

class FakeNotificationSender implements NotificationSender {
    final List<String> sentMessages = new ArrayList<>();

    @Override
    public void send(String to, String message) {
        sentMessages.add(to + ": " + message);
    }
}

class OrderService {
    private final NotificationSender notificationSender;

    OrderService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class TestableOrderServiceExample {
    public static void main(String[] args) {
        FakeNotificationSender fake = new FakeNotificationSender();
        OrderService orderService = new OrderService(fake);

        orderService.placeOrder("ayse@example.com", "Java 21 Book");

        // A hand-rolled assertion -- no test framework needed to see the point:
        // this check runs against memory, in milliseconds, without a real
        // email provider or network call anywhere in sight.
        if (fake.sentMessages.size() != 1) {
            throw new AssertionError("Expected exactly one message to be sent");
        }
        System.out.println("Test passed: " + fake.sentMessages.get(0));
        // Test passed: ayse@example.com: Your order for 'Java 21 Book' has been placed.
    }
}

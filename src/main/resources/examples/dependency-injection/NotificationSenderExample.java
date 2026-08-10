// The "after" picture: OrderService now depends only on an abstraction
// (NotificationSender), never on a concrete class -- the same interface
// pattern from the "Interface" lesson, applied to the dependency problem.
interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class SmsNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[sms to " + to + "] " + message);
    }
}

class OrderService {
    private final NotificationSender notificationSender;

    // The dependency now arrives from OUTSIDE, through the constructor --
    // OrderService no longer contains the words "new EmailNotificationSender()"
    // anywhere. This is dependency injection: the caller decides, and injects.
    OrderService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class NotificationSenderExample {
    public static void main(String[] args) {
        OrderService emailBackedService = new OrderService(new EmailNotificationSender());
        emailBackedService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.

        // Same OrderService class, a completely different channel -- nothing
        // inside OrderService changed to make this possible.
        OrderService smsBackedService = new OrderService(new SmsNotificationSender());
        smsBackedService.placeOrder("+90 555 000 00 00", "Java 21 Book");
        // [sms to +90 555 000 00 00] Your order for 'Java 21 Book' has been placed.
    }
}

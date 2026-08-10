// Setter Injection: the dependency is assigned through an ordinary setter
// method AFTER the object already exists -- useful for genuinely optional
// dependencies, but it also means the object can exist in a "half-wired"
// state until someone remembers to call the setter.
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
    // Not final -- it has to stay reassignable so the setter can populate it
    // after construction.
    private NotificationSender notificationSender;

    void setNotificationSender(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        // If setNotificationSender(...) was never called, this throws a
        // NullPointerException here -- at call time, not at construction time.
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class SetterInjectionExample {
    public static void main(String[] args) {
        OrderService orderService = new OrderService();
        orderService.setNotificationSender(new EmailNotificationSender());
        orderService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.

        // A second OrderService, created but never wired -- this compiles fine
        // and only fails much later, when placeOrder() actually runs.
        OrderService forgotten = new OrderService();
        try {
            forgotten.placeOrder("mehmet@example.com", "Spring Boot Book");
        } catch (NullPointerException e) {
            System.out.println("Failed: notificationSender was never set.");
            // Failed: notificationSender was never set.
        }
    }
}

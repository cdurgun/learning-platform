// Constructor Injection: the dependency is a required constructor parameter,
// stored in a `final` field. There is no way to end up with a half-built
// OrderService that is missing its NotificationSender -- the object simply
// cannot exist without one.
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
    private final String storeName;

    // Multiple dependencies/parameters are injected the same way -- just more
    // constructor arguments. All of them are guaranteed to be set once the
    // constructor returns.
    OrderService(NotificationSender notificationSender, String storeName) {
        this.notificationSender = notificationSender;
        this.storeName = storeName;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact,
                "[" + storeName + "] Your order for '" + item + "' has been placed.");
    }
}

class ConstructorInjectionExample {
    public static void main(String[] args) {
        OrderService orderService = new OrderService(new EmailNotificationSender(), "Java Kitabevi");
        orderService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] [Java Kitabevi] Your order for 'Java 21 Book' has been placed.

        // The line below would not compile if uncommented -- there is no
        // no-argument constructor, so "forgetting" the dependency is not an
        // option the compiler will allow.
        // OrderService broken = new OrderService();
    }
}

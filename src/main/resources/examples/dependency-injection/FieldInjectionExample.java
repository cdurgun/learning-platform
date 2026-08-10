import java.lang.reflect.Field;

// Field Injection: a framework (Spring's @Autowired on a field is the classic
// example) reaches directly into a private field and sets it via reflection --
// the same Field.setAccessible(true) + Field.set(...) mechanism from the
// Reflection lesson's "Private Alan ve Metotlara Erişmek" section, just driven
// by a framework instead of your own code.
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
    // A real Spring field would be annotated @Autowired; there is no
    // constructor or setter here at all -- nothing but the bare field.
    private NotificationSender notificationSender;

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class FieldInjectionExample {
    public static void main(String[] args) throws ReflectiveOperationException {
        OrderService orderService = new OrderService();

        // This is, in miniature, what a dependency injection framework does
        // for every @Autowired field: find it by reflection, force it
        // accessible, and set it -- no constructor call, no setter call.
        Field field = OrderService.class.getDeclaredField("notificationSender");
        field.setAccessible(true);
        field.set(orderService, new EmailNotificationSender());

        orderService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.

        // Nothing in OrderService's own source code reveals how the field got
        // its value -- that opacity is exactly why "Yaygın Hatalar" warns
        // against relying on field injection.
    }
}

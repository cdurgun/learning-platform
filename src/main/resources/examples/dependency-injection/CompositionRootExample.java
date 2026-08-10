// A "composition root": one single place in the whole application where
// `new` is allowed to wire concrete classes together. Every class below this
// point (OrderService) only ever sees interfaces -- exactly what a Spring
// container will automate in the next lesson, done here with nothing but
// plain constructors.
interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

interface ReceiptPrinter {
    void print(String item, double price);
}

class ConsoleReceiptPrinter implements ReceiptPrinter {
    @Override
    public void print(String item, double price) {
        System.out.printf("[receipt] %s - %.2f TL%n", item, price);
    }
}

class OrderService {
    private final NotificationSender notificationSender;
    private final ReceiptPrinter receiptPrinter;

    OrderService(NotificationSender notificationSender, ReceiptPrinter receiptPrinter) {
        this.notificationSender = notificationSender;
        this.receiptPrinter = receiptPrinter;
    }

    void placeOrder(String customerContact, String item, double price) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
        receiptPrinter.print(item, price);
    }
}

class CompositionRootExample {
    // This method is the composition root: the one place that knows about
    // EmailNotificationSender and ConsoleReceiptPrinter by name. Nothing else
    // in the application does.
    static OrderService buildOrderService() {
        NotificationSender notificationSender = new EmailNotificationSender();
        ReceiptPrinter receiptPrinter = new ConsoleReceiptPrinter();
        return new OrderService(notificationSender, receiptPrinter);
    }

    public static void main(String[] args) {
        OrderService orderService = buildOrderService();
        orderService.placeOrder("ayse@example.com", "Java 21 Book", 349.90);
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.
        // [receipt] Java 21 Book - 349.90 TL
    }
}

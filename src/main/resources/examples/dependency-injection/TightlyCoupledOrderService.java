// The "before" picture: OrderService constructs its own dependency with `new`,
// so it is permanently welded to EmailSender -- no other channel, and no fake
// version for a test, can ever take its place.
class EmailSender {
    void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class OrderService {
    private final EmailSender emailSender = new EmailSender();

    void placeOrder(String customerEmail, String item) {
        // Business logic and object construction are tangled together here.
        emailSender.send(customerEmail, "Your order for '" + item + "' has been placed.");
    }
}

class TightlyCoupledOrderService {
    public static void main(String[] args) {
        OrderService orderService = new OrderService();
        orderService.placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.

        // There is no way to send this via SMS instead, and no way to replace
        // EmailSender with a fake for a test -- OrderService leaves us no seam.
    }
}

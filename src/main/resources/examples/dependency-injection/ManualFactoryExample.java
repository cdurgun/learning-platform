// Inversion of Control, in its smallest possible form: OrderNotifier no
// longer decides HOW its dependency gets built -- a separate factory does,
// and OrderNotifier only asks for the finished object.
interface MessageSender {
    void send(String to, String message);
}

class EmailMessageSender implements MessageSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

// The factory is the one place that knows EmailMessageSender exists. Swapping
// the concrete implementation later means editing this one method, not every
// class that used to call `new` directly.
class MessageSenderFactory {
    static MessageSender create() {
        return new EmailMessageSender();
    }
}

class OrderNotifier {
    private final MessageSender messageSender;

    OrderNotifier() {
        // OrderNotifier still decides to CALL the factory itself here -- that
        // is the piece "Dependency Injection: Sözleşmeye Karşı Programlamak"
        // removes next: even the factory call moves outside this class.
        this.messageSender = MessageSenderFactory.create();
    }

    void notifyCustomer(String email, String item) {
        messageSender.send(email, "Your order for '" + item + "' has been placed.");
    }
}

class ManualFactoryExample {
    public static void main(String[] args) {
        OrderNotifier notifier = new OrderNotifier();
        notifier.notifyCustomer("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Your order for 'Java 21 Book' has been placed.
    }
}

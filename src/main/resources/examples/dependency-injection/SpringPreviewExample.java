import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

// A preview only -- this file will not do anything useful on its own, since
// there is no container here to create these objects. It shows the same
// OrderService design from "Spring Olmadan Elle Bağımlılık Enjeksiyonu",
// now annotated so that a Spring container could build the composition root
// FOR us.
interface NotificationSender {
    void send(String to, String message);
}

@Component
class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

@Service
class OrderService {
    private final NotificationSender notificationSender;

    // @Autowired on a constructor is optional when there is only one
    // constructor (Spring uses it automatically) -- it is written explicitly
    // here to keep the intent visible, matching "Constructor Injection".
    @Autowired
    OrderService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Your order for '" + item + "' has been placed.");
    }
}

class SpringPreviewExample {
    // No output worth demonstrating here: without an ApplicationContext,
    // nobody scans for @Component/@Service or calls this constructor.
    // "Spring IoC Container & Bean Lifecycle" is where that container itself
    // gets built.
    public static void main(String[] args) {
        System.out.println("This class needs a Spring ApplicationContext to do anything -- see the next lesson.");
        // This class needs a Spring ApplicationContext to do anything -- see the next lesson.
    }
}

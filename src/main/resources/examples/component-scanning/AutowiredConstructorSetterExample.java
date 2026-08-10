import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

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
class ConstructorInjectedOrderService {
    private final NotificationSender notificationSender;

    // @Autowired is optional here -- with a single constructor, Spring uses it
    // automatically. It's written explicitly to keep the intent visible,
    // matching the Dependency Injection lesson's "Constructor Injection" section.
    @Autowired
    ConstructorInjectedOrderService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Constructor: order for '" + item + "' placed.");
    }
}

@Service
class SetterInjectedOrderService {
    private NotificationSender notificationSender;

    @Autowired
    void setNotificationSender(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void placeOrder(String customerContact, String item) {
        notificationSender.send(customerContact, "Setter: order for '" + item + "' placed.");
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

class AutowiredConstructorSetterExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        context.getBean(ConstructorInjectedOrderService.class).placeOrder("ayse@example.com", "Java 21 Book");
        // [email to ayse@example.com] Constructor: order for 'Java 21 Book' placed.

        context.getBean(SetterInjectedOrderService.class).placeOrder("ayse@example.com", "Spring Boot Book");
        // [email to ayse@example.com] Setter: order for 'Spring Boot Book' placed.

        context.close();
    }
}

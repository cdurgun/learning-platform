import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

interface NotificationSender {
    void send(String to, String message);
}

@Component("email")
class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

@Component("sms")
class SmsNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[sms to " + to + "] " + message);
    }
}

@Service
class NotificationGateway {
    private final Map<String, NotificationSender> sendersByName;

    // Spring has a special case for Map<String, T> parameters: it injects
    // EVERY bean of type T, keyed by bean name -- no @Qualifier, no manual
    // registry needed. NotificationGateway never has to change to learn
    // about a new channel; adding a third @Component is enough.
    @Autowired
    NotificationGateway(Map<String, NotificationSender> sendersByName) {
        this.sendersByName = sendersByName;
    }

    void sendVia(String channel, String to, String message) {
        NotificationSender sender = sendersByName.get(channel);
        if (sender == null) {
            throw new IllegalArgumentException("Unknown channel: " + channel);
        }
        sender.send(to, message);
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

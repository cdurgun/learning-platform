import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

interface NotificationSender {
    void send(String to, String message);
}

@Component("emailSender")
@Primary
class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

@Component("smsSender")
class SmsNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[sms to " + to + "] " + message);
    }
}

@Service
class EmailOnlyService {
    // No @Qualifier -- @Primary wins, EmailNotificationSender is injected.
    private final NotificationSender notificationSender;

    EmailOnlyService(NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void run() {
        notificationSender.send("ayse@example.com", "via default (@Primary)");
    }
}

@Service
class SmsOnlyService {
    // An explicit @Qualifier at the injection site always wins over @Primary --
    // @Primary only breaks ties when nothing more specific is asked for.
    private final NotificationSender notificationSender;

    SmsOnlyService(@Qualifier("smsSender") NotificationSender notificationSender) {
        this.notificationSender = notificationSender;
    }

    void run() {
        notificationSender.send("+90 555 000 00 00", "via explicit @Qualifier");
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

class QualifierPrimaryTogetherExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        context.getBean(EmailOnlyService.class).run();
        // [email to ayse@example.com] via default (@Primary)

        context.getBean(SmsOnlyService.class).run();
        // [sms to +90 555 000 00 00] via explicit @Qualifier

        context.close();
    }
}

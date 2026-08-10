import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    EmailNotificationSender() {
        System.out.println("EmailNotificationSender constructed");
    }

    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

@Configuration
class AppConfig {
    @Bean
    NotificationSender notificationSender() {
        return new EmailNotificationSender();
    }
}

class ApplicationContextExample {
    public static void main(String[] args) {
        // Unlike the raw BeanFactory, an ApplicationContext eagerly instantiates
        // every singleton bean the moment the context refreshes -- "EmailNotificationSender
        // constructed" prints right here, before any getBean(...) call at all.
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // EmailNotificationSender constructed

        NotificationSender sender = context.getBean(NotificationSender.class);
        sender.send("ayse@example.com", "Your order has been placed.");
        // [email to ayse@example.com] Your order has been placed.

        context.close();
    }
}

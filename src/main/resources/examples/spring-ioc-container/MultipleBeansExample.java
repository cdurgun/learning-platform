import org.springframework.beans.factory.NoUniqueBeanDefinitionException;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class SmsNotificationSender implements NotificationSender {
    @Override
    public void send(String to, String message) {
        System.out.println("[sms to " + to + "] " + message);
    }
}

@Configuration
class AppConfig {
    @Bean
    NotificationSender emailSender() {
        return new EmailNotificationSender();
    }

    @Bean
    NotificationSender smsSender() {
        return new SmsNotificationSender();
    }
}

class MultipleBeansExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        // Two NotificationSender beans exist now -- asking by type alone is ambiguous.
        try {
            context.getBean(NotificationSender.class);
        } catch (NoUniqueBeanDefinitionException e) {
            System.out.println("Ambiguous: " + e.getMessage());
            // Ambiguous: No qualifying bean of type 'NotificationSender' available:
            // expected single matching bean but found 2: emailSender,smsSender
        }

        // Asking by name (the @Bean method's name, by default) resolves it exactly.
        NotificationSender email = (NotificationSender) context.getBean("emailSender");
        NotificationSender sms = (NotificationSender) context.getBean("smsSender");
        email.send("ayse@example.com", "Hello via email");
        // [email to ayse@example.com] Hello via email
        sms.send("+90 555 000 00 00", "Hello via sms");
        // [sms to +90 555 000 00 00] Hello via sms

        context.close();
    }
}

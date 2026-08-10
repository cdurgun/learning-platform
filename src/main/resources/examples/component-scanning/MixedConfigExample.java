import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

// A class we imagine we do NOT own the source of (a third-party library) --
// or, like this project's own domain classes, something that has no reason
// to know Spring exists at all. There's no @Component here: even if we
// wanted one, we couldn't add it to someone else's source file.
class ThirdPartyMailClient {
    private final String apiKey;

    ThirdPartyMailClient(String apiKey) {
        this.apiKey = apiKey;
    }

    void send(String to, String message) {
        System.out.println("[mail-client key=" + apiKey + "] to " + to + ": " + message);
    }
}

// Our own class -- we DO own this one, so @Service (component scanning) is
// the natural choice.
@Service
class NotificationOrchestrator {
    private final ThirdPartyMailClient mailClient;

    @Autowired
    NotificationOrchestrator(ThirdPartyMailClient mailClient) {
        this.mailClient = mailClient;
    }

    void notifyCustomer(String to, String message) {
        mailClient.send(to, message);
    }
}

@Configuration
@ComponentScan
class AppConfig {
    // ThirdPartyMailClient can only be wired via @Bean -- we can't annotate a
    // class whose source we don't own (or shouldn't couple to Spring), and it
    // needs a constructor argument (an API key) that isn't itself a bean.
    @Bean
    ThirdPartyMailClient thirdPartyMailClient() {
        return new ThirdPartyMailClient("demo-api-key");
    }
}

class MixedConfigExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        context.getBean(NotificationOrchestrator.class).notifyCustomer("ayse@example.com", "Your order has shipped.");
        // [mail-client key=demo-api-key] to ayse@example.com: Your order has shipped.

        context.close();
    }
}

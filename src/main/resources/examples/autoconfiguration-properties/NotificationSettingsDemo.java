import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

class NotificationSettingsDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment environment = context.getEnvironment();
        environment.getPropertySources().addFirst(new MapPropertySource("test", Map.of(
                "app.notifications.retry-attempts", "5",
                "app.notifications.timeout-millis", "5000"
        )));
        environment.setActiveProfiles("prod");
        context.register(NotificationSettingsConfig.class);
        context.refresh();
        // Settings loaded: NotificationSettings{retryAttempts=5, timeoutMillis=5000}

        context.getBean(Runnable.class).run();
        // Production mode: retries will be slower and more patient.

        context.close();
    }
}

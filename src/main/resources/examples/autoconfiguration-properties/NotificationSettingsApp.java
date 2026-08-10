import jakarta.annotation.PostConstruct;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

// Mini project: a notification settings manager that ties together most of
// this lesson at once -- grouped settings via @ConfigurationProperties,
// environment-specific overrides via @Profile, and an event published once
// the settings are loaded, so other beans can react without depending on
// this one directly.
@ConfigurationProperties(prefix = "app.notifications")
class NotificationSettings {
    private int retryAttempts = 3;
    private long timeoutMillis = 2000;

    public int getRetryAttempts() { return retryAttempts; }
    public void setRetryAttempts(int retryAttempts) { this.retryAttempts = retryAttempts; }

    public long getTimeoutMillis() { return timeoutMillis; }
    public void setTimeoutMillis(long timeoutMillis) { this.timeoutMillis = timeoutMillis; }

    @Override
    public String toString() {
        return "NotificationSettings{retryAttempts=" + retryAttempts + ", timeoutMillis=" + timeoutMillis + "}";
    }
}

class SettingsLoadedEvent extends ApplicationEvent {
    private final NotificationSettings settings;

    SettingsLoadedEvent(Object source, NotificationSettings settings) {
        super(source);
        this.settings = settings;
    }

    NotificationSettings getSettings() {
        return settings;
    }
}

@Component
class SettingsLoader {
    private final NotificationSettings settings;
    private final ApplicationEventPublisher publisher;

    SettingsLoader(NotificationSettings settings, ApplicationEventPublisher publisher) {
        this.settings = settings;
        this.publisher = publisher;
    }

    @PostConstruct
    void publishOnceLoaded() {
        publisher.publishEvent(new SettingsLoadedEvent(this, settings));
    }
}

@Component
class SettingsAuditListener {
    @EventListener
    void onSettingsLoaded(SettingsLoadedEvent event) {
        System.out.println("Settings loaded: " + event.getSettings());
    }
}

@Configuration
@EnableConfigurationProperties(NotificationSettings.class)
@ComponentScan
class NotificationSettingsConfig {

    // A more patient retry policy only in production, layered on top of the
    // defaults from application.yml -- @Profile deciding between two
    // completely different Runnable strategies, the same idea as
    // PaymentConfig earlier in this lesson.
    @Bean
    @Profile("prod")
    Runnable slowRetryWarning() {
        return () -> System.out.println("Production mode: retries will be slower and more patient.");
    }

    @Bean
    @Profile("!prod")
    Runnable fastRetryWarning() {
        return () -> System.out.println("Non-production mode: retries are fast, for quicker feedback.");
    }
}

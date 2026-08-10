import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.BeanCreationException;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

// Real Spring Boot projects validate @ConfigurationProperties with
// jakarta.validation annotations (@NotBlank, @Min...) plus @Validated --
// that needs the spring-boot-starter-validation dependency, which this
// project doesn't have. We get the same safety net by hand instead, with a
// @PostConstruct check that fails fast at startup instead of silently
// running with a broken configuration.
@ConfigurationProperties(prefix = "app.retry")
class RetryProperties {
    private int maxAttempts = 3;
    private long backoffMillis = 500;

    public int getMaxAttempts() { return maxAttempts; }
    public void setMaxAttempts(int maxAttempts) { this.maxAttempts = maxAttempts; }

    public long getBackoffMillis() { return backoffMillis; }
    public void setBackoffMillis(long backoffMillis) { this.backoffMillis = backoffMillis; }

    @PostConstruct
    void validate() {
        if (maxAttempts < 1) {
            throw new IllegalStateException("app.retry.max-attempts must be at least 1, was " + maxAttempts);
        }
        if (backoffMillis < 0) {
            throw new IllegalStateException("app.retry.backoff-millis cannot be negative, was " + backoffMillis);
        }
    }
}

@Configuration
@EnableConfigurationProperties(RetryProperties.class)
class RetryConfig {
}

class ConfigurationPropertiesValidationExample {
    public static void main(String[] args) {
        // Case 1: a valid configuration -- starts up normally.
        AnnotationConfigApplicationContext validContext = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment validEnv = validContext.getEnvironment();
        validEnv.getPropertySources().addFirst(new MapPropertySource("test", Map.of("app.retry.max-attempts", "5")));
        validContext.register(RetryConfig.class);
        validContext.refresh();
        System.out.println(validContext.getBean(RetryProperties.class).getMaxAttempts());
        // 5
        validContext.close();

        // Case 2: an invalid configuration -- @PostConstruct fails fast at
        // startup instead of the application running with a nonsensical
        // "0 retries" setting. Spring wraps the exception our own code threw
        // inside a BeanCreationException, the same as it would for any other
        // failing @PostConstruct method (see the Spring IoC Container lesson).
        AnnotationConfigApplicationContext invalidContext = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment invalidEnv = invalidContext.getEnvironment();
        invalidEnv.getPropertySources().addFirst(new MapPropertySource("test", Map.of("app.retry.max-attempts", "0")));
        invalidContext.register(RetryConfig.class);
        try {
            invalidContext.refresh();
        } catch (BeanCreationException e) {
            System.out.println("Startup failed: " + e.getRootCause().getMessage());
            // Startup failed: app.retry.max-attempts must be at least 1, was 0
        }
    }
}

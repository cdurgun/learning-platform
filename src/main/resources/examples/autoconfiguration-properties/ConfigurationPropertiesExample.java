import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

// @ConfigurationProperties groups a whole family of related settings into one
// typed object, bound from a common prefix -- unlike @Value, which reads one
// property at a time with no structure of its own.
@ConfigurationProperties(prefix = "app.mail")
class MailProperties {
    private String host = "localhost";
    private int port = 25;
    private boolean tlsEnabled = false;

    public String getHost() { return host; }
    public void setHost(String host) { this.host = host; }

    public int getPort() { return port; }
    public void setPort(int port) { this.port = port; }

    public boolean isTlsEnabled() { return tlsEnabled; }
    public void setTlsEnabled(boolean tlsEnabled) { this.tlsEnabled = tlsEnabled; }

    @Override
    public String toString() {
        return "MailProperties{host='" + host + "', port=" + port + ", tlsEnabled=" + tlsEnabled + "}";
    }
}

@Configuration
@EnableConfigurationProperties(MailProperties.class)
class MailConfig {
    // Note: no PropertySourcesPlaceholderConfigurer needed here, unlike the
    // @Value example -- @ConfigurationProperties binds directly from the
    // Environment's property sources, it does not go through the ${...}
    // embedded value resolver mechanism @Value relies on.
}

class ConfigurationPropertiesExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment environment = context.getEnvironment();
        // "tls-enabled" (kebab-case, as it would appear in application.yml)
        // binds to the "tlsEnabled" field automatically -- Spring Boot's
        // relaxed binding rules treat the two as the same property.
        environment.getPropertySources().addFirst(new MapPropertySource("test", Map.of(
                "app.mail.host", "smtp.example.com",
                "app.mail.port", "587",
                "app.mail.tls-enabled", "true"
        )));
        context.register(MailConfig.class);
        context.refresh();

        System.out.println(context.getBean(MailProperties.class));
        // MailProperties{host='smtp.example.com', port=587, tlsEnabled=true}

        context.close();
    }
}

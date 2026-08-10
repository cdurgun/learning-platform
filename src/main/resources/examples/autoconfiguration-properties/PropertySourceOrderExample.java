import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.StandardEnvironment;

import java.util.Map;

// Spring Boot reads configuration from many places at once -- command-line
// arguments, environment variables, application-{profile}.yml,
// application.yml, and more -- and needs a strict priority order to pick a
// winner when more than one source defines the same key. We simulate three
// of those sources by hand here, added in *reverse* priority order, to watch
// the highest-priority one win.
class PropertySourceOrderExample {
    public static void main(String[] args) {
        ConfigurableEnvironment environment = new StandardEnvironment();
        MutablePropertySources sources = environment.getPropertySources();

        // Lowest priority: the base application.yml.
        sources.addLast(new MapPropertySource("application.yml", Map.of("server.port", "8080")));

        // Higher priority: a profile-specific application-prod.yml.
        sources.addBefore("application.yml", new MapPropertySource("application-prod.yml", Map.of("server.port", "9090")));

        // Highest priority in this example: an environment variable (in a
        // real deployment this would come from the OS itself, via
        // StandardEnvironment's own built-in "systemEnvironment" source).
        sources.addFirst(new MapPropertySource("systemEnvironment", Map.of("server.port", "443")));

        System.out.println(environment.getProperty("server.port"));
        // 443

        // Remove the environment variable to see the next source in line win.
        sources.remove("systemEnvironment");
        System.out.println(environment.getProperty("server.port"));
        // 9090

        sources.remove("application-prod.yml");
        System.out.println(environment.getProperty("server.port"));
        // 8080
    }
}

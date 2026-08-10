import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

interface CacheWarmer {
    void warmUp();
}

// A hand-written stand-in for what a real Spring Boot "starter" auto-configuration
// class looks like: @ConditionalOnProperty lets the application turn a whole
// feature on/off from application.yml, with a safe default (off) if the
// property is never set at all.
@Configuration
class CacheWarmerAutoConfiguration {

    @Bean
    @ConditionalOnProperty(name = "app.cache-warmer.enabled", havingValue = "true", matchIfMissing = false)
    CacheWarmer cacheWarmer() {
        return () -> System.out.println("Cache warmed up.");
    }
}

class CustomAutoConfigurationExample {
    public static void main(String[] args) {
        // Case 1: the property is set to true -- the bean is registered.
        AnnotationConfigApplicationContext enabledContext = new AnnotationConfigApplicationContext();
        addProperty(enabledContext, "app.cache-warmer.enabled", "true");
        enabledContext.register(CacheWarmerAutoConfiguration.class);
        enabledContext.refresh();
        System.out.println(enabledContext.containsBean("cacheWarmer"));
        // true
        enabledContext.close();

        // Case 2: the property is never set -- matchIfMissing = false means
        // the bean is skipped, exactly like an optional Spring Boot feature
        // that stays off until the application opts in.
        AnnotationConfigApplicationContext disabledContext = new AnnotationConfigApplicationContext();
        disabledContext.register(CacheWarmerAutoConfiguration.class);
        disabledContext.refresh();
        System.out.println(disabledContext.containsBean("cacheWarmer"));
        // false
        disabledContext.close();
    }

    private static void addProperty(AnnotationConfigApplicationContext context, String key, String value) {
        ConfigurableEnvironment environment = context.getEnvironment();
        environment.getPropertySources().addFirst(new MapPropertySource("test", Map.of(key, value)));
    }
}

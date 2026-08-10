import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

interface MessageFormatter {
    String format(String message);
}

// Simulates the "library default, application override" pattern used
// everywhere in real Spring Boot auto-configuration: a library ships a
// sensible default bean, marked @ConditionalOnMissingBean, so any bean the
// application itself defines of the same type silently takes priority.
@Configuration
class LibraryDefaultsConfig {
    @Bean
    @ConditionalOnMissingBean
    MessageFormatter messageFormatter() {
        return message -> "[default] " + message;
    }
}

@Configuration
class UserOverrideConfig {
    @Bean
    MessageFormatter messageFormatter() {
        return message -> "[custom] " + message;
    }
}

class ConditionalOnMissingBeanExample {
    public static void main(String[] args) {
        // Case 1: only the library's config is present -- its default wins.
        AnnotationConfigApplicationContext withoutOverride =
                new AnnotationConfigApplicationContext(LibraryDefaultsConfig.class);
        System.out.println(withoutOverride.getBean(MessageFormatter.class).format("hello"));
        // [default] hello
        withoutOverride.close();

        // Case 2: the application also registers its own bean. Order matters:
        // UserOverrideConfig is given first, so its bean definition already
        // exists by the time @ConditionalOnMissingBean is evaluated for
        // LibraryDefaultsConfig -- exactly why real auto-configuration classes
        // are always processed after the application's own @Configuration
        // classes.
        AnnotationConfigApplicationContext withOverride =
                new AnnotationConfigApplicationContext(UserOverrideConfig.class, LibraryDefaultsConfig.class);
        System.out.println(withOverride.getBean(MessageFormatter.class).format("hello"));
        // [custom] hello
        withOverride.close();
    }
}

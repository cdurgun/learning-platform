import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

// @Value pulls a single property value into a field or constructor parameter --
// the simplest way to read application.yml/application.properties, but with
// no grouping and no type validation beyond the target field's own type.
class GreetingService {

    @Value("${app.greeting.prefix:Hello}")
    private String prefix;

    // ${...} placeholders are resolved first, and only then is the resulting
    // string evaluated as a SpEL expression (#{...}) -- so this becomes
    // "#{'Hello'.toUpperCase()}" before it is ever evaluated.
    @Value("#{'${app.greeting.prefix:Hello}'.toUpperCase()}")
    private String shoutedPrefix;

    String greet(String name) {
        return prefix + ", " + name + "!";
    }

    String shoutedGreet(String name) {
        return shoutedPrefix + ", " + name + "!";
    }
}

@Configuration
class GreetingConfig {

    // Outside Spring Boot, ${...} placeholders in @Value are NOT resolved
    // automatically -- this bean is what actually makes them work. It must
    // be `static`, so the container can run it very early, before other
    // @Configuration classes are even fully processed. In a real Spring Boot
    // app you never write this yourself: PropertyPlaceholderAutoConfiguration
    // (triggered by @EnableAutoConfiguration) registers it for you -- exactly
    // the kind of boilerplate auto-configuration exists to remove (see "Why
    // Does It Exist?").
    @Bean
    static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Bean
    GreetingService greetingService() {
        return new GreetingService();
    }
}

class ValueInjectionExample {
    public static void main(String[] args) {
        // Case 1: the property is set explicitly (simulated here with a
        // MapPropertySource, standing in for application.yml).
        AnnotationConfigApplicationContext withProperty = new AnnotationConfigApplicationContext();
        ConfigurableEnvironment env1 = withProperty.getEnvironment();
        env1.getPropertySources().addFirst(new MapPropertySource("test", Map.of("app.greeting.prefix", "Merhaba")));
        withProperty.register(GreetingConfig.class);
        withProperty.refresh();
        System.out.println(withProperty.getBean(GreetingService.class).greet("Ayse"));
        // Merhaba, Ayse!
        withProperty.close();

        // Case 2: the property is never set -- the ":Hello" default after the
        // colon kicks in, instead of a startup failure.
        AnnotationConfigApplicationContext withoutProperty = new AnnotationConfigApplicationContext();
        withoutProperty.register(GreetingConfig.class);
        withoutProperty.refresh();
        System.out.println(withoutProperty.getBean(GreetingService.class).greet("Ayse"));
        // Hello, Ayse!
        System.out.println(withoutProperty.getBean(GreetingService.class).shoutedGreet("Ayse"));
        // HELLO, Ayse!
        withoutProperty.close();
    }
}

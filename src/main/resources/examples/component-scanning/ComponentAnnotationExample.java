import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

// @Component marks a class as a bean the container should manage -- unlike the
// @Bean methods from the Spring IoC Container lesson, there's no factory method
// here at all; the class itself IS the bean definition, discovered by scanning.
@Component
class GreetingProvider {
    String greet(String name) {
        return "Hello, " + name + "!";
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

class ComponentAnnotationExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        GreetingProvider provider = context.getBean(GreetingProvider.class);
        System.out.println(provider.greet("Ayse"));
        // Hello, Ayse!

        context.close();
    }
}

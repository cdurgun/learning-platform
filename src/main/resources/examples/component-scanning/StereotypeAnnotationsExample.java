import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

// @Service, @Repository, and @Controller are all meta-annotated with
// @Component -- the container treats them identically for scanning and bean
// registration. The difference is purely semantic (readability, and in
// @Repository's case, one extra feature -- exception translation).
@Service
class OrderService {
    void placeOrder(String item) {
        System.out.println("Order placed: " + item);
    }
}

@Repository
class OrderRepository {
    void save(String item) {
        System.out.println("Saved to database: " + item);
    }
}

class OrderController {
    // Plain class -- deliberately NOT annotated, to contrast with the two above.
}

@Configuration
@ComponentScan
class AppConfig {
}

class StereotypeAnnotationsExample {
    public static void main(String[] args) {
        // Confirms @Service really is @Component underneath: AnnotationUtils
        // walks the same meta-annotation chain Spring's own scanner does.
        boolean serviceIsComponent = AnnotationUtils.findAnnotation(Service.class, Component.class) != null;
        System.out.println(serviceIsComponent); // true

        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        context.getBean(OrderService.class).placeOrder("Java 21 Book");
        // Order placed: Java 21 Book
        context.getBean(OrderRepository.class).save("Java 21 Book");
        // Saved to database: Java 21 Book

        // OrderController was never annotated, so it was never scanned -- this
        // line throws NoSuchBeanDefinitionException.
        try {
            context.getBean(OrderController.class);
        } catch (NoSuchBeanDefinitionException e) {
            System.out.println("Not a bean: " + e.getClass().getSimpleName());
            // Not a bean: NoSuchBeanDefinitionException
        }

        context.close();
    }
}

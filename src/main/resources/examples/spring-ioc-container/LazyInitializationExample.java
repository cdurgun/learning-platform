import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;

class EagerService {
    EagerService() {
        System.out.println("EagerService constructed");
    }
}

class LazyService {
    LazyService() {
        System.out.println("LazyService constructed");
    }
}

@Configuration
class AppConfig {
    @Bean
    EagerService eagerService() {
        return new EagerService();
    }

    @Bean
    @Lazy
    // This bean's constructor will NOT run when the context refreshes -- only
    // the first time something actually asks for it.
    LazyService lazyService() {
        return new LazyService();
    }
}

class LazyInitializationExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // EagerService constructed

        System.out.println("Context refreshed -- LazyService not constructed yet.");
        // Context refreshed -- LazyService not constructed yet.

        context.getBean(LazyService.class);
        // LazyService constructed

        context.close();
    }
}

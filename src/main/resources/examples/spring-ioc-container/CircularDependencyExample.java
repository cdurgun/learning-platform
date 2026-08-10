import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;

// ServiceA needs ServiceB, and ServiceB needs ServiceA -- neither can finish
// being constructed before the other exists. With plain constructor injection
// on both sides, Spring has no safe order to build them in and refuses outright
// (a BeanCurrentlyInCreationException wrapped in a BeanCreationException).
class ServiceA {
    private final ServiceB serviceB;

    ServiceA(ServiceB serviceB) {
        this.serviceB = serviceB;
    }
}

class ServiceB {
    private final ServiceA serviceA;

    ServiceB(@Lazy ServiceA serviceA) {
        // @Lazy here breaks the deadlock: instead of the real ServiceA, Spring
        // injects a proxy that only constructs the real ServiceA the first time
        // one of its methods is actually called -- by which point ServiceA's own
        // construction (which needed a finished ServiceB) has already completed.
        this.serviceA = serviceA;
    }
}

@Configuration
class AppConfig {
    @Bean
    ServiceA serviceA(ServiceB serviceB) {
        return new ServiceA(serviceB);
    }

    @Bean
    ServiceB serviceB(ServiceA serviceA) {
        return new ServiceB(serviceA);
    }
}

class CircularDependencyExample {
    public static void main(String[] args) {
        // Without @Lazy on one side of the cycle, this line would fail instead
        // of succeeding.
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        System.out.println("Context started successfully despite the circular dependency.");
        // Context started successfully despite the circular dependency.
        context.close();
    }
}

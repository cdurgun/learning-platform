import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

class Counter {
    private int value;

    void increment() {
        value++;
    }

    int getValue() {
        return value;
    }
}

@Configuration
class AppConfig {
    @Bean
    @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
    // Every getBean() call now returns a BRAND NEW instance -- the container
    // still creates it and runs its lifecycle callbacks, but ownership (and
    // @PreDestroy) passes to the caller from that point on.
    Counter counter() {
        return new Counter();
    }
}

class PrototypeScopeExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        Counter first = context.getBean(Counter.class);
        first.increment();
        first.increment();

        Counter second = context.getBean(Counter.class);
        second.increment();

        System.out.println(first == second); // false -- two independent instances
        System.out.println(first.getValue());  // 2
        System.out.println(second.getValue()); // 1

        context.close();
    }
}

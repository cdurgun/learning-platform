import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

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
    // No scope annotation at all -- "singleton" is the default: the container
    // creates exactly one instance and hands out that same instance every time.
    Counter counter() {
        return new Counter();
    }
}

class SingletonScopeExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        Counter first = context.getBean(Counter.class);
        first.increment();
        first.increment();

        Counter second = context.getBean(Counter.class);
        second.increment();

        System.out.println(first == second); // true
        System.out.println(first.getValue()); // 3 -- both references share the same state

        context.close();
    }
}

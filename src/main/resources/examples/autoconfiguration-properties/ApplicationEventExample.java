import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

// A custom application event -- any object extending ApplicationEvent (or,
// since Spring 4.2, any arbitrary object at all) can be published and picked
// up by listeners, completely decoupling the publisher from whoever reacts
// to it.
class OrderPlacedEvent extends ApplicationEvent {
    private final String orderId;

    OrderPlacedEvent(Object source, String orderId) {
        super(source);
        this.orderId = orderId;
    }

    String getOrderId() {
        return orderId;
    }
}

@Component
class OrderService {
    private final ApplicationEventPublisher publisher;

    OrderService(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }

    void placeOrder(String orderId) {
        System.out.println("Order placed: " + orderId);
        publisher.publishEvent(new OrderPlacedEvent(this, orderId));
    }
}

@Component
class OrderNotificationListener {

    // @EventListener is the modern, annotation-based alternative to
    // implementing ApplicationListener<OrderPlacedEvent> directly -- both
    // work, this one needs no interface at all.
    @EventListener
    void onOrderPlaced(OrderPlacedEvent event) {
        System.out.println("Sending confirmation email for order " + event.getOrderId());
    }

    // The container itself publishes events too -- ContextRefreshedEvent
    // fires once the ApplicationContext has finished starting up. In a full
    // Spring Boot app, ApplicationReadyEvent is the equivalent "everything is
    // completely ready" signal, fired after ContextRefreshedEvent, once the
    // embedded server has also started (see "Spring Boot's Own Events").
    @EventListener
    void onContextRefreshed(ContextRefreshedEvent event) {
        System.out.println("Application context is ready.");
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

class ApplicationEventExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // Application context is ready.

        context.getBean(OrderService.class).placeOrder("ORD-1001");
        // Order placed: ORD-1001
        // Sending confirmation email for order ORD-1001

        context.close();
    }
}

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

// @TransactionalEventListener (from the Auto-Configuration & Properties
// lesson's ApplicationEvent/@EventListener section, but transaction-aware)
// defers handling an event until the surrounding transaction reaches a
// particular phase -- most commonly AFTER_COMMIT, so a listener only reacts
// to writes that actually stuck.
class OrderCreatedEvent {
    private final String orderId;

    OrderCreatedEvent(String orderId) {
        this.orderId = orderId;
    }

    String getOrderId() {
        return orderId;
    }
}

@Component
class OrderCreationService {
    private final Ledger ledger;
    private final ApplicationEventPublisher publisher;

    OrderCreationService(Ledger ledger, ApplicationEventPublisher publisher) {
        this.ledger = ledger;
        this.publisher = publisher;
    }

    @Transactional
    void createOrder(String orderId, boolean simulateFailureAfterPublish) {
        ledger.add("order-created:" + orderId);
        publisher.publishEvent(new OrderCreatedEvent(orderId));
        if (simulateFailureAfterPublish) {
            throw new IllegalStateException("Something failed after publishing the event");
        }
    }
}

@Component
class OrderNotificationListener {
    // Only runs if the transaction that published the event actually commits --
    // if createOrder(...) rolls back, this method never runs at all, even
    // though publishEvent(...) was called.
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void onOrderCreated(OrderCreatedEvent event) {
        System.out.println("Notification sent for order " + event.getOrderId());
    }
}

@Configuration
@EnableTransactionManagement
@ComponentScan
class OrderCreationConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }
}

class TransactionalEventListenerExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(OrderCreationConfig.class);
        OrderCreationService service = context.getBean(OrderCreationService.class);

        service.createOrder("ORD-3", false);
        // Notification sent for order ORD-3

        try {
            service.createOrder("ORD-4", true);
        } catch (IllegalStateException e) {
            // No "Notification sent for order ORD-4" is ever printed -- the
            // transaction rolled back, so AFTER_COMMIT never fires.
            System.out.println("Failed: " + e.getMessage());
        }

        context.close();
    }
}

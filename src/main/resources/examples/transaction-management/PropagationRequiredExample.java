import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

// PROPAGATION_REQUIRED (the default): if a transaction is already active,
// join it -- don't start a second one. If the outer transaction rolls back,
// every write made by any REQUIRED method it called rolls back with it,
// because they were really all the same transaction all along.
@Service
class OrderService {

    private final PaymentService paymentService;
    private final Ledger ledger;

    OrderService(PaymentService paymentService, Ledger ledger) {
        this.paymentService = paymentService;
        this.ledger = ledger;
    }

    @Transactional
    void placeOrderThatFailsAfterPayment(String orderId) {
        ledger.add("order-created:" + orderId);
        paymentService.charge(orderId, 100); // joins this same transaction
        throw new IllegalStateException("Inventory check failed after payment");
    }
}

@Service
class PaymentService {
    private final Ledger ledger;

    PaymentService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional // PROPAGATION_REQUIRED is the default -- no explicit value needed
    void charge(String orderId, int amount) {
        ledger.add("payment-charged:" + orderId + ":" + amount);
    }
}

@Configuration
@EnableTransactionManagement
class OrderConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    PaymentService paymentService(Ledger ledger) {
        return new PaymentService(ledger);
    }

    @Bean
    OrderService orderService(PaymentService paymentService, Ledger ledger) {
        return new OrderService(paymentService, ledger);
    }
}

class PropagationRequiredExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(OrderConfig.class);
        Ledger ledger = context.getBean(Ledger.class);

        try {
            context.getBean(OrderService.class).placeOrderThatFailsAfterPayment("ORD-1");
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }

        // Both the order AND the payment are gone -- placeOrderThatFailsAfterPayment
        // and charge(...) shared the exact same transaction (PROPAGATION_REQUIRED
        // joined instead of starting a new one), so the whole thing rolled back
        // together.
        System.out.println(ledger.entries());
        // []

        context.close();
    }
}

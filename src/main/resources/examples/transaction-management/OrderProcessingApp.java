import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

// Mini project: a realistic OrderService -> PaymentService -> InventoryAuditService
// flow, tying propagation and transactional events together. The order and
// payment share one transaction (PROPAGATION_REQUIRED); the audit log is
// PROPAGATION_REQUIRES_NEW, so it survives even if the order later fails; and
// the shipping notification only fires once the whole order transaction has
// actually committed.
class OrderPlacedEvent {
    private final String orderId;

    OrderPlacedEvent(String orderId) {
        this.orderId = orderId;
    }

    String getOrderId() {
        return orderId;
    }
}

@Service
class InventoryAuditService {
    private final Ledger ledger;

    InventoryAuditService(Ledger ledger) {
        this.ledger = ledger;
    }

    // Independent of the order transaction on purpose -- an audit trail
    // should record "we tried this" even if the order itself is later rolled
    // back.
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    void recordAttempt(String orderId) {
        ledger.add("audit:attempted:" + orderId);
    }
}

@Service
class PaymentService {
    private final Ledger ledger;

    PaymentService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional // PROPAGATION_REQUIRED -- joins the order's own transaction
    void charge(String orderId, int amount) {
        ledger.add("payment:" + orderId + ":" + amount);
    }
}

@Service
class OrderService {
    private final PaymentService paymentService;
    private final InventoryAuditService auditService;
    private final Ledger ledger;
    private final ApplicationEventPublisher publisher;

    OrderService(PaymentService paymentService,
                 InventoryAuditService auditService,
                 Ledger ledger,
                 ApplicationEventPublisher publisher) {
        this.paymentService = paymentService;
        this.auditService = auditService;
        this.ledger = ledger;
        this.publisher = publisher;
    }

    @Transactional
    void placeOrder(String orderId, int amount, boolean outOfStock) {
        auditService.recordAttempt(orderId); // its own transaction, always commits
        ledger.add("order:" + orderId);
        paymentService.charge(orderId, amount); // joins this transaction
        if (outOfStock) {
            throw new IllegalStateException("Out of stock -- order rolled back");
        }
        publisher.publishEvent(new OrderPlacedEvent(orderId));
    }
}

@Service
class ShippingNotificationListener {
    // Only fires once placeOrder(...) has actually committed -- never for the
    // out-of-stock case, since that transaction rolled back before the
    // event's transaction could ever reach AFTER_COMMIT.
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void onOrderPlaced(OrderPlacedEvent event) {
        System.out.println("Shipping notification sent for order " + event.getOrderId());
    }
}

@Configuration
@EnableTransactionManagement
@ComponentScan
class OrderProcessingConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }
}

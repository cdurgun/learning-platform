import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

// PROPAGATION_REQUIRES_NEW: always suspend whatever transaction is active (if
// any) and start a brand new, completely independent one. The new transaction
// commits or rolls back entirely on its own -- if the *outer* transaction
// later rolls back, the inner one's already-committed work is untouched.
@Service
class AuditService {
    private final Ledger ledger;

    AuditService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    void recordAuditEntry(String message) {
        ledger.add("audit:" + message);
    }
}

@Service
class CheckoutService {
    private final AuditService auditService;
    private final Ledger ledger;

    CheckoutService(AuditService auditService, Ledger ledger) {
        this.auditService = auditService;
        this.ledger = ledger;
    }

    @Transactional
    void checkoutThatFails(String orderId) {
        ledger.add("checkout-started:" + orderId);
        auditService.recordAuditEntry("checkout attempted for " + orderId); // its own, separate transaction
        throw new IllegalStateException("Card declined");
    }
}

@Configuration
@EnableTransactionManagement
class CheckoutConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    AuditService auditService(Ledger ledger) {
        return new AuditService(ledger);
    }

    @Bean
    CheckoutService checkoutService(AuditService auditService, Ledger ledger) {
        return new CheckoutService(auditService, ledger);
    }
}

class PropagationRequiresNewExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(CheckoutConfig.class);
        Ledger ledger = context.getBean(Ledger.class);

        try {
            context.getBean(CheckoutService.class).checkoutThatFails("ORD-2");
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }

        // "checkout-started" is gone (the outer transaction rolled back), but
        // the audit entry survives -- REQUIRES_NEW made it its own,
        // independent transaction that had already committed before
        // checkoutThatFails ever threw.
        System.out.println(ledger.entries());
        // [audit:checkout attempted for ORD-2]

        context.close();
    }
}

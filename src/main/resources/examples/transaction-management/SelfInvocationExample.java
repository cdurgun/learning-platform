import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

// @Transactional works through a proxy Spring wraps around the bean (see
// "@EnableTransactionManagement and the Proxy-Based Mechanism"). Calling a
// @Transactional method through `this` (from inside the same class) never
// goes through that proxy at all -- the annotation is silently ignored.
@Service
class InvoiceService {

    private final Ledger ledger;

    InvoiceService(Ledger ledger) {
        this.ledger = ledger;
    }

    // Looks like it delegates to a transactional method -- but calling
    // writeLine(...) here is a plain Java method call on `this`, not a call
    // through the Spring proxy. @Transactional on writeLine() has NO effect
    // when reached this way.
    void createInvoiceViaSelfInvocation(String customer) {
        writeLine("invoice-open:" + customer);
        writeLine("invoice-line:" + customer);
        throw new IllegalStateException("Something went wrong after writing both lines");
    }

    @Transactional
    void writeLine(String line) {
        ledger.add(line);
    }
}

@Configuration
@EnableTransactionManagement
class InvoiceConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    InvoiceService invoiceService(Ledger ledger) {
        return new InvoiceService(ledger);
    }
}

class SelfInvocationExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(InvoiceConfig.class);
        Ledger ledger = context.getBean(Ledger.class);

        try {
            context.getBean(InvoiceService.class).createInvoiceViaSelfInvocation("Ayse");
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }

        // Both lines survive the exception -- writeLine(...) was never
        // actually transactional here, since it was called as
        // `this.writeLine(...)`, bypassing the proxy entirely. No transaction
        // ever started, so there was nothing to roll back.
        System.out.println(ledger.entries());
        // [invoice-open:Ayse, invoice-line:Ayse]

        context.close();
    }
}

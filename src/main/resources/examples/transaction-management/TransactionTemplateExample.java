import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

// TransactionTemplate is @Transactional's programmatic counterpart -- useful
// when the transaction boundary needs to be conditional, or narrower than
// "the whole method," in a way an annotation on the method signature can't
// express.
@Configuration
class TransactionTemplateConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    TransactionTemplate transactionTemplate(PlatformTransactionManager transactionManager) {
        return new TransactionTemplate(transactionManager);
    }
}

class TransactionTemplateExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(TransactionTemplateConfig.class);
        Ledger ledger = context.getBean(Ledger.class);
        TransactionTemplate transactionTemplate = context.getBean(TransactionTemplate.class);

        // Runs the whole lambda inside a transaction -- commits normally if it
        // returns, rolls back if it throws, exactly like @Transactional.
        transactionTemplate.executeWithoutResult(status -> ledger.add("programmatic-entry"));
        System.out.println(ledger.entries());
        // [programmatic-entry]

        try {
            transactionTemplate.executeWithoutResult(status -> {
                ledger.add("about-to-fail");
                throw new IllegalStateException("Rolled back programmatically");
            });
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
        }
        System.out.println(ledger.entries());
        // [programmatic-entry]  -- "about-to-fail" was rolled back

        // status.setRollbackOnly() rolls back WITHOUT throwing an exception at
        // all -- useful when a business rule decides to abort, not an error.
        transactionTemplate.executeWithoutResult(status -> {
            ledger.add("conditionally-added");
            status.setRollbackOnly();
        });
        System.out.println(ledger.entries());
        // [programmatic-entry]  -- "conditionally-added" was rolled back too

        context.close();
    }
}

import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

// @Transactional's most basic use: a method that either fully succeeds
// (commit) or fully fails (rollback) -- no partial state is ever visible from
// the outside.
@Service
class AccountService {

    private final Ledger ledger;

    AccountService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional
    void transferSuccessfully(String from, String to, int amount) {
        ledger.add(from + " -" + amount);
        ledger.add(to + " +" + amount);
    }

    @Transactional
    void transferAndFail(String from, String to, int amount) {
        ledger.add(from + " -" + amount);
        ledger.add(to + " +" + amount);
        throw new IllegalStateException("Payment provider unreachable");
    }
}

@Configuration
@EnableTransactionManagement
class AccountConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    AccountService accountService(Ledger ledger) {
        return new AccountService(ledger);
    }
}

class TransactionalBasicExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AccountConfig.class);
        Ledger ledger = context.getBean(Ledger.class);

        context.getBean(AccountService.class).transferSuccessfully("A", "B", 100);
        System.out.println(ledger.entries());
        // [A -100, B +100]

        try {
            context.getBean(AccountService.class).transferAndFail("A", "B", 50);
        } catch (IllegalStateException e) {
            System.out.println("Failed: " + e.getMessage());
            // Failed: Payment provider unreachable
        }
        System.out.println(ledger.entries());
        // [A -100, B +100]  -- the failed transfer's two entries were rolled back

        context.close();
    }
}

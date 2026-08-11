import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

// Mini project: a small money-transfer service, reusing the same
// Ledger/LedgerTransactionManager infrastructure from earlier in this lesson,
// that ties together rollback rules, PROPAGATION_REQUIRED, and the
// self-invocation pitfall all at once -- the same account-transfer scenario
// used throughout this lesson, brought together into one realistic flow.
class InsufficientFundsException extends RuntimeException {
    InsufficientFundsException(String message) {
        super(message);
    }
}

@Service
class AccountRepository {
    private final Ledger ledger;

    AccountRepository(Ledger ledger) {
        this.ledger = ledger;
        // Opening balances, recorded as ledger entries just like any other change.
        ledger.add("A:+500");
        ledger.add("B:+100");
    }

    int balanceOf(String account) {
        int balance = 0;
        for (String entry : ledger.entries()) {
            String[] parts = entry.split(":");
            if (parts[0].equals(account)) {
                balance += Integer.parseInt(parts[1]);
            }
        }
        return balance;
    }

    @Transactional
    void debit(String account, int amount) {
        if (balanceOf(account) < amount) {
            // Unchecked -- rolls back automatically, no rollbackFor needed
            // (see "Rollback Kuralları" earlier in this lesson).
            throw new InsufficientFundsException(account + " has insufficient funds");
        }
        ledger.add(account + ":-" + amount);
    }

    @Transactional
    void credit(String account, int amount) {
        ledger.add(account + ":+" + amount);
    }
}

@Service
class MoneyTransferService {
    private final AccountRepository accountRepository;

    MoneyTransferService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    // Both debit(...) and credit(...) are PROPAGATION_REQUIRED (the default),
    // so they join this same transaction -- if credit(...) fails, the debit
    // that already ran joins the rollback too, instead of leaving money
    // vanished from account A.
    @Transactional
    void transfer(String from, String to, int amount) {
        accountRepository.debit(from, amount);
        accountRepository.credit(to, amount);
    }

    // Deliberately buggy: transferViaSelfInvocation is NOT @Transactional
    // itself, and calls transferInternal(...) through `this` -- exactly the
    // self-invocation pitfall from earlier in this lesson. @Transactional on
    // transferInternal has no effect when reached this way.
    void transferViaSelfInvocation(String from, String to, int amount) {
        transferInternal(from, to, amount);
    }

    @Transactional
    void transferInternal(String from, String to, int amount) {
        accountRepository.debit(from, amount);
        accountRepository.credit(to, amount);
        throw new IllegalStateException("Simulated failure after both writes");
    }
}

@Configuration
@EnableTransactionManagement
@ComponentScan
class MoneyTransferConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }
}

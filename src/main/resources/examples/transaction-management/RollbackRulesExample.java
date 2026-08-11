import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

// Spring's default rollback rule: unchecked exceptions (RuntimeException and
// its subclasses, plus Error) trigger a rollback; checked exceptions do NOT,
// unless you explicitly say otherwise with rollbackFor.
@Service
class ReportService {

    private final Ledger ledger;

    ReportService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional
    void writeThenThrowUnchecked() {
        ledger.add("report-draft");
        throw new IllegalStateException("Unchecked -- rolls back by default");
    }

    @Transactional
    void writeThenThrowChecked() throws IOException {
        ledger.add("report-draft");
        throw new IOException("Checked -- does NOT roll back by default");
    }

    @Transactional(rollbackFor = IOException.class)
    void writeThenThrowCheckedWithRollbackFor() throws IOException {
        ledger.add("report-draft");
        throw new IOException("Checked, but rollbackFor makes it roll back anyway");
    }
}

@Configuration
@EnableTransactionManagement
class ReportConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    ReportService reportService(Ledger ledger) {
        return new ReportService(ledger);
    }
}

class RollbackRulesExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(ReportConfig.class);
        Ledger ledger = context.getBean(Ledger.class);
        ReportService service = context.getBean(ReportService.class);

        try {
            service.writeThenThrowUnchecked();
        } catch (IllegalStateException e) {
            System.out.println(ledger.entries());
            // []  -- rolled back, the unchecked exception undid the write
        }

        try {
            service.writeThenThrowChecked();
        } catch (IOException e) {
            System.out.println(ledger.entries());
            // [report-draft]  -- NOT rolled back, checked exceptions commit by
            // default even though an exception was thrown
        }

        try {
            service.writeThenThrowCheckedWithRollbackFor();
        } catch (IOException e) {
            System.out.println(ledger.entries());
            // [report-draft]  -- still just the one entry committed by the
            // previous call; rollbackFor rolled this call's own write back, so
            // it was never added a second time
        }

        context.close();
    }
}

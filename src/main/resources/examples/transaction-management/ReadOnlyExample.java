import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

// readOnly = true is a HINT, not an enforced restriction at the Spring level --
// real transaction managers (JpaTransactionManager, for example) use it to
// apply optimizations (like skipping Hibernate's dirty-checking flush), and
// some database drivers use it to route reads to a replica -- but nothing in
// the @Transactional contract itself stops a readOnly transaction from
// writing.
@Service
class ReportingService {
    private final Ledger ledger;

    ReportingService(Ledger ledger) {
        this.ledger = ledger;
    }

    @Transactional(readOnly = true)
    List<String> generateReport() {
        return ledger.entries();
    }

    // This compiles and runs just fine, even though it's marked readOnly --
    // our simple LedgerTransactionManager (like most real ones) does not
    // reject writes just because readOnly = true was set.
    @Transactional(readOnly = true)
    void generateReportAndSneakilyWrite() {
        ledger.add("this should not really happen, but nothing stops it");
    }
}

@Configuration
@EnableTransactionManagement
class ReportingConfig {

    @Bean
    Ledger ledger() {
        return new Ledger();
    }

    @Bean
    PlatformTransactionManager transactionManager(Ledger ledger) {
        return new LedgerTransactionManager(ledger);
    }

    @Bean
    ReportingService reportingService(Ledger ledger) {
        return new ReportingService(ledger);
    }
}

class ReadOnlyExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(ReportingConfig.class);
        ReportingService service = context.getBean(ReportingService.class);

        service.generateReportAndSneakilyWrite();
        System.out.println(service.generateReport());
        // [this should not really happen, but nothing stops it]

        context.close();
    }
}

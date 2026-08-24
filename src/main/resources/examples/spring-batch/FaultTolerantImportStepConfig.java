import org.springframework.batch.core.Step;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.TransientDataAccessException;
import org.springframework.transaction.PlatformTransactionManager;

record Order(String orderId, String customerId, java.math.BigDecimal amount) {
}

class InvalidOrderException extends RuntimeException {
    InvalidOrderException(String message) {
        super(message);
    }
}

// The SAME importStep from "A Minimal, Complete Job Configuration", with
// fault tolerance added -- faultTolerant() switches on Spring Batch's
// skip/retry machinery for this step, which is OFF by default.
@Configuration
class FaultTolerantImportStepConfig {

    @Bean
    public Step importStep(JobRepository jobRepository,
                            PlatformTransactionManager transactionManager,
                            ItemReader<Order> orderItemReader,
                            ItemProcessor<Order, Order> orderItemProcessor,
                            ItemWriter<Order> orderItemWriter) {

        return new StepBuilder("importStep", jobRepository)
                .<Order, Order>chunk(100, transactionManager)
                .reader(orderItemReader)
                .processor(orderItemProcessor)
                .writer(orderItemWriter)
                .faultTolerant()
                // A genuinely malformed row (a missing customerId, say)
                // throws InvalidOrderException instead of being silently
                // filtered the way a negative amount is -- skip() lets the
                // STEP continue past it instead of failing the entire job,
                // up to 10 such rows.
                .skip(InvalidOrderException.class)
                .skipLimit(10)
                // A database hiccup is often TEMPORARY -- retry() tries the
                // same write again (up to 3 times) before giving up,
                // instead of treating a transient failure as permanent.
                .retry(TransientDataAccessException.class)
                .retryLimit(3)
                .build();
    }
}

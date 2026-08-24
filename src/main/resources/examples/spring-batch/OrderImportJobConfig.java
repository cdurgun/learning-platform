import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.ItemWriter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

record Order(String orderId, String customerId, java.math.BigDecimal amount) {
}

// The two building blocks every Spring Batch job needs: a Job (the whole
// process) built from one or more Steps (a phase of that process). Both
// builders require a JobRepository -- Spring Batch's own store for
// execution state, covered later in this lesson -- because every Job and
// Step it creates is TRACKED there from the moment it runs, not just
// executed and forgotten.
@Configuration
class OrderImportJobConfig {

    @Bean
    public Job orderImportJob(JobRepository jobRepository, Step importStep) {
        return new JobBuilder("orderImportJob", jobRepository)
                .start(importStep)
                .build();
    }

    // chunk(100, transactionManager) is what makes this step CHUNK-ORIENTED:
    // reader/processor/writer are wired together here, and Spring Batch
    // itself drives the read-process-write loop between them in groups of
    // 100 -- see "Chunk Processing" for exactly what that means.
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
                .build();
    }
}

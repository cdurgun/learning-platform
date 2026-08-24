import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.database.JdbcBatchItemWriter;
import org.springframework.batch.item.database.builder.JdbcBatchItemWriterBuilder;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.builder.FlatFileItemReaderBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.sql.DataSource;
import java.math.BigDecimal;

record Order(String orderId, String customerId, BigDecimal amount) {
}

// The three pieces a chunk-oriented step actually drives: read one Order
// at a time from orders.csv, optionally transform/validate it, then write
// it. Spring Batch calls these in a loop -- reader.read() repeatedly until
// the chunk size is reached, processor.process() on each item, then a
// SINGLE writer.write(...) call for the whole chunk -- see "Chunk
// Processing" for why that grouping matters.
@Configuration
class OrderImportComponents {

    @Bean
    public FlatFileItemReader<Order> orderItemReader() {
        return new FlatFileItemReaderBuilder<Order>()
                .name("orderItemReader")
                .resource(new ClassPathResource("orders.csv"))
                .linesToSkip(1) // skip the CSV header row (orderId,customerId,amount)
                .delimited()
                .names("orderId", "customerId", "amount")
                .fieldSetMapper(fieldSet -> new Order(
                        fieldSet.readString("orderId"),
                        fieldSet.readString("customerId"),
                        fieldSet.readBigDecimal("amount")))
                .build();
    }

    // Returning null here is a deliberate Spring Batch convention: it
    // means "filter this item out." A filtered item is silently dropped
    // and never reaches the writer -- this is NOT an error and does not
    // fail the step, unlike the validation failures covered later in
    // "Fault Tolerance: Skip and Retry."
    @Bean
    public ItemProcessor<Order, Order> orderItemProcessor() {
        return order -> {
            if (order.amount().signum() < 0) {
                return null; // filtered out: a negative amount is not written, not an error
            }
            return order;
        };
    }

    @Bean
    public JdbcBatchItemWriter<Order> orderItemWriter(DataSource dataSource) {
        return new JdbcBatchItemWriterBuilder<Order>()
                .dataSource(dataSource)
                .sql("INSERT INTO orders (order_id, customer_id, amount) VALUES (:orderId, :customerId, :amount)")
                .beanMapped()
                .build();
    }
}

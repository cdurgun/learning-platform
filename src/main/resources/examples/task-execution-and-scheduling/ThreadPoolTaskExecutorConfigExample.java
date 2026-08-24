import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

// ThreadPoolTaskExecutor is Spring's own wrapper around the same
// java.util.concurrent thread pool machinery covered in "Threads" --
// under the hood it manages a real ExecutorService, but exposes it as a
// Spring bean with property-style configuration instead of the builder
// methods used there.
@Configuration
class TaskExecutorConfig {

    @Bean
    ThreadPoolTaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(4);      // threads kept alive even when idle
        executor.setMaxPoolSize(8);       // ceiling the pool can grow to under load
        executor.setQueueCapacity(50);    // tasks queued once corePoolSize is busy
        executor.setThreadNamePrefix("app-task-");
        executor.initialize();
        return executor;
    }
}

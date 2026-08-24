import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;

// A critical, easy-to-miss detail: by DEFAULT, Spring runs every single
// @Scheduled method on ONE shared thread -- if syncWithExternalSystem()
// from ScheduledFixedRateDelayExample takes 20 seconds, purgeExpiredSessions()
// from ScheduledCronExample simply waits, even though its own cron time
// already arrived. This has nothing to do with the @Async TaskExecutor
// configured elsewhere -- @Scheduled uses a completely separate
// TaskScheduler, which needs its OWN pool configured if multiple
// scheduled methods genuinely need to run at once.
@Configuration
@EnableScheduling
class SchedulingConfig implements SchedulingConfigurer {

    @Bean
    ThreadPoolTaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(5); // now up to 5 @Scheduled methods can run concurrently
        scheduler.setThreadNamePrefix("scheduled-task-");
        scheduler.initialize();
        return scheduler;
    }

    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        taskRegistrar.setTaskScheduler(taskScheduler());
    }
}

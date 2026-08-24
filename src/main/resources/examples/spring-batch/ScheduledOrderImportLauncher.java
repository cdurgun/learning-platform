import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

// @Scheduled decides WHEN this runs; everything after that line is Spring
// Batch deciding HOW the actual import is executed, tracked, and (if
// needed) restarted -- "Task Execution & Scheduling" and this lesson
// working together, each doing only the job it's actually responsible for.
@Component
class NightlyOrderImportScheduler {

    private final JobLauncher jobLauncher;
    private final Job orderImportJob;

    NightlyOrderImportScheduler(JobLauncher jobLauncher, Job orderImportJob) {
        this.jobLauncher = jobLauncher;
        this.orderImportJob = orderImportJob;
    }

    @Scheduled(cron = "0 0 2 * * *")
    public void launchNightlyImport() throws Exception {
        // JobParameters identify THIS run -- "file" says which CSV to
        // read, "businessDate" says which day's import this is. Together
        // with the Job itself, these parameters are what Spring Batch uses
        // to tell one logical run apart from another -- see "JobParameters,
        // JobInstance, and JobExecution".
        JobParameters jobParameters = new JobParametersBuilder()
                .addString("file", "orders.csv")
                .addLocalDate("businessDate", LocalDate.now())
                .toJobParameters();

        jobLauncher.run(orderImportJob, jobParameters);
    }
}

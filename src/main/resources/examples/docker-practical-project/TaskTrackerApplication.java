import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// A complete, minimal Spring Boot + PostgreSQL application -- everything
// this lesson's Dockerfile and docker-compose.yml actually run. In a real
// project, Task/TaskRepository/TaskController would each live in their own
// file; they're combined here into one compilable teaching example, the
// same convention this course's other multi-class examples already use.
@SpringBootApplication
public class TaskTrackerApplication {

    public static void main(String[] args) {
        SpringApplication.run(TaskTrackerApplication.class, args);
    }

    @Entity
    static class Task {
        @Id
        @GeneratedValue
        private Long id;
        private String title;
        private boolean done;

        public Long getId() {
            return id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public boolean isDone() {
            return done;
        }

        public void setDone(boolean done) {
            this.done = done;
        }
    }

    interface TaskRepository extends JpaRepository<Task, Long> {
    }

    @RestController
    static class TaskController {

        private final TaskRepository taskRepository;

        TaskController(TaskRepository taskRepository) {
            this.taskRepository = taskRepository;
        }

        @GetMapping("/tasks")
        List<Task> listTasks() {
            return taskRepository.findAll();
        }

        @PostMapping("/tasks")
        Task createTask(@RequestBody Task task) {
            return taskRepository.save(task);
        }
    }
}

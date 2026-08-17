import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// The entry point of a single, independent microservice -- order-service. This class is
// structurally identical to this project's own LearningPlatformApplication (see the Spring
// MVC Fundamentals lesson's "Embedded Tomcat and spring-boot-starter-web" section) --
// @SpringBootApplication still triggers the exact same component scanning and
// auto-configuration covered in the Spring Core category. Nothing in THIS class is what
// makes it a microservice; what does is that this JAR is built, deployed, and run
// completely independently of any other service (see the Microservices Fundamentals
// lesson's "The Anatomy of a Microservice" section).
@SpringBootApplication
public class OrderServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrderServiceApplication.class, args);
    }
}

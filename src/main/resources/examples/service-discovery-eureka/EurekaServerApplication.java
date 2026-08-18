import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

// A THIRD Spring Boot application in this course, next to order-service and
// inventory-service -- but this one isn't a business microservice at all. It's the
// central registry (see "Eureka Server: A Central Registry") that order-service and
// inventory-service will register themselves with, and look each other up through.
//
// @EnableEurekaServer is the ONLY thing that makes this a Eureka server -- everything
// else (dependency: spring-cloud-starter-netflix-eureka-server, its own
// EurekaServerConfig.yml) is standard Spring Boot, exactly like order-service's own
// @SpringBootApplication entry point (see the Spring Boot Microservice Basics lesson's
// "A Microservice's Entry Point: @SpringBootApplication" section).
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServerApplication.class, args);
    }
}

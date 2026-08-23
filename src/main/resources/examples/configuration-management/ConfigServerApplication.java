import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.config.server.EnableConfigServer;

// A FIFTH Spring Boot application in this course, next to order-service,
// inventory-service, eureka-server, and api-gateway -- config-server, like
// eureka-server, is pure infrastructure: no business logic, no domain database.
// Its only job is serving CONFIGURATION files to every other service in the
// system (see "Setting Up a Config Server").
//
// @EnableConfigServer is the ONE annotation that turns a plain Spring Boot app
// into a Config Server -- exactly the same shape as @EnableEurekaServer on
// EurekaServerApplication (see the Service Discovery & Eureka lesson's "Eureka
// Server: A Central Registry" section).
@SpringBootApplication
@EnableConfigServer
public class ConfigServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigServerApplication.class, args);
    }
}

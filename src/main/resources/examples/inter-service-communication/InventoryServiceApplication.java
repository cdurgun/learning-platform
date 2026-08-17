import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// The second microservice this course builds -- inventory-service. Structurally identical
// to order-service's own entry point (see Spring Boot Microservice Basics' "A
// Microservice's Entry Point" section) -- what makes the two DIFFERENT services isn't this
// class, it's that each is built, deployed, and run as its own independent JAR, with its
// own application.yml (see InventoryServiceConfig.yml) and its own port.
@SpringBootApplication
public class InventoryServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(InventoryServiceApplication.class, args);
    }
}

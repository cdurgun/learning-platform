import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// A FOURTH Spring Boot application in this course, next to order-service,
// inventory-service, and eureka-server -- but api-gateway isn't a business
// microservice OR a registry. It's the SINGLE entry point external clients (a
// browser, a mobile app) talk to (see "What Is an API Gateway?") -- it never
// contains business logic of its own, it only ROUTES requests to the right
// internal service.
//
// No special annotation is needed here, unlike @EnableEurekaServer on
// EurekaServerApplication (see the Service Discovery & Eureka lesson's "Eureka
// Server: A Central Registry" section) -- adding the
// spring-cloud-starter-gateway dependency is what turns a plain Spring Boot app
// into a gateway; routing itself is configured, not annotated (see "Route
// Configuration: Predicates and Filters").
@SpringBootApplication
public class ApiGatewayApplication {
    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
    }
}

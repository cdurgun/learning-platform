import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Component;

// Micrometer is the metrics FACADE Spring Boot Actuator is built on -- the same
// relationship SLF4J has to a logging implementation (see the Spring Boot
// Microservice Basics lesson's "Logging and Correlation" section). A
// MeterRegistry bean is autoconfigured automatically once
// spring-boot-starter-actuator is on the classpath, with no extra setup needed
// beyond ActuatorMetricsConfig.yml's exposure settings.
//
// OrderService.create(...) (see the Spring Boot Microservice Basics lesson)
// would call recordOrderPlaced() right alongside publishing OrderPlacedEvent
// (see the Event-Driven Architecture & Kafka lesson) -- a metric and an event
// about the SAME fact, serving different purposes: the event drives the saga,
// the metric drives dashboards and alerts.
@Component
class OrderMetrics {

    private final Counter ordersPlacedCounter;

    OrderMetrics(MeterRegistry meterRegistry) {
        this.ordersPlacedCounter = Counter.builder("orders.placed")
                .description("Number of orders successfully placed")
                .register(meterRegistry);
    }

    void recordOrderPlaced() {
        ordersPlacedCounter.increment();
    }
}

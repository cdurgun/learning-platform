import io.github.resilience4j.circuitbreaker.CircuitBreaker;
import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

// The circuit breaker's STATE (see "Circuit Breaker: States and Configuration") isn't
// directly visible anywhere in ResilientStockClient -- @CircuitBreaker manages it behind
// the scenes. This class subscribes to the SAME "inventoryService" instance's state
// transitions, purely to make CLOSED -> OPEN -> HALF_OPEN -> CLOSED visible in the logs
// -- useful while learning, and a real precursor to the metrics/dashboards the
// Observability lesson covers later.
@Component
class CircuitBreakerEventListener {

    private static final Logger log = LoggerFactory.getLogger(CircuitBreakerEventListener.class);

    private final CircuitBreakerRegistry circuitBreakerRegistry;

    CircuitBreakerEventListener(CircuitBreakerRegistry circuitBreakerRegistry) {
        this.circuitBreakerRegistry = circuitBreakerRegistry;
    }

    @PostConstruct
    void subscribeToStateTransitions() {
        CircuitBreaker inventoryServiceBreaker = circuitBreakerRegistry.circuitBreaker("inventoryService");
        inventoryServiceBreaker.getEventPublisher()
                .onStateTransition(event ->
                        log.warn("inventoryService circuit breaker: {} -> {}",
                                event.getStateTransition().getFromState(),
                                event.getStateTransition().getToState()));
    }
}

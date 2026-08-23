import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

// inventory-service's reaction to OrderPlacedEvent -- @KafkaListener is spring-
// kafka's equivalent of @GetMapping/@PostMapping for events instead of HTTP
// requests: Spring calls this method automatically whenever a new message arrives
// on "order-events" for this consumer group (see KafkaConsumerConfig.yml).
//
// An in-memory Set stands in for a real "processed order ids" table here, the
// same simplification OrderService.java's in-memory Map makes for orders
// themselves (see the Spring Boot Microservice Basics lesson) -- a real
// deployment would back this with the service's own database.
@Component
class InventoryEventListener {

    // Guards against processing the SAME event twice (see "At-Least-Once
    // Delivery and Idempotency") -- Kafka can redeliver a message inventory-
    // service already handled, most commonly after a restart before an offset
    // was committed.
    private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

    @KafkaListener(topics = "order-events", groupId = "inventory-service")
    void onOrderPlaced(OrderPlacedEvent event) {
        if (!processedOrderIds.add(event.orderId())) {
            // add(...) returns false if this orderId was ALREADY in the set --
            // this is the SAME order being redelivered, not a new one. Reducing
            // stock a SECOND time for it would silently corrupt inventory counts.
            return;
        }

        // In a real deployment, this would decrement a real stock count in
        // inventory-service's own database, using event.productName() and
        // event.quantity() -- kept as a comment here since the point of this
        // lesson is the EVENT FLOW itself, not inventory-service's persistence
        // layer (already covered conceptually in the Microservices Fundamentals
        // lesson's "Database per Service" section).
        // stockRepository.decrease(event.productName(), event.quantity());
    }
}

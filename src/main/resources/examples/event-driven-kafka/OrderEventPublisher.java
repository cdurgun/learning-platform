import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

// order-service's ONLY new piece for publishing events -- OrderService.create(...)
// (see the Spring Boot Microservice Basics lesson) would call
// publish(order) right after saving a new Order, alongside (NOT instead of) its
// existing synchronous checkStock call to inventory-service (see "Synchronous vs.
// Asynchronous: When to Use Which" for why BOTH can coexist for the same order).
//
// KafkaTemplate is spring-kafka's equivalent of RestClient for synchronous calls --
// a thin, autoconfigured wrapper around the underlying Kafka producer client.
@Component
class OrderEventPublisher {

    private static final String TOPIC = "order-events";

    private final KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate;

    OrderEventPublisher(KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    void publishOrderPlaced(String orderId, String productName, int quantity) {
        OrderPlacedEvent event = new OrderPlacedEvent(orderId, productName, quantity);
        // The KEY (orderId here) determines which Kafka PARTITION a message lands
        // in -- messages with the SAME key always go to the SAME partition, and
        // Kafka guarantees ORDER only within a single partition. Keying by orderId
        // means every event about the SAME order is processed in order, even
        // though DIFFERENT orders may be processed out of order relative to each
        // other (a deliberate, common tradeoff -- see "Setting Up Kafka (Broker)
        // and Topics").
        kafkaTemplate.send(TOPIC, orderId, event);
        // send(...) returns a CompletableFuture and does NOT block waiting for
        // Kafka to confirm -- this call returns almost immediately, unlike every
        // synchronous RestClient call in this course so far.
    }
}

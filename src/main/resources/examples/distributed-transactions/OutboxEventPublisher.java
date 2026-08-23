import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

// The OUTBOX pattern, illustrated conceptually (see "The Outbox Pattern: Not
// Losing an Event to a Crash") -- a real implementation needs its own database
// table and a JPA repository; this example uses an in-memory Map the same way
// OrderService.java's own persistence is simplified (see the Spring Boot
// Microservice Basics lesson), to keep the focus on the PATTERN'S shape rather
// than JPA plumbing already covered elsewhere in this course.
//
// The problem this solves: OrderEventPublisher (see the Event-Driven
// Architecture & Kafka lesson) publishes to Kafka SEPARATELY from
// OrderService.create(...) saving the order to its database -- if order-
// service crashes between those two steps, the order exists but the event
// publishing it never happened, and nothing else in the system ever finds out
// an order was placed. The outbox pattern closes that gap by writing the EVENT
// to the SAME local database, in the SAME @Transactional method that saves the
// order -- so either both happen or neither does, using a guarantee order-
// service's own database already gives for free (see the Transaction
// Management lesson).
@Component
class OutboxEventPublisher {

    private final Map<String, OrderPlacedEvent> unpublishedEvents = new ConcurrentHashMap<>();
    private final KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate;

    OutboxEventPublisher(KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    // Called from INSIDE the same @Transactional method that saves the order
    // itself -- writing to "unpublishedEvents" here is really an INSERT into
    // an outbox TABLE in the real pattern, part of the SAME database
    // transaction, not a separate call to Kafka.
    @Transactional
    void saveForPublishing(OrderPlacedEvent event) {
        unpublishedEvents.put(event.orderId(), event);
    }

    // A SEPARATE process, running on its own schedule, that actually talks to
    // Kafka -- decoupled from the request that created the order. If this
    // fails partway through (Kafka is briefly unreachable), the event stays in
    // the outbox and gets retried on the NEXT scheduled run -- nothing is lost,
    // because publishing was never tied to the original request's own success
    // or failure.
    @Scheduled(fixedDelay = 5000)
    void publishPendingEvents() {
        List<String> orderIds = List.copyOf(unpublishedEvents.keySet());
        for (String orderId : orderIds) {
            OrderPlacedEvent event = unpublishedEvents.get(orderId);
            kafkaTemplate.send("order-events", orderId, event);
            unpublishedEvents.remove(orderId);
        }
    }
}

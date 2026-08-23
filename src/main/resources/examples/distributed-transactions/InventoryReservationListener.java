import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

// inventory-service's saga PARTICIPANT step -- its LOCAL transaction (reserving
// stock in its own database) followed by ONE of two possible outcomes announced
// back onto Kafka. This replaces the InventoryEventListener from the Event-
// Driven Architecture & Kafka lesson, which only ever succeeded silently -- a
// saga needs the FAILURE path to be just as visible as the success path (see
// "Choreography: Order Placement as a Saga").
@Component
class InventoryReservationListener {

    private static final String STOCK_RESERVATION_FAILED_TOPIC = "stock-reservation-failed";

    private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();
    private final KafkaTemplate<String, StockReservationFailedEvent> kafkaTemplate;

    InventoryReservationListener(KafkaTemplate<String, StockReservationFailedEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    @KafkaListener(topics = "order-events", groupId = "inventory-service")
    void onOrderPlaced(OrderPlacedEvent event) {
        if (!processedOrderIds.add(event.orderId())) {
            return;   // same idempotency guard as the Event-Driven Architecture &
                      // Kafka lesson's InventoryEventListener -- unchanged reasoning
        }

        // inventory-service's LOCAL transaction: check and reserve stock in ITS
        // OWN database, and ITS OWN database only -- this never reaches across
        // into order-service's database, which is exactly what "distributed"
        // means here (see "What Are Distributed Transactions?").
        boolean reserved = tryReserveStock(event.productName(), event.quantity());

        if (!reserved) {
            // The COMPENSATION trigger -- inventory-service can't undo an order
            // it never created, so instead it tells order-service (the service
            // that CAN undo it) that this step of the saga failed.
            kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(),
                    new StockReservationFailedEvent(event.orderId(), event.productName(), "insufficient stock"));
        }
        // If reserved == true, nothing further is published here -- silence IS
        // the success signal in this simple two-step saga. A longer saga (more
        // participants) would typically publish an explicit "stock reserved"
        // event of its own for the next step to react to.
    }

    private boolean tryReserveStock(String productName, int quantity) {
        // Stands in for a real, ATOMIC "check and decrement" against inventory-
        // service's own database (see the Microservices Fundamentals lesson's
        // "Database per Service" section) -- kept as a comment since the point
        // of this lesson is the SAGA FLOW around this call, not inventory-
        // service's persistence layer.
        // return stockRepository.tryReserve(productName, quantity);
        return true;
    }
}

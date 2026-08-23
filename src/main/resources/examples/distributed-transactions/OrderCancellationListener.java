import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

// order-service's COMPENSATING step -- the other half of the saga started in
// InventoryReservationListener. This is what makes the whole flow a saga
// rather than just "fire an event and hope": order-service's OWN local
// transaction (placing the order) already committed by the time this runs, so
// "undoing" it doesn't mean a database rollback -- it means a NEW, explicit
// local transaction that moves the order to CANCELLED (see "Compensating
// Actions: Undoing What Already Happened").
@Component
class OrderCancellationListener {

    private static final Logger log = LoggerFactory.getLogger(OrderCancellationListener.class);

    @KafkaListener(topics = "stock-reservation-failed", groupId = "order-service")
    void onStockReservationFailed(StockReservationFailedEvent event) {
        // A real deployment would load the order, check it's still PLACED (not
        // already CONFIRMED or CANCELLED -- see "Common Mistakes"), and move it
        // to CANCELLED inside order-service's own transaction. Kept as a
        // comment here for the same reason InventoryReservationListener's
        // tryReserveStock is -- this lesson focuses on the saga's SHAPE, not
        // re-deriving order-service's persistence layer.
        // orderService.cancel(event.orderId(), event.reason());
        log.warn("Order {} cancelled: {}", event.orderId(), event.reason());
    }
}

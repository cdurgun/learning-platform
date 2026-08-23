// A status order-service's Order (see the Spring Boot Microservice Basics
// lesson's Order.java) would need to track once a saga can fail partway
// through -- CONFIRMED once no compensation has arrived after a reasonable
// window, CANCELLED once OrderCancellationListener processes a
// StockReservationFailedEvent for it. Kept as a standalone type here (rather
// than rewriting Order.java itself) to keep this lesson focused on the SAGA
// FLOW, the same scoping choice InventoryReservationListener's tryReserveStock
// makes for inventory-service's own persistence.
enum OrderStatus {
    PLACED,
    CONFIRMED,
    CANCELLED
}

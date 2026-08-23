// The COMPENSATING event -- published by inventory-service back onto Kafka
// (see the Event-Driven Architecture & Kafka lesson) when it CANNOT honor an
// OrderPlacedEvent, most commonly because there isn't enough stock. This is
// what makes the saga (see "The Saga Pattern: A Sequence of Local Transactions")
// a two-way conversation instead of a one-way announcement -- order-service
// needs to hear back when the OTHER side of its local transaction didn't
// succeed, so it can undo what it already committed.
record StockReservationFailedEvent(String orderId, String productName, String reason) {
}

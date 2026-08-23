// Unchanged from the Service Discovery & Eureka lesson (itself unchanged from Inter-
// Service Communication) -- wrapping the call in a circuit breaker and retry doesn't
// change WHAT inventory-service tells order-service, only what happens when it CAN'T
// be reached at all.
record StockCheckResponse(String productName, int quantityInStock) {
}

// Unchanged from the Inter-Service Communication lesson -- discovering inventory-service
// by name doesn't change WHAT it tells order-service, only HOW order-service finds it to
// ask.
record StockCheckResponse(String productName, int quantityInStock) {
}

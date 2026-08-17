// order-service's OWN shape for "what inventory-service told us about a product" -- NOT the
// same class as inventory-service's InventoryItem. This lesson's two services don't share a
// single class, not even a DTO -- the field names happen to look similar here only because
// JSON keys have to match to deserialize; inventory-service is free to change InventoryItem
// internally without ever breaking this contract, exactly why a DTO is safer than
// deserializing straight into a shared/domain type (see the REST API Design lesson's "The
// DTO Pattern: Separating Request/Response with Records" section).
record StockCheckResponse(String productName, int quantityInStock) {
}

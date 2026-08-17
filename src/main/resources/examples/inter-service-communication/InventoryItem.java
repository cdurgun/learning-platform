// inventory-service's own view of "how much stock does a product have" -- deliberately NOT
// the same type as order-service's Order (see Spring Boot Microservice Basics' domain model
// section). Two services can both have an opinion about the same real-world product
// ("Keyboard") and model it completely differently, because each only needs to know what
// its OWN job requires.
record InventoryItem(String productName, int quantityInStock) {
}

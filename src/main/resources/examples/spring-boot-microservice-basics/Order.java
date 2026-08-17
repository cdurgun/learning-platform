// order-service's own view of what an "order" is -- just enough to satisfy THIS service's
// responsibility. If inventory-service or payment-service also had an "order"-shaped
// concept, they could model it completely differently (different fields, different rules)
// -- each service's model only has to make sense within its own bounded context, the idea
// covered in the Microservices Fundamentals lesson.
record Order(String id, String productName, int quantity) {
}

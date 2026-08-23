// The EVENT itself -- a fact about something that already happened ("an order WAS
// placed"), not a request asking another service to do something. This is the key
// difference from every synchronous call in this course so far (see the Inter-Service
// Communication lesson's StockClient): a REST call SAYS "check this for me, now, and
// tell me the answer"; an event SAYS "this happened, react to it if you care to, on
// your own time." order-service knows NOTHING about who (if anyone) is listening.
//
// Fields mirror order-service's own Order record (see the Spring Boot Microservice
// Basics lesson's Order.java) -- but this is a DELIBERATE, separate type, not the
// domain record itself: an event is a public CONTRACT other services depend on,
// while Order is order-service's own internal model, free to change independently
// (the same "your own contract" reasoning as StockCheckResponse, see the Inter-
// Service Communication lesson's "Your Own Contract: Why StockCheckResponse Instead
// of InventoryItem?" section).
record OrderPlacedEvent(String orderId, String productName, int quantity) {
}

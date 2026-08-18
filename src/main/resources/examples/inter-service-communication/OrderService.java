import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

// The same order-service, the same OrderController in front of it -- but now, before
// creating an order, it asks inventory-service whether enough stock exists. This one method
// is the whole lesson: a same-service business rule (quantity <= 0, already covered in
// Spring Boot Microservice Basics) sitting right next to a call to another service.
@Service
class OrderService {

    private final Map<String, Order> orders = new ConcurrentHashMap<>();
    private final StockClient stockClient;

    OrderService(StockClient stockClient) {
        this.stockClient = stockClient;
    }

    Order create(String productName, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("quantity must be positive");
        }
        // Unlike every other line in this method, this one is a network call -- it can be
        // slow, time out, or fail because a completely different process crashed (see the
        // Microservices Fundamentals lesson's "New Challenges Introduced by Distributed
        // Systems" section).
        StockCheckResponse stock = stockClient.checkStock(productName);
        if (stock.quantityInStock() < quantity) {
            throw new IllegalArgumentException("insufficient stock for " + productName);
        }
        String id = UUID.randomUUID().toString();
        Order order = new Order(id, productName, quantity);
        orders.put(id, order);
        return order;
    }

    Optional<Order> findById(String id) {
        return Optional.ofNullable(orders.get(id));
    }
}

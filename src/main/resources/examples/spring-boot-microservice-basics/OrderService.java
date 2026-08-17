import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

// order-service's business logic -- the only place that decides what a valid order looks
// like. A real deployment would back this with its own database (see OrderServiceConfig.yml
// and the Microservices Fundamentals lesson's "Database per Service" section); an
// in-memory map stands in for that here, so this example stays focused on the
// controller/service split rather than JPA/repository plumbing (already covered in the
// Spring MVC category's REST API Design topic).
@Service
class OrderService {

    private final Map<String, Order> orders = new ConcurrentHashMap<>();

    Order create(String productName, int quantity) {
        if (quantity <= 0) {
            throw new IllegalArgumentException("quantity must be positive");
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

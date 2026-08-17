import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

// inventory-service's business logic. A real deployment would back this with its own
// database (inventory_db, see InventoryServiceConfig.yml); a fixed in-memory map stands in
// for that here, the same simplification order-service's OrderService already made -- this
// lesson's focus is the CALL between the two services, not persistence.
@Service
class InventoryService {

    private final Map<String, Integer> stock = Map.of(
            "Keyboard", 42,
            "Monitor", 7,
            "Mouse", 0
    );

    Optional<InventoryItem> findByProductName(String productName) {
        Integer quantity = stock.get(productName);
        return quantity == null ? Optional.empty() : Optional.of(new InventoryItem(productName, quantity));
    }
}

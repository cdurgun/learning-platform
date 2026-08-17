import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

// inventory-service's ENTIRE external contract: one endpoint, read-only. Same
// Controller -> Service split as order-service's OrderController -- the controller makes no
// decisions, it just asks InventoryService and translates the answer into an HTTP response.
@RestController
@RequestMapping("/inventory")
class InventoryController {

    private final InventoryService inventoryService;

    InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping("/{productName}")
    ResponseEntity<InventoryItem> findByProductName(@PathVariable String productName) {
        return inventoryService.findByProductName(productName)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }
}

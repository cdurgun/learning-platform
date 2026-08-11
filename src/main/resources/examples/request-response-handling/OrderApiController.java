import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.LinkedHashMap;
import java.util.Map;

// An order-creation endpoint using every mechanism from this lesson: @RequestBody to
// read the order, manual validation (Bean Validation arrives in the next lesson) that
// throws a ResponseStatusException for bad input, and a ResponseEntity with a
// Location header and 201 Created for success.
@Controller
class OrderApiController {
    private final Map<Long, String> orders = new LinkedHashMap<>();
    private long nextId = 1;

    record CreateOrderRequest(String item, Integer quantity) {
    }

    @PostMapping("/api/orders")
    @ResponseBody
    public ResponseEntity<Void> create(@RequestBody CreateOrderRequest request) {
        if (request.item() == null || request.item().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "item is required");
        }
        if (request.quantity() == null || request.quantity() <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "quantity must be positive");
        }

        long id = nextId++;
        orders.put(id, request.quantity() + "x " + request.item());

        return ResponseEntity.created(URI.create("/api/orders/" + id)).build();
    }

    @GetMapping("/api/orders/{id}")
    @ResponseBody
    public ResponseEntity<String> getOne(@PathVariable Long id) {
        String order = orders.get(id);
        return order != null ? ResponseEntity.ok(order) : ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }
}

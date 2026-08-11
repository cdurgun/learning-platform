import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

// Mini project, part 1/2: combines the DTO pattern (a request/response shape
// separate from any entity) with IdempotencyKeyExample's mechanism, wired through a
// real @PostMapping/@RequestHeader/ResponseEntity -- the same building blocks from
// Request ve Response Handling, applied to this lesson's idempotency problem.
@RestController
class IdempotentOrderController {

    record CreateOrderRequest(String item) {
    }

    record OrderResponse(String orderId, String item) {
    }

    private final Map<String, OrderResponse> processedKeys = new ConcurrentHashMap<>();
    private int nextOrderNumber = 1;

    @PostMapping("/api/orders")
    public ResponseEntity<OrderResponse> createOrder(
            @RequestHeader("Idempotency-Key") String idempotencyKey,
            @RequestBody CreateOrderRequest request) {

        OrderResponse existing = processedKeys.get(idempotencyKey);
        if (existing != null) {
            return ResponseEntity.ok(existing); // already processed -- 200, not a new 201
        }

        OrderResponse created = new OrderResponse("order-" + nextOrderNumber++, request.item());
        processedKeys.put(idempotencyKey, created);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

// order-service's external "contract" -- everything another service or a client can ask
// order-service to do goes through these two endpoints, and nothing else. The controller
// itself makes no business decisions -- that's OrderService's job (see OrderService.java) --
// exactly the Controller -> Service split from the Spring MVC Fundamentals lesson's "The
// Journey of an HTTP Request: Request Lifecycle" section.
@RestController
@RequestMapping("/orders")
class OrderController {

    private final OrderService orderService;

    OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    ResponseEntity<Order> create(@RequestBody CreateOrderRequest request) {
        Order created = orderService.create(request.productName(), request.quantity());
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping("/{id}")
    ResponseEntity<Order> findById(@PathVariable String id) {
        return orderService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    record CreateOrderRequest(String productName, int quantity) {
    }
}

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

// A path can carry more than one variable -- each {placeholder} becomes its own
// method parameter, matched by name.
@Controller
class OrderItemController {

    @GetMapping("/users/{userId}/orders/{orderId}")
    @ResponseBody
    public String getOrder(@PathVariable Long userId, @PathVariable Long orderId) {
        return "Order #" + orderId + " belonging to user #" + userId;
    }
}

import org.springframework.http.ResponseEntity;
import org.springframework.web.server.ResponseStatusException;

class OrderApiDemo {
    public static void main(String[] args) {
        OrderApiController controller = new OrderApiController();

        ResponseEntity<Void> created = controller.create(new OrderApiController.CreateOrderRequest("Keyboard", 2));
        System.out.println(created.getStatusCode() + " Location=" + created.getHeaders().getLocation());
        // 201 CREATED Location=/api/orders/1

        System.out.println(controller.getOne(1L).getBody());
        // 2x Keyboard

        try {
            controller.create(new OrderApiController.CreateOrderRequest("Mouse", 0));
        } catch (ResponseStatusException e) {
            System.out.println(e.getStatusCode() + ": " + e.getReason());
            // 400 BAD_REQUEST: quantity must be positive
        }
    }
}

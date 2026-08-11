import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// Returning anything other than a String (a record, a List, a Map...) makes Spring hand
// it to Jackson, which serializes it to JSON and sets Content-Type: application/json
// automatically -- no manual serialization code anywhere.
@RestController
class ProductRestController {

    record Product(String name, double price) {
    }

    @GetMapping("/api/products/1")
    public Product getProduct() {
        return new Product("Keyboard", 49.90);
        // {"name":"Keyboard","price":49.9}
    }
}

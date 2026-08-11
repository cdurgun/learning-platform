import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

// Returning a plain object always sends 200 OK. ResponseEntity gives full control
// over the status code (and, as we'll see next, headers) alongside the body.
@Controller
class ProductLookupController {
    private final Map<Long, String> products = Map.of(1L, "Keyboard");

    @GetMapping("/products/{id}")
    @ResponseBody
    public ResponseEntity<String> getProduct(@PathVariable Long id) {
        String name = products.get(id);
        if (name == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(name);
    }
}

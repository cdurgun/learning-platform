import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.util.Map;

// @ExceptionHandler, on a method INSIDE a controller, catches exceptions thrown by
// any handler method in that SAME controller -- no manual try/catch needed in every
// method.
@Controller
class ProductController {
    private final Map<Long, String> products = Map.of(1L, "Keyboard");

    static class ProductNotFoundException extends RuntimeException {
        ProductNotFoundException(Long id) {
            super("Product not found: " + id);
        }
    }

    @GetMapping("/products/{id}")
    @ResponseBody
    public String getProduct(@PathVariable Long id) {
        String product = products.get(id);
        if (product == null) {
            throw new ProductNotFoundException(id);
        }
        return product;
    }

    @ExceptionHandler(ProductNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ResponseBody
    public String handleNotFound(ProductNotFoundException e) {
        return e.getMessage();
    }
}

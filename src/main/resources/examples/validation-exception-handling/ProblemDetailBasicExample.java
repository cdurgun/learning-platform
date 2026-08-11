import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

// ProblemDetail is Spring's built-in implementation of RFC 7807 -- a standardized,
// self-describing JSON error shape (Content-Type: application/problem+json), instead
// of every team inventing its own ad hoc error object.
@Controller
class ProductLookupController {

    static class ProductNotFoundException extends RuntimeException {
        ProductNotFoundException(Long id) {
            super("Product not found: " + id);
        }
    }

    @GetMapping("/products/{id}")
    public String getProduct(@PathVariable Long id) {
        throw new ProductNotFoundException(id);
    }

    @ExceptionHandler(ProductNotFoundException.class)
    public ProblemDetail handleNotFound(ProductNotFoundException e) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, e.getMessage());
    }
}

class ProblemDetailBasicExample {
    public static void main(String[] args) {
        ProductLookupController controller = new ProductLookupController();

        try {
            controller.getProduct(7L);
        } catch (ProductLookupController.ProductNotFoundException e) {
            ProblemDetail problem = controller.handleNotFound(e);
            System.out.println(problem.getStatus() + " " + problem.getTitle() + ": " + problem.getDetail());
            // 404 Not Found: Product not found: 7
        }
    }
}

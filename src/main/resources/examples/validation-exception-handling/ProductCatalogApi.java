import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.LinkedHashMap;
import java.util.Map;

// A small, complete slice of a real API: Bean Validation guards the input, a
// controller-level exception signals a missing resource, and a SEPARATE
// @RestControllerAdvice turns that exception into a standard ProblemDetail --
// exactly the two mechanisms from this lesson, working together.
@Controller
class ProductCatalogController {

    record CreateProductRequest(@NotBlank String name, @Min(1) int quantity) {
    }

    static class ProductNotFoundException extends RuntimeException {
        ProductNotFoundException(Long id) {
            super("Product not found: " + id);
        }
    }

    private final Map<Long, String> products = new LinkedHashMap<>();
    private long nextId = 1;

    @PostMapping("/products")
    @ResponseBody
    public Long create(@Valid @RequestBody CreateProductRequest request) {
        long id = nextId++;
        products.put(id, request.name());
        return id;
    }

    @GetMapping("/products/{id}")
    @ResponseBody
    public String getOne(@PathVariable Long id) {
        String product = products.get(id);
        if (product == null) {
            throw new ProductNotFoundException(id);
        }
        return product;
    }
}

@RestControllerAdvice
class ProductCatalogExceptionHandler {

    @ExceptionHandler(ProductCatalogController.ProductNotFoundException.class)
    public ProblemDetail handleNotFound(ProductCatalogController.ProductNotFoundException e) {
        return ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, e.getMessage());
    }
}

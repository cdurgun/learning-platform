import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import org.springframework.http.ProblemDetail;

import java.util.Set;

// Exercises ProductCatalogApi end to end: a valid create+read, an invalid create
// (rejected before it would ever reach the controller), and a lookup that fails
// inside the controller and is handled by the separate advice class.
class ProductCatalogApiDemo {
    public static void main(String[] args) {
        ProductCatalogController controller = new ProductCatalogController();
        ProductCatalogExceptionHandler advice = new ProductCatalogExceptionHandler();
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        var validRequest = new ProductCatalogController.CreateProductRequest("Keyboard", 10);
        Long id = controller.create(validRequest);
        System.out.println("Created id: " + id);
        // Created id: 1
        System.out.println(controller.getOne(id));
        // Keyboard

        var invalidRequest = new ProductCatalogController.CreateProductRequest("", 10);
        Set<ConstraintViolation<ProductCatalogController.CreateProductRequest>> violations =
                validator.validate(invalidRequest);
        System.out.println("Violations: " + violations.size());
        // Violations: 1

        try {
            controller.getOne(99L);
        } catch (ProductCatalogController.ProductNotFoundException e) {
            ProblemDetail problem = advice.handleNotFound(e);
            System.out.println(problem.getStatus() + " " + problem.getDetail());
            // 404 Product not found: 99
        }
    }
}

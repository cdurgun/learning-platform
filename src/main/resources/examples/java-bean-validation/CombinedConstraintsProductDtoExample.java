import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.LocalDate;

// A single, realistic DTO combining constraints from Spring MVC's
// "Validation & Exception Handling" (@NotBlank, @Size) with the ones
// covered so far in this lesson (@Positive, @DecimalMin, @Digits,
// @Future) -- exactly how a real product-creation endpoint would look.
// @Valid on the controller parameter works the same way covered there:
// every constraint below runs before create(...)'s body executes.
@RestController
class ProductController {

    record CreateProductRequest(
            @NotBlank @Size(max = 100) String name,
            @Positive int stockQuantity,
            @DecimalMin("0.01") @Digits(integer = 6, fraction = 2) BigDecimal price,
            @Future LocalDate availableFrom) {
    }

    @PostMapping("/products")
    @ResponseBody
    public String create(@Valid @RequestBody CreateProductRequest request) {
        return "Created: " + request.name();
    }
}

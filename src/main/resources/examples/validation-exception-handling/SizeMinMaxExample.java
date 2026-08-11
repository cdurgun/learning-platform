import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

// @Size checks a String/Collection/array's length; @Min/@Max check a numeric value's
// bounds -- both boundaries are inclusive.
class SizeMinMaxExample {

    record CreateProductRequest(
            @Size(min = 3, max = 50) String name,
            @Min(1) @Max(1000) int quantity) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(new CreateProductRequest("ab", 5)).size());
        // 1 -- "ab" is shorter than the 3-character minimum

        System.out.println(validator.validate(new CreateProductRequest("Keyboard", 0)).size());
        // 1 -- 0 is below the minimum of 1

        System.out.println(validator.validate(new CreateProductRequest("Keyboard", 2000)).size());
        // 1 -- 2000 is above the maximum of 1000

        System.out.println(validator.validate(new CreateProductRequest("Keyboard", 5)).size());
        // 0 -- within every bound
    }
}

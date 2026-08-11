import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;

import java.util.Set;
import java.util.stream.Collectors;

// When real Spring MVC's @Valid fails on a @RequestBody, it throws
// MethodArgumentNotValidException; a @RestControllerAdvice typically catches that
// (reading its BindingResult) instead of a raw ConstraintViolation set like this one
// -- but the conversion logic is identical either way: turn each violation into a
// readable message and attach them to the ProblemDetail as a custom property.
class ProblemDetailValidationExample {

    record CreateProductRequest(@NotBlank String name, @Min(1) int quantity) {
    }

    static <T> ProblemDetail toProblemDetail(Set<ConstraintViolation<T>> violations) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
        problem.setProperty("errors", violations.stream()
                .map(v -> v.getPropertyPath() + ": " + v.getMessage())
                .collect(Collectors.toList()));
        return problem;
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        // Only "name" is invalid, so there's exactly one, predictable violation.
        CreateProductRequest invalid = new CreateProductRequest("", 5);
        Set<ConstraintViolation<CreateProductRequest>> violations = validator.validate(invalid);

        ProblemDetail problem = toProblemDetail(violations);
        System.out.println(problem.getStatus() + " " + problem.getDetail());
        // 400 Validation failed
        System.out.println(problem.getProperties());
        // {errors=[name: must not be blank]}
    }
}

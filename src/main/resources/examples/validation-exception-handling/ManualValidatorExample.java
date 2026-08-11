import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.util.Set;

// @Valid doesn't invent a new validation engine -- it triggers exactly this: a
// jakarta.validation.Validator (the same interface regardless of framework) checks
// every constraint annotation on the object and returns a set of violations. When
// @Valid fails on a @RequestBody, Spring wraps this same result in a
// MethodArgumentNotValidException (carrying a BindingResult) instead of returning it
// to you directly -- the underlying check is identical to what's shown here.
class ManualValidatorExample {

    record CreateUserRequest(@NotBlank String name, @Email String email) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        CreateUserRequest invalid = new CreateUserRequest("", "not-an-email");
        Set<ConstraintViolation<CreateUserRequest>> violations = validator.validate(invalid);
        System.out.println("Violation count: " + violations.size());
        // Violation count: 2

        CreateUserRequest valid = new CreateUserRequest("Ayse", "ayse@example.com");
        System.out.println("Valid request violations: " + validator.validate(valid).size());
        // Valid request violations: 0
    }
}

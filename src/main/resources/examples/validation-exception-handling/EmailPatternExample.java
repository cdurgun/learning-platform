import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;

import java.util.Set;

// @Email checks for a syntactically valid email address; @Pattern checks against any
// regular expression you provide -- and, unlike most constraints, is commonly given a
// custom `message` because "must match ^[a-z0-9_]{3,16}$" means nothing to a user.
class EmailPatternExample {

    record CreateUserRequest(
            @Email String email,
            @Pattern(
                    regexp = "^[a-z0-9_]{3,16}$",
                    message = "username must be 3-16 lowercase letters, digits, or underscores"
            ) String username) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(new CreateUserRequest("not-an-email", "ayse_92")).size());
        // 1

        Set<ConstraintViolation<CreateUserRequest>> violations =
                validator.validate(new CreateUserRequest("ayse@example.com", "AY"));
        System.out.println(violations.size());
        // 1
        violations.forEach(v -> System.out.println(v.getMessage()));
        // username must be 3-16 lowercase letters, digits, or underscores
    }
}

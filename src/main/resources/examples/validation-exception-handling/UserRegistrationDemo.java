import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;

import java.util.Set;

// This is what Spring's validation gate does internally, made visible: validate the
// request BEFORE the controller method body ever runs, and never call the method at
// all if any constraint fails.
class UserRegistrationDemo {

    static String dispatch(UserRegistrationController controller, Validator validator,
            UserRegistrationController.RegisterRequest request) {
        Set<ConstraintViolation<UserRegistrationController.RegisterRequest>> violations =
                validator.validate(request);

        if (!violations.isEmpty()) {
            return "400 Bad Request (" + violations.size() + " violation(s))";
        }
        return "200 OK -> " + controller.register(request);
    }

    public static void main(String[] args) {
        UserRegistrationController controller = new UserRegistrationController();
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        var valid = new UserRegistrationController.RegisterRequest("Ada Lovelace", "ada@example.com", "s3cretpw!");
        System.out.println(dispatch(controller, validator, valid));
        // 200 OK -> Registered: Ada Lovelace

        // Only the email is malformed, so this triggers exactly one violation.
        var invalidEmail = new UserRegistrationController.RegisterRequest("Ada Lovelace", "not-an-email", "s3cretpw!");
        System.out.println(dispatch(controller, validator, invalidEmail));
        // 400 Bad Request (1 violation(s))
    }
}

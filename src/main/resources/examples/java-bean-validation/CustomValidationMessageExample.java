import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

// Every constraint accepts a "message" attribute -- without it, you get
// the library's default English wording. Two ways to override it:
// (1) a literal string, written directly on the annotation;
// (2) a "{...}" placeholder, resolved from a messages.properties file on
//     the classpath (the standard Spring i18n mechanism, reused here) --
//     this is what lets the SAME constraint produce a translated message
//     depending on the active locale, instead of a hardcoded string.
class CustomValidationMessageExample {

    record RegisterUserRequest(
            @NotBlank(message = "Display name is required") String displayName,
            @Min(value = 16, message = "{user.age.tooYoung}") int age) {
        // messages.properties: user.age.tooYoung=You must be at least 16 years old
        // messages_tr.properties: user.age.tooYoung=En az 16 yaşında olmalısınız
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        validator.validate(new RegisterUserRequest("", 12)).forEach(violation ->
                System.out.println(violation.getPropertyPath() + ": " + violation.getMessage()));
        // displayName: Display name is required
        // age: {user.age.tooYoung} -- a plain Validator instance (used
        //     directly here, outside Spring) does not resolve message
        //     bundles; inside a Spring MVC controller, this placeholder is
        //     automatically resolved through the same MessageSource
        //     mechanism used for regular UI text.
    }
}

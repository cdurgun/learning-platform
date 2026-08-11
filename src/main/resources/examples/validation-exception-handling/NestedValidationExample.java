import jakarta.validation.Valid;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.NotBlank;

// Bean Validation does NOT automatically validate nested objects -- without @Valid on
// the nested field, its own constraints are silently skipped. Adding @Valid makes the
// validator recurse (cascade) into it too.
class NestedValidationExample {

    record Address(@NotBlank String city) {
    }

    record ShippingRequestWithoutCascade(@NotBlank String customerName, Address address) {
    }

    record ShippingRequestWithCascade(@NotBlank String customerName, @Valid Address address) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        var withoutCascade = new ShippingRequestWithoutCascade("Ayse", new Address(""));
        System.out.println("Without @Valid on the nested field: " + validator.validate(withoutCascade).size());
        // Without @Valid on the nested field: 0

        var withCascade = new ShippingRequestWithCascade("Ayse", new Address(""));
        System.out.println("With @Valid on the nested field: " + validator.validate(withCascade).size());
        // With @Valid on the nested field: 1
    }
}

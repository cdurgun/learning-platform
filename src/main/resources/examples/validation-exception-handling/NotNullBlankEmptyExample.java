import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

// Three annotations that sound similar but check different things:
//   @NotNull  -- the value must not be null (an empty string still passes)
//   @NotEmpty -- must not be null AND not empty (a whitespace-only string still passes)
//   @NotBlank -- must not be null, not empty, AND not just whitespace
class NotNullBlankEmptyExample {

    record NotNullField(@NotNull String value) {
    }

    record NotEmptyField(@NotEmpty String value) {
    }

    record NotBlankField(@NotBlank String value) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(new NotNullField(null)).size());
        // 1
        System.out.println(validator.validate(new NotNullField("")).size());
        // 0 -- @NotNull allows an empty string

        System.out.println(validator.validate(new NotEmptyField("")).size());
        // 1
        System.out.println(validator.validate(new NotEmptyField("   ")).size());
        // 0 -- @NotEmpty allows a whitespace-only string

        System.out.println(validator.validate(new NotBlankField("   ")).size());
        // 1 -- @NotBlank rejects whitespace-only
        System.out.println(validator.validate(new NotBlankField("x")).size());
        // 0
    }
}

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

// As we saw in the "Components" section, validation annotations are automatically
// applied to the field, the constructor parameter, and the accessor alike.
record CreateUserRequest(
        @NotBlank String fullName,
        @NotBlank @Email String email
) {
}

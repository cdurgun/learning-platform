import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Null;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

// Validation groups let the SAME DTO enforce different constraints
// depending on which operation is running -- without groups, "id must be
// null on create" and "id must be present on update" couldn't both apply
// to one class. Each constraint is tagged with which group(s) it belongs
// to; validate(object, SomeGroup.class) then runs ONLY the constraints
// tagged for that group.
class ValidationGroupsExample {

    interface OnCreate {}
    interface OnUpdate {}

    record UserRequest(
            @Null(groups = OnCreate.class) @NotNull(groups = OnUpdate.class) Long id,
            @NotBlank(groups = {OnCreate.class, OnUpdate.class}) String name) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(new UserRequest(1L, "Alice"), OnCreate.class).size());
        // 1 -- @Null(groups = OnCreate.class) fails: id must be absent when creating

        System.out.println(validator.validate(new UserRequest(null, "Alice"), OnUpdate.class).size());
        // 1 -- @NotNull(groups = OnUpdate.class) fails: id is required when updating

        System.out.println(validator.validate(new UserRequest(null, "Alice"), OnCreate.class).size());
        // 0 -- no id and a name: exactly what OnCreate requires
    }
}

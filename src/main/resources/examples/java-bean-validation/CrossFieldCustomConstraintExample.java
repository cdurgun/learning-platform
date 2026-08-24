import jakarta.validation.Constraint;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.time.LocalDate;

// A custom constraint has two parts: the annotation itself (declaring
// which ConstraintValidator implements it), and the validator class
// (containing the actual check). Placed at CLASS level (not on a single
// field) because the rule -- "checkOut must be after checkIn" -- depends
// on TWO fields at once; no single-field annotation like @Future could
// express this on its own.
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange {
    String message() default "checkOutDate must be after checkInDate";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

class DateRangeValidator implements ConstraintValidator<ValidDateRange, CrossFieldCustomConstraintExample.BookingRequest> {

    @Override
    public boolean isValid(CrossFieldCustomConstraintExample.BookingRequest booking, ConstraintValidatorContext context) {
        if (booking.checkInDate() == null || booking.checkOutDate() == null) {
            return true; // let @NotNull (if present) report missing values -- this
            //                validator only checks the RELATIONSHIP between the two
        }
        return booking.checkOutDate().isAfter(booking.checkInDate());
    }
}

public class CrossFieldCustomConstraintExample {

    @ValidDateRange
    record BookingRequest(LocalDate checkInDate, LocalDate checkOutDate) {
    }

    public static void main(String[] args) {
        var validator = jakarta.validation.Validation.buildDefaultValidatorFactory().getValidator();

        LocalDate today = LocalDate.now();

        System.out.println(validator.validate(new BookingRequest(today, today.minusDays(1))).size());
        // 1 -- checkOutDate is before checkInDate

        System.out.println(validator.validate(new BookingRequest(today, today.plusDays(3))).size());
        // 0 -- a valid range
    }
}

import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.PastOrPresent;

import java.time.LocalDate;

// Four date/time constraints, compared to "now" at the moment of validation:
// @Past             -- must be strictly before now
// @PastOrPresent     -- must be now or before
// @Future           -- must be strictly after now
// @FutureOrPresent   -- must be now or after
// These work on any date/time type (LocalDate, LocalDateTime, Date, ...) --
// the comparison is always made against the clock at validation time, not
// against some fixed date.
class DateTimeConstraintsExample {

    record ReservationRequest(
            @Past LocalDate dateOfBirth,             // a birth date must already have happened
            @FutureOrPresent LocalDate checkInDate,    // check-in today or later is fine
            @Future LocalDate checkOutDate) {          // check-out must be strictly in the future
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        LocalDate today = LocalDate.now();

        System.out.println(validator.validate(
                new ReservationRequest(today.plusDays(1), today, today.plusDays(3))).size());
        // 1 -- dateOfBirth is tomorrow, but @Past requires a date before today

        System.out.println(validator.validate(
                new ReservationRequest(today.minusYears(30), today, today.plusDays(3))).size());
        // 0 -- a birth date 30 years ago, check-in today, check-out in the future
    }
}

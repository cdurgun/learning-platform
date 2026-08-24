import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;

import java.math.BigDecimal;

// @Min/@Max only accept whole-number bounds and only apply to integer types
// (int, long, ...). @DecimalMin/@DecimalMax exist for exactly the case
// @Min/@Max can't handle: fractional bounds on a BigDecimal (or double/
// float) field -- the bound is written as a String so it can express an
// exact decimal value like "0.01" without floating-point rounding.
class DecimalBoundsAndDigitsExample {

    record PriceUpdate(
            @DecimalMin("0.01") @DecimalMax("9999.99") BigDecimal price,
            // @Digits caps how many digits are allowed before and after the
            // decimal point -- here, at most 4 whole-number digits and
            // exactly 2 fractional digits, matching how currency is stored.
            @Digits(integer = 4, fraction = 2) BigDecimal displayPrice) {
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(
                new PriceUpdate(new BigDecimal("0.00"), new BigDecimal("19.99"))).size());
        // 1 -- 0.00 is below the 0.01 minimum

        System.out.println(validator.validate(
                new PriceUpdate(new BigDecimal("19.99"), new BigDecimal("19.999"))).size());
        // 1 -- displayPrice has 3 fractional digits, but @Digits allows only 2

        System.out.println(validator.validate(
                new PriceUpdate(new BigDecimal("19.99"), new BigDecimal("19.99"))).size());
        // 0 -- both fields satisfy their bounds
    }
}

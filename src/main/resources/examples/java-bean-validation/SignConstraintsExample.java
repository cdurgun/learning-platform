import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.constraints.Negative;
import jakarta.validation.constraints.NegativeOrZero;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

// Four sign-based constraints, each strict or inclusive of zero:
// @Positive        -- must be > 0 (zero itself fails)
// @PositiveOrZero   -- must be >= 0
// @Negative        -- must be < 0 (zero itself fails)
// @NegativeOrZero   -- must be <= 0
// Exactly like @Min/@Max, "Positive"/"Negative" alone are STRICT, and
// "OrZero" is what makes zero acceptable -- there's no separate
// "at-least-zero" annotation because @PositiveOrZero already is that.
class SignConstraintsExample {

    record StockAdjustment(
            @Positive int quantityAdded,       // restocking: must add at least 1
            @PositiveOrZero int reservedUnits,  // reserving zero units is a valid no-op
            @Negative int quantityRemoved,      // removals are recorded as negative deltas
            @NegativeOrZero int discountCents) { // a discount of exactly 0 cents is allowed
    }

    public static void main(String[] args) {
        Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

        System.out.println(validator.validate(new StockAdjustment(0, 5, -3, -100)).size());
        // 1 -- quantityAdded is 0, but @Positive requires strictly greater than 0

        System.out.println(validator.validate(new StockAdjustment(10, 0, -3, 0)).size());
        // 0 -- reservedUnits and discountCents are exactly 0, and both allow zero
    }
}

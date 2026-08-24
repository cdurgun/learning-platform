"Validation & Exception Handling," in Spring MVC, already covered the everyday core of Bean Validation: `@NotNull`/`@NotEmpty`/`@NotBlank`, `@Size`/`@Min`/`@Max`, `@Email`/`@Pattern`, `@Valid`, the `Validator`/`ConstraintViolation` machinery, and cascading validation on nested objects. This lesson doesn't repeat any of that. It picks up exactly where that lesson left off — the built-in constraints it didn't cover, customizing the messages a violation produces, and writing your own validation rules when the built-in ones simply can't express what you need.

## Beyond the Basics: What This Lesson Builds On

Everything here assumes you're already comfortable with `@Valid` triggering validation on a `@RequestBody`, and with reading a `ConstraintViolation`. What's new: constraints for signed numbers and dates, constraints for exact decimal precision, message customization, and — the biggest jump — building your own constraint annotation for rules the built-in ones can't express, including rules that span more than one field at once.

## Sign Constraints: @Positive, @PositiveOrZero, @Negative, @NegativeOrZero

Four constraints check a numeric value's sign, each either strict or inclusive of zero.

{{SignConstraintsExample.java}}

`@Positive` and `@Negative` are STRICT — zero itself fails both. `@PositiveOrZero` and `@NegativeOrZero` allow zero. Recall that `@Min`/`@Max` are inclusive bounds — `@Min(16)` means "at least 16," not "greater than 16." `@Positive` and `@Negative` work differently: they exclude zero by definition, which is exactly why the "OrZero" variants exist as a separate, explicit choice rather than something you'd express with `@Min(0)`.

## Date and Time Constraints: @Past, @Future, @PastOrPresent, @FutureOrPresent

Four more constraints check a date or date-time value against the clock at the moment validation runs, not against any fixed date.

{{DateTimeConstraintsExample.java}}

`@Past` and `@Future` are strict — "now" itself fails both. `@PastOrPresent` and `@FutureOrPresent` allow the current moment. These work on any date/time type Bean Validation recognizes — `LocalDate`, `LocalDateTime`, `java.util.Date`, and others — the comparison logic is identical regardless of which one you use.

## Precise Decimal Bounds: @DecimalMin, @DecimalMax, and @Digits

`@Min`/`@Max` only accept whole-number bounds and only apply to integer types. `@DecimalMin`/`@DecimalMax` exist for exactly what they can't handle: fractional bounds on a `BigDecimal` (or `double`/`float`) field.

{{DecimalBoundsAndDigitsExample.java}}

The bound is written as a `String` — `@DecimalMin("0.01")`, not `@DecimalMin(0.01)` — so it can express an exact decimal value without any floating-point rounding creeping in. `@Digits(integer = 4, fraction = 2)` is a related but different check: instead of a range, it caps how many digits are allowed before and after the decimal point, which is exactly how currency amounts are usually constrained.

## Combining Constraints on a Realistic DTO

None of these constraints exist in isolation — a real request DTO combines several at once, exactly as you'd expect from "Validation & Exception Handling"'s `@Valid` coverage.

{{CombinedConstraintsProductDtoExample.java}}

`CreateProductRequest` mixes constraints already familiar from Spring MVC's lesson (`@NotBlank`, `@Size`) with the ones covered so far here (`@Positive`, `@DecimalMin`, `@Digits`, `@Future`) — and `@Valid` on the controller parameter runs every single one of them before `create(...)`'s body ever executes, exactly the mechanism already covered there.

## Customizing Validation Messages

Every constraint accepts a `message` attribute. Left unset, you get the library's default English wording; set explicitly, you control exactly what a violation reports.

{{CustomValidationMessageExample.java}}

A literal string (`message = "Display name is required"`) is the simplest override. A `{...}` placeholder (`message = "{user.age.tooYoung}"`) is resolved from a `messages.properties` file on the classpath instead — the same Spring i18n mechanism used for ordinary UI text — which is what lets the exact same constraint produce a message in the active locale rather than a single hardcoded string.

## Building a Custom, Cross-Field Constraint

Some rules simply can't be expressed by any single-field, built-in constraint — "checkout must be after check-in" depends on TWO fields at once, and no annotation on either field alone could check that relationship. A custom constraint has two parts: the annotation itself (declaring which `ConstraintValidator` implements it) and the validator class (containing the actual check).

{{CrossFieldCustomConstraintExample.java}}

`@ValidDateRange` is placed at CLASS level, not on a single field, precisely because its rule needs to see both `checkInDate` and `checkOutDate` at once. `DateRangeValidator implements ConstraintValidator<ValidDateRange, BookingRequest>` receives the whole `BookingRequest`, not one field's value, and returns `true`/`false` from `isValid(...)` — the exact same interface backing every built-in constraint you've already used, just implemented by hand.

> 💡 Tip
> A custom `ConstraintValidator` returning `true` for a `null` value (as `DateRangeValidator` does here) is the standard convention — it lets a separate `@NotNull` constraint be the one responsible for reporting a missing value, keeping each constraint focused on exactly one concern.

## Validation Groups

Validation groups let the SAME DTO enforce different constraints depending on which operation is running — without them, "`id` must be absent on create" and "`id` is required on update" couldn't both apply to one class at once.

{{ValidationGroupsExample.java}}

Each constraint is tagged with the group(s) it belongs to (`@NotNull(groups = OnUpdate.class)`), and `validator.validate(request, OnCreate.class)` runs ONLY the constraints tagged for that group. This is a narrow tool for a specific shape of problem — reach for it when the same request type genuinely needs to enforce different rules per operation, not as a general-purpose validation mechanism.

## Best Practices

- Use the strict sign/date constraints (`@Positive`, `@Future`, ...) by default, and only reach for the "OrZero"/"OrPresent" variant when the boundary value is genuinely a valid case.
- Prefer `@DecimalMin`/`@DecimalMax` string bounds over comparing a `BigDecimal` manually in application code — the constraint documents the rule directly on the field.
- Move every user-facing validation message into a `messages.properties` placeholder rather than hardcoding it, the moment your application needs to support more than one locale.
- Reach for a custom `ConstraintValidator` only when a rule genuinely can't be expressed with a combination of built-in constraints — and keep each custom constraint focused on one rule.

## Common Mistakes

- Writing `@DecimalMin(0.01)` instead of `@DecimalMin("0.01")` — the bound must be a `String`, not a numeric literal.
- Assuming `@Positive` accepts zero, the way `@Min(0)` would — it doesn't; `@PositiveOrZero` is the constraint for that case.
- Trying to validate a cross-field rule with two independent single-field constraints instead of one class-level custom constraint that can actually see both fields at once.
- Forgetting that a validation group only runs the constraints explicitly tagged for it — an untagged constraint (no `groups` attribute at all) is silently skipped when validating against a specific group.

## Summary, Cheat Sheet, and Glossary

**Summary**

- `@Positive`/`@Negative` are strict about zero; `@PositiveOrZero`/`@NegativeOrZero` allow it.
- `@Past`/`@Future` are strict about the current moment; `@PastOrPresent`/`@FutureOrPresent` allow it.
- `@DecimalMin`/`@DecimalMax` take `String` bounds for exact decimal precision; `@Digits` caps digit counts before and after the decimal point.
- A `message` attribute (a literal string or a `{...}` placeholder resolved from `messages.properties`) customizes what a violation reports.
- A custom constraint pairs an annotation with a `ConstraintValidator`; placing it at class level lets a rule span multiple fields at once.
- Validation groups let one DTO enforce different constraints depending on which group it's validated against.

**Cheat Sheet**

```java
// Sign and date constraints
record Adjustment(@Positive int added, @PositiveOrZero int reserved) {}
record Booking(@FutureOrPresent LocalDate checkIn, @Future LocalDate checkOut) {}

// Decimal precision
record Price(@DecimalMin("0.01") @Digits(integer = 6, fraction = 2) BigDecimal amount) {}

// Custom message
@NotBlank(message = "Display name is required")
@Min(value = 16, message = "{user.age.tooYoung}")

// Custom, cross-field constraint
@Target(ElementType.TYPE)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange { ... }

class DateRangeValidator implements ConstraintValidator<ValidDateRange, Booking> {
    public boolean isValid(Booking b, ConstraintValidatorContext ctx) {
        return b.checkOut().isAfter(b.checkIn());
    }
}

// Validation groups
validator.validate(request, OnCreate.class);
```

**Glossary**

- **Sign constraint**: a constraint checking a numeric value's sign, strict (`@Positive`/`@Negative`) or inclusive of zero (`@PositiveOrZero`/`@NegativeOrZero`).
- **Message placeholder**: a `{...}`-wrapped key in a constraint's `message` attribute, resolved from a `messages.properties` bundle.
- **Custom constraint**: a constraint annotation paired with a hand-written `ConstraintValidator`, for rules the built-in constraints can't express.
- **Cross-field validation**: a validation rule that depends on more than one field at once, typically implemented as a class-level custom constraint.
- **Validation group**: a marker interface used to tag which constraints should run for a particular validation call, letting one type enforce different rules in different contexts.

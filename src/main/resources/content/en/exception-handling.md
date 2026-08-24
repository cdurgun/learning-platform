"Validation & Exception Handling," in Spring MVC, already covered `@ExceptionHandler`, `@RestControllerAdvice`, and a first look at RFC 7807 `ProblemDetail`. "Java Bean Validation," earlier in this category, added a much richer set of constraints — including a custom, cross-field one — that can now fail in more varied ways. This lesson connects the two: what actually happens when validation fails, how to design status codes and response bodies for a real REST API's failures in general, and how to centralize all of it without leaking anything a client shouldn't see.

## Why Not Every Error Is a Generic 500

Returning `500 Internal Server Error` for every failure is easy to write and almost useless to a client — it can't tell "you sent bad data" apart from "our database is down" apart from "this resource doesn't exist," three situations that call for three completely different client responses. A well-designed API distinguishes CLIENT errors (bad input, a business rule violation, a missing resource) — which the client can potentially fix and retry — from genuine SERVER errors, which it can't. Everything in this lesson is about making that distinction concrete.

## MethodArgumentNotValidException: What @Valid Actually Throws

"Validation & Exception Handling" showed `@Valid` triggering validation, without naming what actually happens when it fails on a `@RequestBody`: Spring throws a `MethodArgumentNotValidException`, before your controller method's body ever runs.

{{MethodArgumentNotValidExceptionExample.java}}

The exception carries a `BindingResult` — the exact same type Spring MVC uses for traditional form binding — with one `FieldError` per failed constraint, each naming its field and the constraint's message. `exception.getBindingResult().getFieldErrors()` is how a handler reads every individual failure at once, rather than getting only the first one.

## Turning Validation Failures Into a ProblemDetail

A `@RestControllerAdvice` method that catches `MethodArgumentNotValidException` converts that `BindingResult` into a response — and needs to read more than just per-field errors.

{{ValidationProblemDetailExample.java}}

`getFieldErrors()` covers ordinary single-field failures (`@NotBlank`, `@Positive`, and the rest). `getGlobalErrors()` covers something "Validation & Exception Handling" never needed: a class-level custom constraint like "Java Bean Validation"'s `@ValidDateRange`, which isn't attached to any single field, so it surfaces as an `ObjectError` instead of a `FieldError`. A handler that only reads `getFieldErrors()` would silently drop a failed cross-field rule out of its response entirely.

## Custom ProblemDetail Properties

Spring MVC's lesson attached a single `"errors"` property to a `ProblemDetail`. In practice, a real API's error body usually needs more than that.

{{CustomProblemDetailPropertiesExample.java}}

`setType(...)`, `setTitle(...)`, and repeated `setProperty(...)` calls build out a `ProblemDetail` with a machine-readable `errorCode`, the specific resource involved, and a `timestamp` — all still valid RFC 7807, since `ProblemDetail` is designed around exactly this kind of extension. A client can branch on `errorCode` reliably, in a way it never safely could on a human-readable message string.

## Choosing the Right Status Code for a Domain Exception

Different business failures deserve different status codes — picking the right one communicates something specific, instead of forcing every client to inspect a response body just to know what category of problem occurred.

{{DomainExceptionStatusMappingExample.java}}

`404 Not Found` means the resource being asked about doesn't exist. `409 Conflict` means the request conflicts with the resource's current state (a duplicate, in this example). `422 Unprocessable Entity` means the request was well-formed and understood, but violates a business rule — the key distinction from `400 Bad Request`, which means the request itself was malformed or failed validation, as covered in the sections above.

> 💡 Tip
> A quick rule of thumb: if the request itself is broken (missing fields, wrong types), that's `400`. If the request is well-formed but the THING it's asking for doesn't exist, that's `404`. If it's well-formed but conflicts with existing state, that's `409`. If it's well-formed and the resource exists, but a business rule still rejects it, that's `422`.

## Centralizing Framework Exceptions with ResponseEntityExceptionHandler

`@RestControllerAdvice` with individual `@ExceptionHandler` methods, from Spring MVC's lesson, centralizes handling for an application's OWN exceptions. `ResponseEntityExceptionHandler` does the equivalent for exceptions Spring MVC ITSELF throws.

{{ResponseEntityExceptionHandlerExample.java}}

Extending it and overriding one method — `handleMethodArgumentNotValid(...)` here — customizes exactly that one case, while every other framework exception it already knows how to handle (a malformed JSON body, an unsupported media type, a missing parameter, and many more) keeps its sensible default behavior automatically, with no code written for any of them.

## Keeping Error Responses Safe

An exception's message or stack trace often contains information that was never meant to leave the server — a database hostname, an internal file path, a library version.

{{SafeErrorResponseExample.java}}

The unsafe version — returning `e.toString()` or a message straight from the exception — hands exactly that information to whoever sent the request, attacker or not. The safe version logs the FULL exception where only the team can see it, and returns a generic, constant message to the client — the two audiences (an engineer debugging a log, a client reading a response) get exactly the information each one should have, and no more.

## A Practical, End-to-End Example

Combining everything above into one realistic endpoint shows how these pieces fit together in practice.

{{PracticalCentralizedErrorHandlingExample.java}}

`OrderController.placeOrder(...)` can fail three distinct ways, and `OrderExceptionAdvice` handles each with the technique it actually calls for: a `MethodArgumentNotValidException` becomes a `400` with per-field detail, an `OutOfStockException` becomes a `422` with a machine-readable `errorCode`, and anything else is logged in full and reduced to a safe, generic `500` — one centralized class covering an entire controller's realistic failure modes.

## Best Practices

- Pick a status code by what actually went wrong (malformed request, missing resource, conflicting state, rejected business rule, genuine server failure), not by habit or convenience.
- Read both `getFieldErrors()` and `getGlobalErrors()` from a `BindingResult` — a class-level custom constraint's failure only shows up in the second one.
- Attach a machine-readable `errorCode` as a custom `ProblemDetail` property whenever a client might need to branch on the specific failure, not just display a message.
- Log the full exception internally and return a generic message externally for anything unanticipated — never let `e.getMessage()` or a stack trace reach a client directly.

## Common Mistakes

- Returning `500` for a validation failure or a business rule rejection — both are client-caused, and both deserve a `4xx` status the client can act on.
- Reading only `getFieldErrors()` and missing a class-level constraint's failure entirely, since it only appears in `getGlobalErrors()`.
- Using `409 Conflict` and `422 Unprocessable Entity` interchangeably — a conflict is about existing state; an unprocessable entity is about a business rule, independent of any conflict.
- Exposing an exception's raw message or stack trace in a response body, leaking implementation details a client (or attacker) was never meant to see.

## Summary, Cheat Sheet, and Glossary

**Summary**

- `@Valid` failing on a `@RequestBody` throws `MethodArgumentNotValidException`, carrying a `BindingResult` with per-field and class-level errors.
- `getFieldErrors()` covers single-field failures; `getGlobalErrors()` covers class-level custom constraints like a cross-field rule.
- `ProblemDetail` supports as many custom properties as an API needs — an error code, a resource id, a timestamp — beyond a single error list.
- Different domain failures deserve different status codes: `400` malformed, `404` missing, `409` conflicting state, `422` rejected business rule, `500` genuine server failure.
- `ResponseEntityExceptionHandler` centralizes handling for Spring MVC's own exceptions, the way `@RestControllerAdvice` centralizes handling for an application's own.
- A safe error response logs the full exception internally and returns only a generic message externally.

**Cheat Sheet**

```java
// Reading both kinds of validation errors
ex.getBindingResult().getFieldErrors();   // per-field
ex.getBindingResult().getGlobalErrors();  // class-level custom constraints

// Custom ProblemDetail properties
ProblemDetail problem = ProblemDetail.forStatusAndDetail(status, detail);
problem.setProperty("errorCode", "OUT_OF_STOCK");

// Status codes for domain exceptions
@ExceptionHandler(NotFoundException.class)
@ResponseStatus(HttpStatus.NOT_FOUND) // 404
@ExceptionHandler(ConflictException.class)
@ResponseStatus(HttpStatus.CONFLICT) // 409
@ExceptionHandler(BusinessRuleException.class)
@ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY) // 422

// Centralizing framework exceptions
class GlobalMvcExceptionHandler extends ResponseEntityExceptionHandler {
    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(...) { ... }
}

// Safe fallback
@ExceptionHandler(Exception.class)
public ProblemDetail handleUnexpected(Exception e) {
    log.error("Unhandled exception", e);
    return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
}
```

**Glossary**

- **MethodArgumentNotValidException**: the exception Spring MVC throws when `@Valid` fails on a `@RequestBody`, carrying a `BindingResult`.
- **Field error vs. object error**: a `FieldError` reports a single failed field; an `ObjectError` (from `getGlobalErrors()`) reports a class-level failure not tied to one field.
- **422 Unprocessable Entity**: the status for a well-formed, understood request that still violates a business rule.
- **ResponseEntityExceptionHandler**: Spring MVC's base class for centrally handling the framework's own built-in exceptions.
- **Safe error response**: a response that logs full failure detail internally but reveals only a generic message externally.

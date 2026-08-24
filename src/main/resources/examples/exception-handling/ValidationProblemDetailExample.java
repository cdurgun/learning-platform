import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;
import java.util.stream.Collectors;

// Where MethodArgumentNotValidExceptionExample showed what the exception
// CONTAINS, this shows the handler that actually turns it into a response
// -- reading BOTH kinds of errors it can carry: per-field errors (from a
// failed @NotBlank, @Positive, ...) and object-level errors (from a
// class-level custom constraint like "Java Bean Validation"'s
// @ValidDateRange, which isn't about any single field).
@RestControllerAdvice
class ValidationExceptionAdvice {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidation(MethodArgumentNotValidException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
                HttpStatus.BAD_REQUEST, "One or more fields failed validation");

        List<String> fieldErrors = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.toList());

        List<String> objectErrors = ex.getBindingResult().getGlobalErrors().stream()
                .map(ObjectError::getDefaultMessage) // class-level errors have no single field
                .collect(Collectors.toList());

        problem.setProperty("fieldErrors", fieldErrors);
        if (!objectErrors.isEmpty()) {
            problem.setProperty("objectErrors", objectErrors); // e.g. a failed @ValidDateRange
        }
        return problem;
    }
}

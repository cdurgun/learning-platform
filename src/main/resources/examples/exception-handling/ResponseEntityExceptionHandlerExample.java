import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

// ResponseEntityExceptionHandler is Spring MVC's OWN base class for
// handling the framework's built-in exceptions (MethodArgumentNotValidException,
// HttpMessageNotReadableException, and many others) -- extending it and
// overriding one method CUSTOMIZES that specific case, while every other
// exception it already knows how to handle keeps its default behavior for
// free. This centralizes handling for framework-level exceptions the way
// a @RestControllerAdvice with individual @ExceptionHandler methods
// centralizes handling for an application's OWN exceptions.
@RestControllerAdvice
class GlobalMvcExceptionHandler extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex, HttpHeaders headers,
            HttpStatusCode status, WebRequest request) {

        ProblemDetail problem = ProblemDetail.forStatusAndDetail(status, "Validation failed");
        problem.setProperty("fieldErrors", ex.getBindingResult().getFieldErrors());

        return ResponseEntity.status(status).headers(headers).body(problem);
        // Every OTHER exception ResponseEntityExceptionHandler already
        // understands -- a malformed JSON body, an unsupported media type,
        // a missing request parameter -- is still handled by its default
        // logic, with no code written here for any of them.
    }
}

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

// @RestControllerAdvice = @ControllerAdvice + @ResponseBody, applied GLOBALLY --
// unlike ExceptionHandlerBasicExample's handler (scoped to one controller), every
// controller in the application is covered by this single class.
@RestControllerAdvice
class GlobalExceptionHandler {

    static class ResourceNotFoundException extends RuntimeException {
        ResourceNotFoundException(String message) {
            super(message);
        }
    }

    static class InvalidRequestException extends RuntimeException {
        InvalidRequestException(String message) {
            super(message);
        }
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(ResourceNotFoundException e) {
        return e.getMessage();
    }

    @ExceptionHandler(InvalidRequestException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleInvalidRequest(InvalidRequestException e) {
        return e.getMessage();
    }

    // A catch-all, LAST-resort handler -- Spring always picks the MOST SPECIFIC
    // matching @ExceptionHandler for a given exception, so this only fires when
    // nothing more specific matches.
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGeneric(Exception e) {
        return "An unexpected error occurred";
    }
}

class RestControllerAdviceExample {
    public static void main(String[] args) {
        GlobalExceptionHandler advice = new GlobalExceptionHandler();

        System.out.println(advice.handleNotFound(new GlobalExceptionHandler.ResourceNotFoundException("user 5 not found")));
        // user 5 not found
        System.out.println(advice.handleInvalidRequest(new GlobalExceptionHandler.InvalidRequestException("email is required")));
        // email is required
        System.out.println(advice.handleGeneric(new RuntimeException("disk full")));
        // An unexpected error occurred
    }
}

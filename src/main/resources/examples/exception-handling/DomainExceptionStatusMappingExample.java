import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

// Three business exceptions, three DIFFERENT status codes -- picking the
// right one communicates something specific to the client, not just
// "something went wrong":
// 404 Not Found            -- the resource being asked about doesn't exist
// 409 Conflict              -- the request conflicts with the resource's current state
// 422 Unprocessable Entity  -- the request was well-formed and understood,
//                               but violates a business rule (as opposed to
//                               400, which means the request itself was malformed)
@RestControllerAdvice
class DomainExceptionAdvice {

    static class OrderNotFoundException extends RuntimeException {
        OrderNotFoundException(String orderId) {
            super("Order not found: " + orderId);
        }
    }

    static class DuplicateOrderException extends RuntimeException {
        DuplicateOrderException(String orderId) {
            super("Order already exists: " + orderId);
        }
    }

    static class InsufficientStockException extends RuntimeException {
        InsufficientStockException(String productId) {
            super("Not enough stock for: " + productId);
        }
    }

    @ExceptionHandler(OrderNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(OrderNotFoundException e) {
        return e.getMessage();
    }

    @ExceptionHandler(DuplicateOrderException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public String handleDuplicate(DuplicateOrderException e) {
        return e.getMessage();
    }

    @ExceptionHandler(InsufficientStockException.class)
    @ResponseStatus(HttpStatus.UNPROCESSABLE_ENTITY)
    public String handleInsufficientStock(InsufficientStockException e) {
        return e.getMessage();
    }
}

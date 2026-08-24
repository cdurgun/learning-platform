import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;

// A single, realistic REST API endpoint plus the centralized advice that
// handles everything it can fail with -- validation errors, a specific
// business exception, and an unanticipated failure -- combining every
// technique covered in this lesson into one practical example.
class OrderApi {

    @RestController
    static class OrderController {

        record PlaceOrderRequest(String productId, int quantity) {
        }

        static class OutOfStockException extends RuntimeException {
            OutOfStockException(String productId) {
                super("Product is out of stock: " + productId);
            }
        }

        @PostMapping("/orders")
        public String placeOrder(@jakarta.validation.Valid @RequestBody PlaceOrderRequest request) {
            if (request.quantity() > 100) {
                throw new OutOfStockException(request.productId());
            }
            return "Order placed for " + request.productId();
        }
    }

    @RestControllerAdvice
    static class OrderExceptionAdvice {

        private static final Logger log = Logger.getLogger(OrderExceptionAdvice.class.getName());

        // 1. Validation failures -- 400, with per-field detail.
        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ProblemDetail handleValidation(MethodArgumentNotValidException e) {
            ProblemDetail problem = ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST, "Validation failed");
            problem.setProperty("fieldErrors", e.getBindingResult().getFieldErrors().stream()
                    .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
                    .collect(Collectors.toList()));
            return problem;
        }

        // 2. A specific business rule -- 422, since the request was
        // well-formed but conflicts with real-world stock levels.
        @ExceptionHandler(OrderController.OutOfStockException.class)
        public ProblemDetail handleOutOfStock(OrderController.OutOfStockException e) {
            ProblemDetail problem = ProblemDetail.forStatusAndDetail(
                    HttpStatus.UNPROCESSABLE_ENTITY, e.getMessage());
            problem.setProperty("errorCode", "OUT_OF_STOCK");
            return problem;
        }

        // 3. Everything else -- 500, logged in full, revealed to the
        // client only as a generic, safe message.
        @ExceptionHandler(Exception.class)
        public ProblemDetail handleUnexpected(Exception e) {
            log.log(Level.SEVERE, "Unhandled exception in OrderController", e);
            return ProblemDetail.forStatusAndDetail(
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "An unexpected error occurred. Please try again later.");
        }
    }
}

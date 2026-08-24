import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.logging.Level;
import java.util.logging.Logger;

@RestControllerAdvice
class SafeErrorHandlingAdvice {

    private static final Logger log = Logger.getLogger(SafeErrorHandlingAdvice.class.getName());

    // UNSAFE (shown only as a comment -- never write this): returning
    // e.getMessage() or a stack trace directly to the client can leak a
    // database column name, an internal file path, or a library version --
    // information an attacker can use, and information a client never
    // needed in the first place.
    //
    // @ExceptionHandler(Exception.class)
    // public ProblemDetail handleUnsafe(Exception e) {
    //     return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, e.toString());
    // }

    // SAFE: the FULL exception is logged where only the team can see it --
    // stack trace, message, everything -- while the client receives a
    // generic, constant message that reveals nothing about the failure's
    // internal cause.
    @ExceptionHandler(Exception.class)
    public ProblemDetail handleUnexpected(Exception e) {
        log.log(Level.SEVERE, "Unhandled exception", e);
        return ProblemDetail.forStatusAndDetail(
                HttpStatus.INTERNAL_SERVER_ERROR,
                "An unexpected error occurred. Please try again later.");
    }

    public static void main(String[] args) {
        SafeErrorHandlingAdvice advice = new SafeErrorHandlingAdvice();
        ProblemDetail problem = advice.handleUnexpected(
                new RuntimeException("Connection to db-primary-7.internal:5432 refused"));

        System.out.println(problem.getDetail());
        // An unexpected error occurred. Please try again later.
        // -- the real message, with its internal hostname, only ever reached the log.
    }
}

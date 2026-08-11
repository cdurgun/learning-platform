import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

// spring.servlet.multipart.max-file-size / max-request-size (application.properties)
// set hard limits Spring enforces BEFORE your controller method ever runs -- exceeding
// them throws MaxUploadSizeExceededException, which reaches DispatcherServlet as a
// regular exception. It fits the same @RestControllerAdvice mechanism from Validation
// & Exception Handling -- turning an error into a consistent, standard response.
@RestControllerAdvice
class MultipartSizeLimitExample {

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ProblemDetail handleTooLarge(MaxUploadSizeExceededException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.PAYLOAD_TOO_LARGE);
        problem.setTitle("File Too Large");
        problem.setDetail("Uploaded file exceeds the configured size limit.");
        return problem;
    }

    public static void main(String[] args) {
        MultipartSizeLimitExample advice = new MultipartSizeLimitExample();

        MaxUploadSizeExceededException ex = new MaxUploadSizeExceededException(5 * 1024 * 1024);
        ProblemDetail problem = advice.handleTooLarge(ex);

        System.out.println(problem.getStatus() + " " + problem.getTitle() + " -- " + problem.getDetail());
        // 413 File Too Large -- Uploaded file exceeds the configured size limit.

        // In application.properties, the limit that triggered this would be:
        //   spring.servlet.multipart.max-file-size=5MB
        //   spring.servlet.multipart.max-request-size=10MB
    }
}

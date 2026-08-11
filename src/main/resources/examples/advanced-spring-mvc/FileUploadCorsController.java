import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;

// Mini project, part 1/2: a single endpoint combining three mechanics from this
// lesson -- @CrossOrigin (so a browser-based frontend on a different origin can call
// it), MultipartFile (the actual upload), and an @ExceptionHandler for when the file
// is too large (same idea as MultipartSizeLimitExample, kept local to this
// controller instead of a separate @RestControllerAdvice).
@RestController
class FileUploadCorsController {

    private static final long MAX_BYTES = 1024; // deliberately tiny, to make the demo trigger it

    @CrossOrigin(origins = "https://learning-platform.example.com")
    @PostMapping("/api/avatar")
    public ResponseEntity<String> uploadAvatar(@RequestParam("file") MultipartFile file) {
        if (file.getSize() > MAX_BYTES) {
            throw new MaxUploadSizeExceededException(MAX_BYTES);
        }
        return ResponseEntity.ok("Stored " + file.getOriginalFilename() + " (" + file.getSize() + " bytes)");
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ProblemDetail handleTooLarge(MaxUploadSizeExceededException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.PAYLOAD_TOO_LARGE);
        problem.setTitle("Avatar Too Large");
        problem.setDetail("Avatar must be at most " + MAX_BYTES + " bytes.");
        return problem;
    }
}

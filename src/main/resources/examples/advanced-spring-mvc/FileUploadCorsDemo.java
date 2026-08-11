import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;

// Mini project, part 2/2: calls FileUploadCorsController.uploadAvatar directly with
// a small file (succeeds) and a large one (throws, then dispatch() catches it and
// routes it to the controller's own @ExceptionHandler -- the same pattern
// UserRegistrationDemo used in Validation & Exception Handling, just for a different
// exception type).
class FileUploadCorsDemo {

    static class InMemoryMultipartFile implements MultipartFile {
        private final String originalFilename;
        private final byte[] content;

        InMemoryMultipartFile(String originalFilename, byte[] content) {
            this.originalFilename = originalFilename;
            this.content = content;
        }

        public String getName() {
            return "file";
        }

        public String getOriginalFilename() {
            return originalFilename;
        }

        public String getContentType() {
            return "image/png";
        }

        public boolean isEmpty() {
            return content.length == 0;
        }

        public long getSize() {
            return content.length;
        }

        public byte[] getBytes() {
            return content;
        }

        public InputStream getInputStream() {
            return new ByteArrayInputStream(content);
        }

        public void transferTo(File dest) {
            throw new UnsupportedOperationException("not needed for this example");
        }
    }

    static String dispatch(FileUploadCorsController controller, MultipartFile file) {
        try {
            ResponseEntity<String> response = controller.uploadAvatar(file);
            return response.getStatusCode() + " " + response.getBody();
        } catch (MaxUploadSizeExceededException ex) {
            ProblemDetail problem = controller.handleTooLarge(ex);
            return problem.getStatus() + " " + problem.getTitle() + ": " + problem.getDetail();
        }
    }

    public static void main(String[] args) {
        FileUploadCorsController controller = new FileUploadCorsController();

        System.out.println(dispatch(controller, new InMemoryMultipartFile("avatar.png", "small".getBytes())));
        // 200 OK Stored avatar.png (5 bytes)

        byte[] tooLarge = new byte[2048];
        System.out.println(dispatch(controller, new InMemoryMultipartFile("huge.png", tooLarge)));
        // 413 Avatar Too Large: Avatar must be at most 1024 bytes.
    }
}

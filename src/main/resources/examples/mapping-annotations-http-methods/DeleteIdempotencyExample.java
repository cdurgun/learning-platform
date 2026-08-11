import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

// DELETE is idempotent in the sense that matters: no matter how many times you call
// it, the END STATE is the same (the resource is gone) -- even though the HTTP status
// code of the second call differs from the first.
@Controller
class BookDeletionController {
    private final Map<Long, String> books = new HashMap<>(Map.of(1L, "Effective Java"));

    @DeleteMapping("/books/{id}")
    @ResponseBody
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (books.remove(id) != null) {
            return ResponseEntity.noContent().build(); // 204: it was there, now it's gone
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // 404: already gone
    }
}

class DeleteIdempotencyExample {
    public static void main(String[] args) {
        BookDeletionController controller = new BookDeletionController();

        System.out.println(controller.delete(1L).getStatusCode());
        // 204 NO_CONTENT
        System.out.println(controller.delete(1L).getStatusCode());
        // 404 NOT_FOUND -- different status, but the end state (book 1 is gone) is
        // identical after either call, which is exactly what idempotency means.
    }
}

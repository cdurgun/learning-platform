import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// The three 2xx codes that come up constantly: 200 (a normal successful read/update
// with a body), 201 (a new resource was created, usually with a Location header, see
// "Adding Headers with ResponseEntity"), 204 (successful, but there's nothing to send
// back).
@Controller
class NoteController {

    @GetMapping("/notes/1")
    @ResponseBody
    public ResponseEntity<String> get() {
        return ResponseEntity.status(HttpStatus.OK).body("Buy milk");
    }

    @PostMapping("/notes")
    @ResponseBody
    public ResponseEntity<String> create() {
        return ResponseEntity.status(HttpStatus.CREATED).body("Note created");
    }

    @DeleteMapping("/notes/1")
    @ResponseBody
    public ResponseEntity<Void> delete() {
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }
}

class StatusCode2xxExample {
    public static void main(String[] args) {
        NoteController controller = new NoteController();

        System.out.println(controller.get().getStatusCode());
        // 200 OK
        System.out.println(controller.create().getStatusCode());
        // 201 CREATED
        System.out.println(controller.delete().getStatusCode());
        // 204 NO_CONTENT
    }
}

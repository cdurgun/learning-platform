import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

// A small, complete CRUD controller -- every mapping annotation from this lesson in
// one place, the same shape this project would use for a real /api/books endpoint.
@Controller
@RequestMapping("/api/books")
class BookCrudController {
    private final Map<Long, String> books = new LinkedHashMap<>();
    private long nextId = 1;

    @GetMapping
    @ResponseBody
    public List<String> list() {
        return List.copyOf(books.values());
    }

    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<String> getOne(@PathVariable Long id) {
        String title = books.get(id);
        return title != null ? ResponseEntity.ok(title) : ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<Long> create(@RequestBody String title) {
        long id = nextId++;
        books.put(id, title);
        return ResponseEntity.status(HttpStatus.CREATED).body(id);
    }

    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Void> replace(@PathVariable Long id, @RequestBody String title) {
        if (!books.containsKey(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        books.put(id, title);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        books.remove(id);
        return ResponseEntity.noContent().build(); // idempotent: same 204 whether or not it existed
    }
}

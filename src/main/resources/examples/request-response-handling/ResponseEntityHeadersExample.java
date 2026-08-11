import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.net.URI;

// ResponseEntity.BodyBuilder can also set headers -- the most common case being
// Location, telling the client where the resource it just created now lives.
@Controller
class ArticleCreationController {

    record CreateArticleRequest(String title) {
    }

    @PostMapping("/articles")
    @ResponseBody
    public ResponseEntity<Void> create(@RequestBody CreateArticleRequest request) {
        long newId = 42; // pretend this came from a real save operation
        URI location = URI.create("/articles/" + newId);

        return ResponseEntity.created(location)
                .header("X-Created-By", "learning-platform")
                .build();
    }
}

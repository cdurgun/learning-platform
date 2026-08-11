import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

// "Safe" means an HTTP method must not change server state; "idempotent" means
// calling it once or a hundred times leaves the server in the same state as calling
// it exactly once. GET is required to be both; POST is neither.
@Controller
class ViewCounterController {
    private int views = 0;

    @GetMapping("/article")
    @ResponseBody
    public String viewArticle() {
        // Safe: reading the article never changes `views`.
        return "Article content (viewed " + views + " times so far)";
    }

    @PostMapping("/article/views")
    @ResponseBody
    public String recordView() {
        // Not safe, not idempotent: every call increments the counter further.
        views++;
        return "Recorded. Total views: " + views;
    }
}

class SafeAndIdempotentExample {
    public static void main(String[] args) {
        ViewCounterController controller = new ViewCounterController();

        System.out.println(controller.viewArticle());
        // Article content (viewed 0 times so far)
        System.out.println(controller.viewArticle());
        // Article content (viewed 0 times so far) -- safe: calling GET changed nothing

        System.out.println(controller.recordView());
        // Recorded. Total views: 1
        System.out.println(controller.recordView());
        // Recorded. Total views: 2 -- not idempotent: state changed again
    }
}

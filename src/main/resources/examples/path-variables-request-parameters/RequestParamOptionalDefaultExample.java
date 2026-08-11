import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

// By default, @RequestParam is REQUIRED -- a missing query parameter is a 400 Bad
// Request, not a null value. `required = false` and `defaultValue` change that.
@Controller
class SearchController {

    @GetMapping("/search")
    @ResponseBody
    public String search(
            @RequestParam String query,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "20") int limit) {
        return "Searching \"" + query + "\", sortBy=" + sortBy + ", limit=" + limit;
    }
}

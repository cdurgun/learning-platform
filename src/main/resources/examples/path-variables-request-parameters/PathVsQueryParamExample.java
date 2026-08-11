import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

// A path variable IDENTIFIES a resource -- without it, there's no request to make.
// A query parameter FILTERS/MODIFIES a request that's already valid on its own.
@Controller
class ArticleListController {

    // No {id} here -- this endpoint is valid with zero query parameters too.
    @GetMapping("/articles")
    @ResponseBody
    public String list(@RequestParam(required = false) String category) {
        return category == null ? "All articles" : "Articles in category: " + category;
    }

    // {id} is required -- there is no "get one article" without knowing which one.
    @GetMapping("/articles/{id}")
    @ResponseBody
    public String getOne(@PathVariable Long id) {
        return "Article #" + id;
    }
}

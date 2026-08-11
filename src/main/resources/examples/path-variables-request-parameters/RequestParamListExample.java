import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

// A query string can repeat the same key (?tag=java&tag=spring) -- binding that to a
// List lets a single parameter carry multiple values.
@Controller
class ArticleFilterController {

    @GetMapping("/articles/by-tag")
    @ResponseBody
    public String filterByTags(@RequestParam List<String> tag) {
        return "Filtering by tags: " + tag;
    }
}

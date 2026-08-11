import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

// A realistic search endpoint over a single category (path variable, identifies the
// resource collection), narrowed by optional query parameters (filters) and aware of
// the requesting client (header) -- every mechanism from this lesson, together.
@Controller
class CatalogSearchController {

    @GetMapping("/catalog/{category}/search")
    @ResponseBody
    public String search(
            @PathVariable String category,
            @RequestParam String query,
            @RequestParam(required = false) List<String> tag,
            @RequestParam(defaultValue = "10") int limit,
            @RequestHeader(value = "Accept-Language", required = false) String language) {
        return "Searching \"" + query + "\" in category=" + category
                + ", tags=" + tag + ", limit=" + limit + ", language=" + language;
    }
}

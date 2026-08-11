import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

// When the method parameter's name doesn't match the {placeholder}, or when the code
// is compiled without the -parameters flag (so parameter names aren't available at
// runtime), @PathVariable's `value` tells Spring explicitly which placeholder to bind.
@Controller
class ArticleController {

    @GetMapping("/articles/{articleSlug}")
    @ResponseBody
    public String getArticle(@PathVariable("articleSlug") String slug) {
        return "Article: " + slug;
    }
}

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

// @PathVariable pulls a value straight out of the URL's own path -- the {id} segment
// in the mapping and the `id` parameter are linked by name.
@Controller
class ProductController {

    @GetMapping("/products/{id}")
    @ResponseBody
    public String getProduct(@PathVariable Long id) {
        return "Product #" + id;
    }
}

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

// Model is how a controller hands data to a view without knowing anything about HTML.
// DispatcherServlet creates one Model per request and passes it into the controller
// method; whatever you put in it becomes available to the template under the same key.
@Controller
class ProductListController {

    @GetMapping("/products")
    public String list(Model model) {
        model.addAttribute("products", List.of("Keyboard", "Monitor", "Mouse"));
        model.addAttribute("count", 3);
        return "product-list";
        // The template can now read ${products} and ${count} -- exactly the mechanism
        // this project uses for th:each="topicItem : ${category.topics()}" in
        // fragments/layout.html.
    }
}

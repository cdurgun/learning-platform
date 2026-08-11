import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

// Two controllers, one shared "service", two very different jobs: ProductPageController
// serves an HTML page (a view name + a Model), ProductApiController serves raw data (a
// List, serialized to JSON by Jackson). Neither controller knows the other exists --
// this is the same "MVC vs REST" split this project itself could make between
// TopicController's HTML page and a hypothetical JSON API over the same content.
class ProductCatalogService {
    record Product(String name, double price) {
    }

    List<Product> findAll() {
        return List.of(
                new Product("Keyboard", 49.90),
                new Product("Monitor", 199.00));
    }
}

@Controller
class ProductPageController {
    private final ProductCatalogService service = new ProductCatalogService();

    @GetMapping("/products")
    public String page(Model model) {
        model.addAttribute("products", service.findAll());
        return "products"; // would resolve to templates/products.html
    }
}

@RestController
class ProductApiController {
    private final ProductCatalogService service = new ProductCatalogService();

    @GetMapping("/api/products")
    public List<ProductCatalogService.Product> api() {
        return service.findAll(); // serialized straight to JSON by Jackson
    }
}

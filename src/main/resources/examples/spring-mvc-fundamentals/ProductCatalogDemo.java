import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;

import java.util.List;

// We can't start a real DispatcherServlet here, but both controllers are plain objects
// with plain methods -- nothing stops us from calling them directly to see exactly what
// they would hand off to a ViewResolver (the Model) or to Jackson (the return value).
class ProductCatalogDemo {
    public static void main(String[] args) {
        ProductPageController pageController = new ProductPageController();
        Model model = new ExtendedModelMap();
        String viewName = pageController.page(model);
        System.out.println("View name: " + viewName);
        // View name: products
        System.out.println("Model: " + model.asMap());
        // Model: {products=[Product[name=Keyboard, price=49.9], Product[name=Monitor, price=199.0]]}

        ProductApiController apiController = new ProductApiController();
        List<ProductCatalogService.Product> products = apiController.api();
        System.out.println("API result: " + products);
        // API result: [Product[name=Keyboard, price=49.9], Product[name=Monitor, price=199.0]]
    }
}

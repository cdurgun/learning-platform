import java.util.List;
import java.util.Map;

// Mini project, part 2/2: renders the same product in Turkish and English by
// resolving "addToCartLabel" per locale first (a stand-in for a real #{...} lookup),
// then feeding the already-resolved string into ProductCardTemplateExample -- and
// renders a discounted vs. a regular-priced product to exercise the th:if badge.
class ProductCardDemo {

    private static final Map<String, String> ADD_TO_CART = Map.of("tr", "Sepete Ekle", "en", "Add to Cart");

    public static void main(String[] args) {
        var mug = new ProductCardTemplateExample.Product("java-mug", "Java Mug", "$12.00", false);
        var keyboard = new ProductCardTemplateExample.Product("mechanical-keyboard", "Mechanical Keyboard", "$79.00", true);

        for (String lang : List.of("tr", "en")) {
            String addToCartLabel = ADD_TO_CART.get(lang);

            System.out.println("[" + lang + "] regular price:");
            System.out.println(ProductCardTemplateExample.render(mug, addToCartLabel));
            // no <span class="badge">%</span>

            System.out.println("[" + lang + "] discounted:");
            System.out.println(ProductCardTemplateExample.render(keyboard, addToCartLabel));
            // includes <span class="badge">%</span>
        }
    }
}

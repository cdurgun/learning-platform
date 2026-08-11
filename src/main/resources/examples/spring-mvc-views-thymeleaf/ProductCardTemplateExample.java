import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// Mini project, part 1/2: a product card template that combines ${...} (variables),
// @{...} (a link to the product page), and th:if (a conditional discount badge).
// The "Add to cart" label is passed in already resolved -- in a real Thymeleaf setup
// this would be a live #{...} lookup through Spring's MessageSource, but this example
// keeps the resolution step separate (see ProductCardDemo, which does it the same way
// MessageExpressionExample and TopicController.buildUnavailableMessage do) so this
// class only has to demonstrate the templating side.
class ProductCardTemplateExample {

    record Product(String slug, String name, String priceLabel, boolean discounted) {
    }

    private static final String TEMPLATE = """
            <div class="product-card">
                <a th:href="@{/products/{slug}(slug=${product.slug()})}" th:text="${product.name()}">name</a>
                <span th:text="${product.priceLabel()}">price</span>
                <span th:if="${product.discounted()}" class="badge">%</span>
                <button th:text="${addToCartLabel}">Add to cart</button>
            </div>
            """;

    static String render(Product product, String addToCartLabel) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("product", product);
        context.setVariable("addToCartLabel", addToCartLabel);

        return engine.process(TEMPLATE, context);
    }
}

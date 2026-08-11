import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// @{...} is a link expression -- it builds a URL, adding the application's context
// path automatically and turning named placeholders (path variables) and query
// parameters into the right syntax. This project's own topic.html uses it constantly,
// e.g. th:href="@{/topics/{slug}(slug=${topic.slug}, lang=${language.code})}".
class LinkExpressionExample {

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("slug", "spring-mvc-views-thymeleaf");
        context.setVariable("lang", "tr");

        String template = """
                <a th:href="@{/topics/{slug}(slug=${slug}, lang=${lang})}">link with a path variable</a>
                <a th:href="@{/(lang='en')}">link with only a query parameter</a>
                """;

        System.out.println(engine.process(template, context));
        // <a href="/topics/spring-mvc-views-thymeleaf?lang=tr">...</a>
        // <a href="/?lang=en">...</a>
    }
}

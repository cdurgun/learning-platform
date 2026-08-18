import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// @{...} is a link expression -- it builds a URL, adding the application's context
// path automatically and turning named placeholders (path variables) and query
// parameters into the right syntax. This is exactly how this project's own
// topic.html built its links before an SEO-driven redesign moved language into
// the URL path itself -- back then it read
// th:href="@{/topics/{slug}(slug=${topic.slug}, lang=${language.code})}", with
// `lang` spilling over into a `?lang=..` query string exactly like below.
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

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// "Natural templating" is Thymeleaf's signature idea: a template is valid HTML on
// its own -- a browser (or a designer opening the .html file directly, with no
// server involved) renders it and sees reasonable placeholder content, because
// th:* attributes sit alongside real HTML attributes/text instead of replacing them
// with a foreign template syntax (unlike, say, JSP's <% ... %> scriptlets).
class NaturalTemplatingExample {

    private static final String TEMPLATE = """
            <p th:text="${message}">This is placeholder text a designer can see directly.</p>
            """;

    public static void main(String[] args) {
        // Opened as a plain .html file, with no processing at all, a designer still
        // sees a sensible sentence -- th:text is just an extra attribute, ignored by
        // any browser that doesn't understand it.
        System.out.println("Raw file, exactly as a browser without Thymeleaf sees it:");
        System.out.println(TEMPLATE);

        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("message", "Rendered by ThymeleafViewResolver on the server");

        String processed = engine.process(TEMPLATE, context);
        System.out.println("Same file, processed by Thymeleaf:");
        System.out.println(processed);
        // <p>Rendered by ThymeleafViewResolver on the server</p>
    }
}

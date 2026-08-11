import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// th:if removes the whole tag (not just hides it -- it never reaches the response)
// when its expression is falsy; th:unless is the mirror image. This project's own
// topic.html uses exactly this pair for the "content not available in this language"
// branch: th:if="${!contentAvailable}" vs. th:if="${contentAvailable}".
class ConditionalRenderExample {

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        String template = """
                <div th:if="${contentAvailable}">Content: <span th:text="${title}">t</span></div>
                <div th:unless="${contentAvailable}">Not available in this language yet.</div>
                <div th:if="${previousTopic != null}">Previous: <span th:text="${previousTopic}">p</span></div>
                """;

        Context available = new Context();
        available.setVariable("contentAvailable", true);
        available.setVariable("title", "Spring MVC Views & Thymeleaf");
        available.setVariable("previousTopic", null);

        System.out.println(engine.process(template, available));
        // <div>Content: <span>Spring MVC Views &amp; Thymeleaf</span></div>
        // (the th:unless div and the previousTopic div are both dropped entirely)

        Context unavailable = new Context();
        unavailable.setVariable("contentAvailable", false);
        unavailable.setVariable("title", null);
        unavailable.setVariable("previousTopic", "Request ve Response Handling");

        System.out.println(engine.process(template, unavailable));
        // <div>Not available in this language yet.</div>
        // <div>Previous: <span>Request ve Response Handling</span></div>
    }
}

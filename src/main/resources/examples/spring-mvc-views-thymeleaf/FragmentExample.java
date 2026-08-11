import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// th:fragment marks a reusable chunk of markup (optionally with parameters).
// th:insert and th:replace both pull that chunk in elsewhere -- the only difference
// is th:insert keeps the host tag, th:replace swaps the host tag out for the
// fragment's own root tag. This example references a fragment defined earlier in the
// SAME template string with ~{::selector} ("this template"); this project's real
// fragments/layout.html instead defines fragments in a separate file and topic.html
// pulls them in with th:replace="~{fragments/layout :: navbar}" (see "Bu Projenin
// Kendi Layout'u").
class FragmentExample {

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("badgeText", "INTERMEDIATE");

        String template = """
                <span th:fragment="badge(text)" class="badge" th:text="${text}">badge</span>

                <div>
                    <p>Inserted (keeps the surrounding div):</p>
                    <div th:insert="~{::badge(${badgeText})}">placeholder</div>
                </div>

                <div>
                    <p>Replaced (the div itself is swapped out for the span):</p>
                    <div th:replace="~{::badge(${badgeText})}">placeholder</div>
                </div>
                """;

        System.out.println(engine.process(template, context));
        // <div><span class="badge">INTERMEDIATE</span></div>  -- th:insert: div survives
        // <span class="badge">INTERMEDIATE</span>             -- th:replace: div is gone
    }
}

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

import java.util.List;

// ${...} is a variable expression -- it reads from the model the controller
// populated (see "Model, ModelMap ve ModelAndView"). Note the explicit ()
// on record accessors below (topic.title(), not topic.title) -- this project's own
// fragments/layout.html sidebar does the exact same thing (course.name(),
// category.slug()...) because a record's accessor is a real method, not a
// getTitle()-style bean property.
class VariableExpressionExample {

    record Topic(String title, int estimatedMinutes) {
    }

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("topic", new Topic("Spring MVC Views & Thymeleaf", 20));
        context.setVariable("tags", List.of("spring", "thymeleaf", "mvc"));

        String template = """
                <h1 th:text="${topic.title()}">Title</h1>
                <span th:text="${topic.estimatedMinutes()} + ' min'">0 min</span>
                <span th:text="${tags[0]}">tag</span>
                """;

        System.out.println(engine.process(template, context));
        // <h1>Spring MVC Views &amp; Thymeleaf</h1>
        // <span>20 min</span>
        // <span>spring</span>
    }
}

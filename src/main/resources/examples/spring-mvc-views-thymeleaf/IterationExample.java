import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

import java.util.List;

// th:each repeats the tag it's on once per element, optionally exposing a second,
// "status" variable (iterStat below) with index/count/even/odd/first/last -- this
// project's own sidebar fragment uses the same mechanic (th:each="topicItem :
// ${category.topics()}") without needing the status variable at all.
class IterationExample {

    record TopicItem(String slug, String title) {
    }

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("topics", List.of(
                new TopicItem("spring-mvc-fundamentals", "Spring MVC Fundamentals"),
                new TopicItem("validation-exception-handling", "Validation & Exception Handling"),
                new TopicItem("spring-mvc-views-thymeleaf", "Spring MVC Views & Thymeleaf")));

        String template = """
                <ul>
                    <li th:each="topic, iterStat : ${topics}"
                        th:text="${iterStat.count} + '. ' + ${topic.title()} + (${iterStat.last} ? ' (last)' : '')">
                        item
                    </li>
                </ul>
                """;

        System.out.println(engine.process(template, context));
        // <li>1. Spring MVC Fundamentals</li>
        // <li>2. Validation &amp; Exception Handling</li>
        // <li>3. Spring MVC Views &amp; Thymeleaf (last)</li>
    }
}

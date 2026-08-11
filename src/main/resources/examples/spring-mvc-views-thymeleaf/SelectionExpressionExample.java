import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

import java.util.List;

// .?[...] is a selection expression -- it filters a collection, evaluating the
// bracketed condition once per element with #this bound to that element. The catch:
// inside that bracket, #this rebinds the whole expression scope to the element, so a
// bare reference to an outer context variable no longer resolves the way it does
// everywhere else in the template. #vars.xxx reaches back to the top-level context
// variables explicitly, bypassing whatever #this currently means.
//
// This is not a toy problem -- this project's own fragments/layout.html sidebar hit
// exactly this while computing which category should default to expanded:
// "#vars.activeTopicSlug", never a bare "activeTopicSlug", inside a .?[...] selection
// (see CLAUDE.md's "Bilinen Kısıtlar" for the SpelEvaluationException this caused
// the first time around).
class SelectionExpressionExample {

    record TopicItem(String slug, String title) {
    }

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("activeSlug", "spring-mvc-views-thymeleaf");
        context.setVariable("topics", List.of(
                new TopicItem("spring-mvc-fundamentals", "Spring MVC Fundamentals"),
                new TopicItem("spring-mvc-views-thymeleaf", "Spring MVC Views & Thymeleaf")));

        // #this here refers to each TopicItem in turn; #vars.activeSlug reaches past
        // that rebinding to the context variable set outside the selection.
        String template = """
                <p th:with="matches=${topics.?[#this.slug() == #vars.activeSlug]}"
                   th:text="${matches.size()} + ' match(es): ' + ${matches[0].title()}">
                    result
                </p>
                """;

        System.out.println(engine.process(template, context));
        // 1 match(es): Spring MVC Views &amp; Thymeleaf
    }
}

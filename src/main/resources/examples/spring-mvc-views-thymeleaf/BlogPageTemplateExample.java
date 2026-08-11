import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

import java.util.List;

// Mini project, part 1/2: a tiny blog listing page that combines everything from this
// lesson -- a th:fragment for one post "card", th:each to repeat it, and th:if/
// th:unless for the empty-state message. See BlogPageDemo for how it's driven.
class BlogPageTemplateExample {

    record Post(String title, String excerpt) {
    }

    private static final String TEMPLATE = """
            <div th:fragment="postCard(post)" class="post-card">
                <h3 th:text="${post.title()}">title</h3>
                <p th:text="${post.excerpt()}">excerpt</p>
            </div>

            <section>
                <h2>Blog</h2>
                <div th:if="${#lists.isEmpty(posts)}">No posts yet.</div>
                <div th:unless="${#lists.isEmpty(posts)}">
                    <div th:each="post : ${posts}" th:insert="~{::postCard(${post})}">placeholder</div>
                </div>
            </section>
            """;

    static String render(List<Post> posts) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        context.setVariable("posts", posts);

        return engine.process(TEMPLATE, context);
    }
}

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

// th:text escapes its value (HTML-encodes it) before writing it out; th:utext
// ("unescaped text") writes it out verbatim. This is the exact same escape-by-default
// idea this project relies on for markdown content -- see topic.html's th:utext on
// contentHtml, and its comment about that content being trusted (repo-controlled
// CommonMark output), never raw user input.
class TextVsUtextExample {

    public static void main(String[] args) {
        TemplateEngine engine = new TemplateEngine();
        StringTemplateResolver resolver = new StringTemplateResolver();
        resolver.setTemplateMode(TemplateMode.HTML);
        engine.setTemplateResolver(resolver);

        Context context = new Context();
        // What if this string came from an untrusted source, e.g. a comment form?
        context.setVariable("comment", "<script>alert('xss')</script> nice topic!");

        String template = """
                <p th:text="${comment}">escaped</p>
                <p th:utext="${comment}">not escaped</p>
                """;

        System.out.println(engine.process(template, context));
        // <p>&lt;script&gt;alert('xss')&lt;/script&gt; nice topic!</p>   -- safe to render
        // <p><script>alert('xss')</script> nice topic!</p>              -- the script tag survives
    }
}

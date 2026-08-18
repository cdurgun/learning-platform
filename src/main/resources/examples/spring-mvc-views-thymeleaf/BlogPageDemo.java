import java.util.List;

// Mini project, part 2/2: drives BlogPageTemplateExample with two different inputs --
// a populated list (th:each + the postCard fragment fire) and an empty one (the
// th:if empty-state message fires instead).
class BlogPageDemo {

    public static void main(String[] args) {
        List<BlogPageTemplateExample.Post> posts = List.of(
                new BlogPageTemplateExample.Post(
                        "Spring MVC Views & Thymeleaf",
                        "Model, ModelAndView, and Thymeleaf's basic syntax."),
                new BlogPageTemplateExample.Post(
                        "Validation & Exception Handling",
                        "Bean Validation and RFC 7807 ProblemDetail."));

        System.out.println("With posts:");
        System.out.println(BlogPageTemplateExample.render(posts));
        // <section><h2>Blog</h2><div><div class="post-card">...2 cards...</div></div></section>

        System.out.println("With no posts:");
        System.out.println(BlogPageTemplateExample.render(List.of()));
        // <section><h2>Blog</h2><div>No posts yet.</div></section>
    }
}

// This project has no forms yet -- every page is read-only content. th:object/
// th:field belong to Thymeleaf's Spring-specific form dialect, which needs a real
// @ModelAttribute-backed BindingResult and Spring's RequestDataValueProcessor wired
// through an actual request -- infrastructure this focused example intentionally
// does NOT stand up (see CLAUDE.md's "Örnek Yazım İlkeleri": no unrelated
// infrastructure just to make something independently runnable). Instead, this shows
// what th:object/th:field expand into, so the mechanism is clear if this project
// ever adds a form (e.g. a future "Ek: Mini Proje" comment submission).
class FormBindingExample {

    // The @ModelAttribute-backed object a real controller would put on the Model,
    // e.g. model.addAttribute("commentForm", new CommentForm()).
    static class CommentForm {
        private String author = "";
        private String body = "";

        String getAuthor() {
            return author;
        }

        void setAuthor(String author) {
            this.author = author;
        }

        String getBody() {
            return body;
        }

        void setBody(String body) {
            this.body = body;
        }
    }

    public static void main(String[] args) {
        CommentForm form = new CommentForm();
        form.setAuthor("Ada");

        System.out.println("Template (what you'd write):");
        System.out.println("""
                <form th:object="${commentForm}" method="post">
                    <input type="text" th:field="*{author}"/>
                    <textarea th:field="*{body}"></textarea>
                </form>
                """);

        System.out.println("What th:field expands to for each bound property,");
        System.out.println("given commentForm.author = \"" + form.getAuthor() + "\":");
        System.out.println("""
                <input type="text" id="author" name="author" value="Ada"/>
                <textarea id="body" name="body"></textarea>
                """);
        // th:object="${commentForm}" sets the "current object" *{...} expressions
        // resolve against; th:field="*{author}" reads commentForm.getAuthor() for
        // the value AND derives id/name="author" from the property name -- the same
        // property Spring's DataBinder writes back into on form submission.
    }
}

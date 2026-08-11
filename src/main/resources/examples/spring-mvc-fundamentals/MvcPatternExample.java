import java.util.List;

// Plain Java simulation of the MVC pattern -- no Spring involved yet. The goal is to
// separate three concerns before we let a framework take over the "wiring" for us:
//   Model      -- the data itself, with no knowledge of how it will be displayed.
//   View       -- knows how to turn a Model into an output format (here, a plain
//                 String standing in for an HTML page).
//   Controller -- receives a request, asks a service for data, puts that data into a
//                 Model, and hands the Model to a View.
class MvcPatternExample {

    // --- Model -----------------------------------------------------------------------
    record BookListModel(List<String> titles) {
    }

    // --- View ------------------------------------------------------------------------
    // A real View (Thymeleaf, JSP...) turns a Model into HTML. Here we just build a
    // String, so the example runs without any templating engine.
    static class BookListView {
        String render(BookListModel model) {
            StringBuilder html = new StringBuilder("<ul>\n");
            for (String title : model.titles()) {
                html.append("  <li>").append(title).append("</li>\n");
            }
            html.append("</ul>");
            return html.toString();
        }
    }

    // --- Controller --------------------------------------------------------------------
    static class BookListController {
        private final BookListView view = new BookListView();

        String handle() {
            // In a real app this would come from a service/repository, not a literal.
            BookListModel model = new BookListModel(List.of("Effective Java", "Clean Code"));
            return view.render(model);
        }
    }

    public static void main(String[] args) {
        BookListController controller = new BookListController();
        System.out.println(controller.handle());
        // <ul>
        //   <li>Effective Java</li>
        //   <li>Clean Code</li>
        // </ul>
    }
}

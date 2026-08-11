import java.util.List;

class SearchApiDemo {
    public static void main(String[] args) {
        CatalogSearchController controller = new CatalogSearchController();

        System.out.println(controller.search("books", "spring", List.of("java", "web"), 10, "en"));
        // Searching "spring" in category=books, tags=[java, web], limit=10, language=en

        System.out.println(controller.search("electronics", "headphones", null, 10, null));
        // Searching "headphones" in category=electronics, tags=null, limit=10, language=null
    }
}

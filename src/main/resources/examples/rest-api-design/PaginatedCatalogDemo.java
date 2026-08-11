import org.springframework.data.domain.PageRequest;

import java.util.List;

// Mini project, part 2/2: drives PaginatedCatalogController with a small in-memory
// catalog -- one call with just paging, one adding a category filter, showing the
// filter narrows the total BEFORE paging is applied (totalElements reflects the
// filtered count, not the full catalog).
class PaginatedCatalogDemo {

    public static void main(String[] args) {
        List<PaginatedCatalogController.TopicSummary> catalog = List.of(
                new PaginatedCatalogController.TopicSummary(
                        "spring-mvc-fundamentals", "Spring MVC Fundamentals", "spring-mvc", "INTERMEDIATE"),
                new PaginatedCatalogController.TopicSummary(
                        "advanced-spring-mvc", "Advanced Spring MVC", "spring-mvc", "ADVANCED"),
                new PaginatedCatalogController.TopicSummary(
                        "threads", "Threads", "concurrency", "ADVANCED"));

        PaginatedCatalogController controller = new PaginatedCatalogController(catalog);

        System.out.println(controller.listTopics(null, PageRequest.of(0, 2)));
        // PagedResponse[content=[...2 topics...], page=0, size=2, totalElements=3, totalPages=2]

        System.out.println(controller.listTopics("spring-mvc", PageRequest.of(0, 2)));
        // PagedResponse[content=[...2 spring-mvc topics...], page=0, size=2, totalElements=2, totalPages=1]
        // -- totalElements is 2, not 3: it reflects the filtered set, not the whole catalog
    }
}

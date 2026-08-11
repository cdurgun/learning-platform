import org.springframework.data.domain.Page;

import java.util.List;

// Returning a Page<T> directly from a @RestController works, but Spring Data itself
// warns against it: PageImpl's internal fields aren't a stable, documented API
// contract, and its default JSON shape has changed across Spring Data versions.
// The recommended fix is the same idea as the DTO pattern -- wrap the page in a
// shape YOU control and document, not one an internal class happens to produce.
class PagedResponseShapeExample {

    record TopicSummary(String slug, String title) {
    }

    // A stable, project-owned response shape -- pulls only what a client actually
    // needs out of Page<T>, in field names this project's own API docs can commit to.
    record PagedResponse<T>(List<T> content, int page, int size, long totalElements, int totalPages) {
        static <T> PagedResponse<T> from(Page<T> springDataPage) {
            return new PagedResponse<>(
                    springDataPage.getContent(),
                    springDataPage.getNumber(),
                    springDataPage.getSize(),
                    springDataPage.getTotalElements(),
                    springDataPage.getTotalPages());
        }
    }

    public static void main(String[] args) {
        Page<TopicSummary> springDataPage = new org.springframework.data.domain.PageImpl<>(
                List.of(new TopicSummary("advanced-spring-mvc", "Advanced Spring MVC")),
                org.springframework.data.domain.PageRequest.of(0, 2),
                5);

        PagedResponse<TopicSummary> response = PagedResponse.from(springDataPage);
        System.out.println(response);
        // PagedResponse[content=[TopicSummary[slug=advanced-spring-mvc, ...]], page=0,
        //   size=2, totalElements=5, totalPages=3]

        // Whatever Page<T>'s own serialization looks like in a given Spring Data
        // version, this record's shape doesn't change unless this project changes it.
    }
}

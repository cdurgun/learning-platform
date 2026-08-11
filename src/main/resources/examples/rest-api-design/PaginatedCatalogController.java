import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

// Mini project, part 1/2: combines this lesson's three data-shaping mechanics --
// filtering (?category=), pagination and sorting (Pageable), and a stable response
// shape (PagedResponseShapeExample's pattern) -- into a single catalog endpoint.
@RestController
class PaginatedCatalogController {

    record TopicSummary(String slug, String title, String category, String difficulty) {
    }

    record PagedResponse<T>(List<T> content, int page, int size, long totalElements, int totalPages) {
        static <T> PagedResponse<T> from(Page<T> springDataPage) {
            return new PagedResponse<>(springDataPage.getContent(), springDataPage.getNumber(),
                    springDataPage.getSize(), springDataPage.getTotalElements(), springDataPage.getTotalPages());
        }
    }

    private final List<TopicSummary> allTopics;

    PaginatedCatalogController(List<TopicSummary> allTopics) {
        this.allTopics = allTopics;
    }

    @GetMapping("/api/topics")
    public PagedResponse<TopicSummary> listTopics(
            @RequestParam(required = false) String category,
            Pageable pageable) {

        Predicate<TopicSummary> matchesCategory = Optional.ofNullable(category)
                .<Predicate<TopicSummary>>map(c -> t -> t.category().equals(c))
                .orElse(t -> true);

        List<TopicSummary> filtered = allTopics.stream().filter(matchesCategory).toList();

        int start = Math.min((int) pageable.getOffset(), filtered.size());
        int end = Math.min(start + pageable.getPageSize(), filtered.size());

        Page<TopicSummary> page = new PageImpl<>(filtered.subList(start, end), pageable, filtered.size());
        return PagedResponse.from(page);
    }
}

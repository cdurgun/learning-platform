import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.List;

// Pageable/Page are the same Spring Data types that back JpaRepository (see how
// TopicRepository extends it) -- when a @RestController method takes a Pageable
// parameter, Spring resolves it from ?page=/?size=/?sort= query parameters
// automatically, no manual parsing needed.
class PaginationExample {

    record Topic(String slug, String title) {
    }

    static Page<Topic> findTopics(List<Topic> allTopics, Pageable pageable) {
        int start = (int) pageable.getOffset();
        int end = Math.min(start + pageable.getPageSize(), allTopics.size());
        List<Topic> pageContent = start >= allTopics.size() ? List.of() : allTopics.subList(start, end);
        // A real repository does this in the database (LIMIT/OFFSET); PageImpl here
        // just wraps an already-fetched in-memory list to demonstrate the shape.
        return new PageImpl<>(pageContent, pageable, allTopics.size());
    }

    public static void main(String[] args) {
        List<Topic> allTopics = List.of(
                new Topic("spring-mvc-fundamentals", "Spring MVC Fundamentals"),
                new Topic("mapping-annotations-http-methods", "Mapping Annotations and HTTP Methods"),
                new Topic("path-variables-request-parameters", "Path Variables and Request Parameters"),
                new Topic("request-response-handling", "Request and Response Handling"),
                new Topic("validation-exception-handling", "Validation and Exception Handling"));

        // ?page=0&size=2 -- Spring resolves this into a Pageable automatically when
        // a controller method takes one as a parameter.
        Pageable firstPage = PageRequest.of(0, 2);
        Page<Topic> page1 = findTopics(allTopics, firstPage);

        System.out.println(page1.getContent());
        // [Topic[slug=spring-mvc-fundamentals, ...], Topic[slug=mapping-annotations-http-methods, ...]]
        System.out.println("totalElements=" + page1.getTotalElements() + ", totalPages=" + page1.getTotalPages());
        // totalElements=5, totalPages=3

        Pageable lastPage = PageRequest.of(2, 2);
        Page<Topic> page3 = findTopics(allTopics, lastPage);
        System.out.println(page3.getContent() + ", isLast=" + page3.isLast());
        // [Topic[slug=validation-exception-handling, ...]], isLast=true
    }
}

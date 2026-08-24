import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

// "REST API Design"'s PaginationExample showed a controller resolving a
// Pageable from ?page=/?size= and returning a Page -- but it built the
// Page itself with PageImpl over an ALREADY-FETCHED, in-memory list,
// explicitly noting "a real repository does this in the database." This
// is that real repository method -- an extension to this project's own
// TopicRepository.
interface TopicPagingRepositoryExample extends JpaRepository<TopicExample, Long> {

    // Returning Page<TopicExample> (instead of List<TopicExample>) from a
    // method that takes a Pageable is all that's needed -- Spring Data JPA
    // generates a query with a real LIMIT/OFFSET, PLUS a second query that
    // counts the total matching rows, and packages both into the Page it
    // hands back.
    Page<TopicExample> findByCategoryId(Long categoryId, Pageable pageable);
}

class TopicExample {
}

class PagedRepositoryMethodExample {
    public static void main(String[] args) {
        // In a real application, this Pageable would already have been
        // resolved from ?page=0&size=2 by Spring MVC, exactly as "REST API
        // Design" covered -- constructed by hand here only to call the
        // repository method directly, outside of a running application.
        Pageable firstPage = PageRequest.of(0, 2);

        System.out.println(firstPage);
        // repository.findByCategoryId(5L, firstPage) would now run TWO real
        // queries against PostgreSQL: one SELECT ... LIMIT 2 OFFSET 0, and
        // one SELECT COUNT(*) -- see "What Actually Happens Underneath."
    }
}

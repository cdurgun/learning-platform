import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

// Sort composes with Pageable -- a client can ask for ?sort=difficulty,asc&sort=title,desc
// and Spring resolves it into exactly the Sort object built here by hand.
class SortingExample {

    public static void main(String[] args) {
        Sort byDifficultyThenTitle = Sort.by(Sort.Direction.ASC, "difficulty")
                .and(Sort.by(Sort.Direction.DESC, "title"));

        System.out.println(byDifficultyThenTitle);
        // difficulty: ASC,title: DESC

        // Combined with paging into a single Pageable, exactly what a
        // @RestController parameter of type Pageable resolves to from query
        // parameters like ?page=0&size=10&sort=difficulty,asc&sort=title,desc:
        Pageable pageable = PageRequest.of(0, 10, byDifficultyThenTitle);
        System.out.println("page=" + pageable.getPageNumber() + ", sort=" + pageable.getSort());
        // page=0, sort=difficulty: ASC,title: DESC

        // A shorthand for a single field:
        Pageable simpleSort = PageRequest.of(0, 10, Sort.by("title"));
        System.out.println(simpleSort.getSort());
        // title: ASC  -- Sort.by(String...) defaults to ascending
    }
}

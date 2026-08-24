import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

interface TopicSortingRepositoryExample extends JpaRepository<TopicSortExample, Long> {

    // findAll(Sort sort) isn't written here at all -- it comes directly
    // from PagingAndSortingRepository, exactly as covered in "Entities and
    // the Repository Abstraction." No new method needed to sort every
    // Topic by an arbitrary field.

    // A derived method can ALSO accept a Sort parameter, combining a
    // filter condition with caller-supplied ordering -- CategoryId narrows
    // the rows, Sort decides what order they come back in.
    List<TopicSortExample> findByCategoryId(Long categoryId, Sort sort);
}

class TopicSortExample {
}

class SortAtRepositoryLevelExample {
    public static void main(String[] args) {
        // Sort.by(...).and(...) construction itself was already covered in
        // "REST API Design" -- this is the exact same Sort object, now
        // handed to a repository method instead of just resolved from
        // query parameters.
        Sort bySortOrder = Sort.by(Sort.Direction.ASC, "sortOrder");

        System.out.println(bySortOrder);
        // repository.findAll(bySortOrder) -- every Topic, ordered by sortOrder
        // repository.findByCategoryId(5L, bySortOrder) -- only category 5's
        //     Topics, in the same order
    }
}

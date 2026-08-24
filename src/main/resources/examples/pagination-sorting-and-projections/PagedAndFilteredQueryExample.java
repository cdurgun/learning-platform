import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

interface TopicDifficultyPagingRepositoryExample extends JpaRepository<TopicDifficultyExample, Long> {

    // A single Pageable already carries BOTH paging (page/size) AND
    // sorting information (Pageable has its own embedded Sort) -- no
    // separate Sort parameter is needed here at all.
    Page<TopicDifficultyExample> findByDifficulty(String difficulty, Pageable pageable);
}

class TopicDifficultyExample {
}

class PagedAndFilteredQueryExample {
    public static void main(String[] args) {
        // A Pageable built WITH a Sort attached -- PageRequest.of(page,
        // size, sort) -- carries paging and ordering together in one object.
        Pageable secondPageOrderedBySlug = PageRequest.of(1, 5, Sort.by("slug"));

        System.out.println(secondPageOrderedBySlug);
        // repository.findByDifficulty("INTERMEDIATE", secondPageOrderedBySlug)
        // generates one query filtering by difficulty, ordering by slug,
        // and applying LIMIT 5 OFFSET 5 -- all three concerns, from one
        // method call.
    }
}

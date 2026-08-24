import org.springframework.data.jpa.repository.JpaRepository;

// This project's own CategoryRepository (see src/main/java/com/cdurgun/
// learning/repository/CategoryRepository.java) -- one line, three
// inherited tiers of behavior underneath it.
interface CategoryRepositoryExample extends JpaRepository<CategoryExample, Long> {

    // --- From Repository (the root, marker interface) ---
    // Contributes no methods at all -- it exists purely so Spring Data can
    // recognize "this interface is a repository" and generate a bean for it.

    // --- From CrudRepository ---
    // save(category), findById(id), findAll(), count(), existsById(id),
    // deleteById(id), delete(category), deleteAll() -- the basic create/
    // read/update/delete operations every repository needs, written ONCE
    // in Spring Data JPA's own code, inherited here for free.

    // --- From PagingAndSortingRepository (which JpaRepository also extends) ---
    // findAll(Sort sort), findAll(Pageable pageable) -- sorted and paged
    // reads, without a single line of query code. "Pagination, Sorting,
    // and Projections," later in this category, covers using these for real.

    // --- From JpaRepository itself (the most specific tier) ---
    // flush() (forces pending changes to the database immediately),
    // saveAndFlush(category), deleteAllInBatch() (a single bulk DELETE
    // instead of one per row) -- JPA-specific operations the more generic
    // tiers above don't know about.
}

class CategoryExample {
}

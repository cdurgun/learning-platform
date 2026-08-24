import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// An INTERFACE PROJECTION: instead of the full Topic entity (id, category,
// slug, difficulty, estimatedMinutes, sortOrder, and any relationships it
// carries), only THREE fields are actually needed here. Declaring an
// interface with getters matching a subset of the entity's property names
// is enough -- no implementation is written for it.
interface TopicSummary {
    String getSlug();
    String getDifficulty();
    Integer getEstimatedMinutes();
}

interface TopicProjectionRepositoryExample extends JpaRepository<TopicProjectionExample, Long> {

    // Spring Data JPA generates a proxy implementing TopicSummary at
    // runtime, and -- this is the real benefit, not just less Java code --
    // generates a SQL SELECT that names only slug/difficulty/
    // estimated_minutes, not every column the full entity would require.
    List<TopicSummary> findByCategoryId(Long categoryId);
}

class TopicProjectionExample {
}

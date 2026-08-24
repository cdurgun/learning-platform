import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

// This project's own CodeExampleRepository (see src/main/java/com/cdurgun/
// learning/repository/CodeExampleRepository.java) -- two methods, zero
// SQL/JPQL written anywhere. Spring Data JPA parses each method's NAME at
// startup and builds a query from it.
interface CodeExampleRepositoryExample extends JpaRepository<CodeExampleExample, Long> {

    // "findBy" + "TopicId" + "OrderBy" + "SortOrder" + "Asc" is parsed as:
    //   SELECT * FROM code_example
    //   WHERE topic_id = ?
    //   ORDER BY sort_order ASC
    // "TopicId" resolves to the entity's "topic" relationship's id --
    // Spring Data JPA understands nested property paths, not just direct
    // fields.
    List<CodeExampleExample> findByTopicIdOrderBySortOrderAsc(Long topicId);

    // "findBy" + "TopicId" + "And" + "ExampleName" is parsed as:
    //   SELECT * FROM code_example
    //   WHERE topic_id = ? AND example_name = ?
    // Parameters are matched to conditions IN ORDER -- the first parameter
    // (topicId) binds to the first condition (TopicId), the second
    // (exampleName) to the second (ExampleName).
    Optional<CodeExampleExample> findByTopicIdAndExampleName(Long topicId, String exampleName);
}

class CodeExampleExample {
}

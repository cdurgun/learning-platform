import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

// This project's own QuizRepository has the single most keyword-dense
// derived query method in the codebase -- a good specimen for seeing
// several naming keywords used together.
interface QuizRepositoryExample extends JpaRepository<QuizExample, Long> {

    // findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc breaks down as:
    //
    //   findFirst        -> LIMIT 1 (return one result, not a List)
    //   By                -> begins the condition clause
    //   TopicId           -> WHERE topic_id = ?          (1st parameter)
    //   And               -> combine with AND
    //   Language          -> AND language = ?             (2nd parameter)
    //   And               -> combine with AND
    //   ActiveTrue        -> AND active = true             (NO parameter --
    //                        "True"/"False" are LITERAL values, not
    //                        placeholders, for a boolean property)
    //   OrderByIdAsc      -> ORDER BY id ASC
    //
    // Two parameters go in (topicId, language) even though the method
    // name mentions three conditions -- ActiveTrue supplies its own value.
    Optional<QuizExample> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(Long topicId, String language);

    // Two more derived prefixes this project doesn't happen to use, but
    // follow the identical parsing rules -- notice each returns a
    // different, purpose-built type instead of the entity itself:
    //
    //   existsByTopicIdAndLanguage(Long topicId, String language) -> boolean
    //     (a single SELECT EXISTS(...) query -- avoids loading a whole
    //     entity just to check whether one is present)
    //
    //   countByTopicId(Long topicId) -> long
    //     (a single SELECT COUNT(*) query -- avoids loading any rows at
    //     all just to know how many there are)
}

class QuizExample {
}

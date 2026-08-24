import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

// This project's own real service tests (QuizServiceTest,
// QuestionIngestServiceTest, and the rest) mock every repository with
// Mockito, exactly like this -- a perfectly good way to test a SERVICE's
// own logic in isolation. But it has a blind spot worth being explicit
// about.
interface TopicRepositoryMockExample {
    Optional<Object> findBySlug(String slug);
}

@ExtendWith(MockitoExtension.class)
class MockedRepositoryLimitationExample {

    @Mock
    TopicRepositoryMockExample repository;

    @Test
    void thisTestPassesEvenThoughItProvesNothingAboutTheRealQuery() {
        // when(...) tells the mock exactly what to return -- it never
        // asks Spring Data JPA to actually parse "findBySlug" into a
        // query, and never runs anything against a real database.
        when(repository.findBySlug("records")).thenReturn(Optional.of(new Object()));

        Optional<Object> result = repository.findBySlug("records");

        assertThat(result).isPresent(); // passes -- but proves nothing
        // If the REAL findBySlug(...) method were misspelled as
        // "findBySlgu(...)", or if it filtered on the wrong column
        // entirely, this test would still pass -- it only verifies the
        // MOCK's own configured behavior, never the real, generated
        // query. Testing that the query itself is correct needs a real
        // persistence layer running underneath -- covered next.
    }
}

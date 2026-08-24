import java.time.LocalDateTime;

// This is the SAME pattern as this project's own real
// QuestionIngestService -- it builds a Question with
// .createdAt(LocalDateTime.now()).updatedAt(LocalDateTime.now()), by hand,
// right there in the service method. Nothing is technically wrong with
// this, but it's a pattern that has to be repeated correctly in EVERY
// place that creates or updates ANY audited entity -- forget it once, in
// one service method, and that row's timestamp is silently wrong.
class ManualTimestampProblemExample {

    record Question(String text, LocalDateTime createdAt, LocalDateTime updatedAt) {
    }

    static Question createQuestion(String text) {
        LocalDateTime now = LocalDateTime.now();
        return new Question(text, now, now); // set by hand, exactly like this project's QuestionIngestService
    }

    static Question updateQuestion(Question existing, String newText) {
        // Every single update site also needs to remember this line --
        // and remember it EVERY time, not just once.
        return new Question(newText, existing.createdAt(), LocalDateTime.now());
    }
}

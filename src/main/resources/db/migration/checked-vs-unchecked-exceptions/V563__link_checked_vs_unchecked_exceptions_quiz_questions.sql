-- Promotion-style migration linking EN checked-vs-unchecked-exceptions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which correctly defines a checked exception?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which correctly defines a checked exception?$$,
           NULL, NULL,
           $$A checked exception is any class under Exception that is NOT RuntimeException (like IOException, SQLException); if a method can throw one, it must declare it with throws.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$Any subclass of RuntimeException.$$, FALSE, 0),
    ($$Any class under Exception that is NOT RuntimeException.$$, TRUE, 1),
    ($$Any subclass of Error.$$, FALSE, 2),
    ($$Any exception without a message constructor.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method calls another method that declares `throws IOException`. What must the calling method do?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A method calls another method that declares `throws IOException`. What must the calling method do?$$,
           NULL, NULL,
           $$Every piece of code that calls a method declaring a checked exception must either catch it or declare it with throws in its own signature too -- there is no third option, the compiler doesn't allow it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$Nothing -- IOException is unchecked so no action is required.$$, FALSE, 0),
    ($$Either catch IOException or declare throws IOException itself -- there is no third option.$$, TRUE, 1),
    ($$Only declare throws IOException; catching is never allowed.$$, FALSE, 2),
    ($$Only catch it; declaring throws is never allowed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.io.IOException;

public class Demo {
    static void load() {
        try {
            throw new IOException("disk error");
        } catch (IOException e) {
            throw new RuntimeException("load failed", e);
        }
    }
    public static void main(String[] args) {
        try {
            load();
        } catch (RuntimeException e) {
            System.out.println(e.getMessage() + " / cause: " + e.getCause().getMessage());
        }
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.io.IOException;

public class Demo {
    static void load() {
        try {
            throw new IOException("disk error");
        } catch (IOException e) {
            throw new RuntimeException("load failed", e);
        }
    }
    public static void main(String[] args) {
        try {
            load();
        } catch (RuntimeException e) {
            System.out.println(e.getMessage() + " / cause: " + e.getCause().getMessage());
        }
    }
}$$, $$java$$,
           $$The IOException is caught and wrapped using RuntimeException's cause constructor -- the original exception's message is preserved and accessible via getCause().getMessage(), even though it's no longer forced on the caller.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$load failed / cause: disk error$$, TRUE, 0),
    ($$disk error / cause: load failed$$, FALSE, 1),
    ($$Compile error -- load() must declare throws IOException$$, FALSE, 2),
    ($$load failed / cause: null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Source {
    String read() throws IOException;
}

class StrictSource implements Source {
    public String read() throws FileNotFoundException {
        return "data";
    }
}

public class Demo {
    public static void main(String[] args) throws IOException {
        Source s = new StrictSource();
        System.out.println(s.read());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Source {
    String read() throws IOException;
}

class StrictSource implements Source {
    public String read() throws FileNotFoundException {
        return "data";
    }
}

public class Demo {
    public static void main(String[] args) throws IOException {
        Source s = new StrictSource();
        System.out.println(s.read());
    }
}$$, $$java$$,
           $$When overriding a method, you may declare a narrower subtype of the checked exceptions the interface declared -- FileNotFoundException is a subtype of IOException, so this is legal narrowing and the code compiles and runs normally.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$Compiles, prints "data".$$, TRUE, 0),
    ($$Fails to compile because StrictSource.read() doesn't declare throws IOException.$$, FALSE, 1),
    ($$Fails to compile because FileNotFoundException is unrelated to IOException.$$, FALSE, 2),
    ($$Compiles but throws FileNotFoundException at runtime.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are good reasons, per this lesson's guideline, to use a checked exception rather than an unchecked one? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are good reasons, per this lesson's guideline, to use a checked exception rather than an unchecked one? (Select all that apply)$$,
           NULL, NULL,
           $$If the caller can reasonably recover from the condition, or the condition is an external, expected-but-uncontrollable failure (like a missing file), a checked exception makes sense.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$The caller can reasonably recover from the condition.$$, TRUE, 0),
    ($$The condition is an external, expected-but-uncontrollable failure, like a missing file.$$, TRUE, 1),
    ($$The condition represents a programming error, like a null reference.$$, FALSE, 2),
    ($$You want to avoid ever declaring throws on your method.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's History section, why was `java.io.UncheckedIOException` added in Java 8?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's History section, why was `java.io.UncheckedIOException` added in Java 8?$$,
           NULL, NULL,
           $$Over time, the community realized checked exceptions weren't the right tool for every situation -- Java's own standard library eventually added RuntimeException-based alternatives like UncheckedIOException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$Because checked exceptions were removed from the language in Java 8.$$, FALSE, 0),
    ($$Because the community realized checked exceptions weren't the right tool for every situation, prompting an unchecked alternative.$$, TRUE, 1),
    ($$Because IOException was renamed.$$, FALSE, 2),
    ($$Because C++ required it for interoperability.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following is identified as a common mistake in this lesson?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following is identified as a common mistake in this lesson?$$,
           NULL, NULL,
           $$Common Mistakes explicitly calls out assuming checked exceptions are always "better" or "more professional" -- in practice, modern Java tends to favor unchecked exceptions.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$Assuming checked exceptions are always "better" or "more professional" than unchecked ones.$$, TRUE, 0),
    ($$Using RuntimeException for a programming error.$$, FALSE, 1),
    ($$Passing the original exception as cause when wrapping.$$, FALSE, 2),
    ($$Declaring throws for a checked exception a method can genuinely throw.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking EN throw-and-throws quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly distinguishes `throw` from `throws`?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly distinguishes `throw` from `throws`?$$,
           NULL, NULL,
           $$throw is a statement that executes at a specific point in code and immediately hands a Throwable instance to the JVM at runtime; throws is a declaration on a method signature, purely compile-time bookkeeping.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$throw is a compile-time declaration; throws is a runtime statement.$$, FALSE, 0),
    ($$throw is a runtime statement that hands a Throwable to the JVM; throws is a compile-time declaration on a method signature.$$, TRUE, 1),
    ($$Both are runtime statements with identical behavior.$$, FALSE, 2),
    ($$throws can only be used with unchecked exceptions.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when compiling this?$$
      AND code_snippet = $$public class Demo {
    static void reject() {
        throw new IllegalStateException("not allowed");
        System.out.println("after");
    }
    public static void main(String[] args) {
        reject();
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when compiling this?$$,
           $$public class Demo {
    static void reject() {
        throw new IllegalStateException("not allowed");
        System.out.println("after");
    }
    public static void main(String[] args) {
        reject();
    }
}$$, $$java$$,
           $$Any code written directly after an unconditional throw is unreachable, and the compiler rejects it outright -- there is nothing to "return" from, and nowhere to place code after it in that same block.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$Fails to compile -- the System.out.println line is unreachable.$$, TRUE, 0),
    ($$Prints "after" then throws.$$, FALSE, 1),
    ($$Throws IllegalStateException silently, "after" is never printed.$$, FALSE, 2),
    ($$Compiles and runs, printing nothing.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$public class Demo {
    static int parseConfig(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalStateException("configuration file is corrupt", e);
        }
    }
    public static void main(String[] args) {
        try {
            parseConfig("abc");
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage() + " caused by " + e.getCause().getClass().getSimpleName());
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
           $$public class Demo {
    static int parseConfig(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalStateException("configuration file is corrupt", e);
        }
    }
    public static void main(String[] args) {
        try {
            parseConfig("abc");
        } catch (IllegalStateException e) {
            System.out.println(e.getMessage() + " caused by " + e.getCause().getClass().getSimpleName());
        }
    }
}$$, $$java$$,
           $$parseConfig catches the low-level NumberFormatException and rethrows a more meaningful IllegalStateException, passing the original as cause -- so both the new message and the original exception's type remain accessible.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$configuration file is corrupt caused by NumberFormatException$$, TRUE, 0),
    ($$abc caused by IllegalStateException$$, FALSE, 1),
    ($$Compile error -- parseConfig must declare throws$$, FALSE, 2),
    ($$configuration file is corrupt caused by null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$True or false: declaring `throws SomeException` on a method reduces or catches that exception in some way.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$True or false: declaring `throws SomeException` on a method reduces or catches that exception in some way.$$,
           NULL, NULL,
           $$Declaring throws SomeException does not catch or reduce the exception in any way -- it only shifts the compiler's obligation to whoever calls the method. If nothing up the call chain ever catches it, it still terminates the program when uncaught.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$True -- it automatically catches the exception if no caller does.$$, FALSE, 0),
    ($$False -- it only shifts the compiler's obligation to the caller; if nothing ever catches it, the program still terminates.$$, TRUE, 1),
    ($$True -- it converts the exception to an unchecked one.$$, FALSE, 2),
    ($$False -- throws has no effect on checked exceptions at all.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Best Practices recommend validating arguments and throwing at the very top of a method (fail fast), and always passing the original exception as cause when rethrowing a different type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$Validate arguments and throw at the very top of a method -- fail fast.$$, TRUE, 0),
    ($$When rethrowing a different exception type, always pass the original as the cause.$$, TRUE, 1),
    ($$Add throws declarations defensively, "just in case," even if the method can't actually throw them.$$, FALSE, 2),
    ($$Prefer a generic throw new RuntimeException("error") over a more descriptive exception type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the `throw` statement operate on?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does the `throw` statement operate on?$$,
           NULL, NULL,
           $$throw takes a single Throwable instance -- usually one you construct on the spot with new -- and transfers control away from that point immediately.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$A String message describing the failure.$$, FALSE, 0),
    ($$A single Throwable instance, usually constructed on the spot with new.$$, TRUE, 1),
    ($$A class name only, without instantiation.$$, FALSE, 2),
    ($$An integer error code.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's "Why Does It Exist?" section, what problem would remain even if `throw` existed but `throws` did not?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "Why Does It Exist?" section, what problem would remain even if `throw` existed but `throws` did not?$$,
           NULL, NULL,
           $$Without throws, a checked exception thrown deep inside a call chain would have no compiler-verified path back to whoever needs to handle it -- every method in between could silently forget about it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$There would be no way to signal a failure at all.$$, FALSE, 0),
    ($$A checked exception thrown deep in a call chain would have no compiler-verified path back to a handler -- any method in between could silently forget it.$$, TRUE, 1),
    ($$All exceptions would automatically become unchecked.$$, FALSE, 2),
    ($$Methods would be unable to declare any exceptions at all.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

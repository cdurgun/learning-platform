-- Links the EN exception-handling-best-practices questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method throws a custom `FoundException` only to leave a loop once it has found a matching value. Why is this an anti-pattern?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A method throws a custom `FoundException` only to leave a loop once it has found a matching value. Why is this an anti-pattern?$$,
           NULL, NULL,
           $$Finding a match is a completely ordinary outcome, and `return` or `break` already expresses it. Using `throw` and `catch` for that job abuses a mechanism built for error propagation, costs runtime because a stack trace has to be built, and is harder to read. Nothing prevents throwing from a loop; it is simply the wrong tool.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Finding a match is an ordinary outcome that a plain `return` or `break` already handles$$, TRUE, 0),
        ($$A custom exception cannot be thrown from inside a loop$$, FALSE, 1),
        ($$An exception thrown inside a loop cannot be caught outside it$$, FALSE, 2),
        ($$The loop keeps running after the exception has been thrown$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$public class Demo {
    static int parsePort(String text) {
        try {
            return Integer.parseInt(text);
        } catch (NumberFormatException e) {
        }
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(parsePort("80a"));
        System.out.println(parsePort("0"));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$public class Demo {
    static int parsePort(String text) {
        try {
            return Integer.parseInt(text);
        } catch (NumberFormatException e) {
        }
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(parsePort("80a"));
        System.out.println(parsePort("0"));
    }
}$$, $$java$$,
           $$Parsing `80a` fails, but the empty `catch` block discards the exception completely and the method falls through to `return 0`. The second call returns a genuine `0`. Both lines look identical, which is exactly the damage: the caller cannot tell a real port `0` from a failure that was silently swallowed, and no stack trace is ever printed.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$A `NumberFormatException` stack trace, then `0`$$, FALSE, 0),
        ($$`0`, then `0`$$, TRUE, 1),
        ($$`80`, then `0`$$, FALSE, 2),
        ($$`-1`, then `0`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A `try` has two `catch` blocks, one for `RuntimeException` and one for `NumberFormatException`. Which order does Java accept?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A `try` has two `catch` blocks, one for `RuntimeException` and one for `NumberFormatException`. Which order does Java accept?$$,
           NULL, NULL,
           $$`NumberFormatException` is a subtype of `RuntimeException`. Java requires `catch` blocks to go from most specific to least specific, and the compiler rejects a supertype placed before its subtype, because the later block could never be reached. The order is therefore not a matter of taste.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$`RuntimeException` first, then `NumberFormatException`$$, FALSE, 0),
        ($$Either order, since the best match is chosen at runtime$$, FALSE, 1),
        ($$`NumberFormatException` first, then `RuntimeException`$$, TRUE, 2),
        ($$Neither, since a `try` can have only one `catch` block$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When does a `catch` block earn its place in a method?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$When does a `catch` block earn its place in a method?$$,
           NULL, NULL,
           $$A `catch` belongs where the method has enough context to respond: retry, fall back to a default, or translate the failure for its own caller. Being able to catch is not a reason to catch. A method with no such response should let the exception propagate to a layer that has one.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Whenever the method calls code that is able to throw an exception$$, FALSE, 0),
        ($$Whenever the exception would otherwise travel up as far as `main`$$, FALSE, 1),
        ($$Only when the exception being caught is a checked exception$$, FALSE, 2),
        ($$When the method can respond meaningfully, for example by retrying or using a default$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these are habits to avoid? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of these are habits to avoid? (Select all that apply)$$,
           NULL, NULL,
           $$An empty `catch (Exception e) {}` left in place hides every failure that reaches it, and a custom exception whose only job is to exit a loop is control flow in disguise. Keeping the original exception as the `cause` when wrapping, and letting an exception propagate when the method cannot handle it, are both recommended practices.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Writing `catch (Exception e) {}` as a temporary measure and never returning to it$$, TRUE, 0),
        ($$Keeping the original exception as the `cause` when wrapping it in another type$$, FALSE, 1),
        ($$Designing a custom exception only to break out of a loop$$, TRUE, 2),
        ($$Letting an exception propagate when the method cannot handle it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

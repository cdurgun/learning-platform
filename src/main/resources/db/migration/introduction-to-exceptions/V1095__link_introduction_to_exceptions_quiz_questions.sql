-- Links the EN introduction-to-exceptions questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What weakness of signalling failure through a return value, such as `-1`, do exceptions remove?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What weakness of signalling failure through a return value, such as `-1`, do exceptions remove?$$,
           NULL, NULL,
           $$A special return value only works if every caller remembers to check it, and forgetting is easy and silent. An exception separates the failure path from the return value entirely: if nobody handles it, it is loud rather than quiet. Speed has nothing to do with it; exceptions are not the faster option.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$A caller can forget to check the value, and the failure then passes unnoticed$$, TRUE, 0),
        ($$A method in Java cannot return a number to indicate a result$$, FALSE, 1),
        ($$Checking a return value is slower than throwing an exception$$, FALSE, 2),
        ($$A return value can be read only once by the calling method$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these statements about an exception object are true? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of these statements about an exception object are true? (Select all that apply)$$,
           NULL, NULL,
           $$The stack trace is captured automatically when the exception object is created, and a cause is an optional reference to the exception that triggered this one. A message is usually supplied when the exception is created, but it is not guaranteed: an exception created without one returns `null` from `getMessage()`. The return value of the failing method is not part of the exception at all.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$It stores the value the failing method would have returned$$, FALSE, 0),
        ($$It always holds a message, so `getMessage()` never returns `null`$$, FALSE, 1),
        ($$It records a stack trace of the methods that were active when it was created$$, TRUE, 2),
        ($$It can carry a cause: another exception that triggered it$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$System.out.println("Start");

int[] values = {1, 2, 3};
System.out.println(values[3]);

System.out.println("End");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$System.out.println("Start");

int[] values = {1, 2, 3};
System.out.println(values[3]);

System.out.println("End");$$, $$java$$,
           $$`Start` is printed, then `values[3]` reads an index that does not exist and the JVM throws `ArrayIndexOutOfBoundsException`. Nothing catches it, so the program stops at that exact line and `End` is never printed. An uncaught exception does not report an error and then carry on.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$`Start` is printed, an error is reported, and then `End` is printed$$, FALSE, 0),
        ($$`Start` is printed, then the program stops with an `ArrayIndexOutOfBoundsException`$$, TRUE, 1),
        ($$`Start`, `0` and `End` are printed, because a missing element reads as `0`$$, FALSE, 2),
        ($$Nothing is printed, because the code does not compile$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`main` calls `processOrder`, which calls `validateQuantity`, which throws an exception that nothing catches. What happens to the line in `processOrder` that comes right after the call to `validateQuantity`?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`main` calls `processOrder`, which calls `validateQuantity`, which throws an exception that nothing catches. What happens to the line in `processOrder` that comes right after the call to `validateQuantity`?$$,
           NULL, NULL,
           $$The exception propagates upward one frame at a time: out of `validateQuantity`, through `processOrder`, to `main`. Every line after the throw point in each of those methods is skipped, so the line after the call never runs. The methods further up are not allowed to finish first.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$It runs, because only `validateQuantity` itself is interrupted$$, FALSE, 0),
        ($$It runs, and the exception is reported after `processOrder` finishes$$, FALSE, 1),
        ($$It runs once the exception has been printed by `main`$$, FALSE, 2),
        ($$It never runs, because the exception propagates up through `processOrder`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which exception does `Integer.parseInt("12a")` throw?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which exception does `Integer.parseInt("12a")` throw?$$,
           NULL, NULL,
           $$The text is not a valid number, so parsing it throws `NumberFormatException`. `ArithmeticException` comes from operations such as integer division by zero, and `ClassCastException` from casting an object to a type it is not.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$`NumberFormatException`$$, TRUE, 0),
        ($$`ArithmeticException`$$, FALSE, 1),
        ($$`ClassCastException`$$, FALSE, 2),
        ($$`NullPointerException`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking EN Wrapper Classes & Autoboxing quiz
-- questions to the topic's fixed quiz created in wrapper-classes/V530 --
-- same pattern as arrays/V523 and scanner/V527 (WITH ... RETURNING id +
-- NOT EXISTS dedup + ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 420, 421, 422, 423, 424
-- Topic: wrapper-classes (language: en)
-- These are ALL 5 EN questions PUBLISHED for this topic (question-
-- promotion/V529 -- 1 via AI Judge auto-publish, 4 via human ADMIN review
-- correcting AI Judge false-negative rejections). No selection/omission --
-- the entire published EN pool is linked.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (V529 will
-- already have created these rows, so this migration's own fallback INSERT
-- branch is a safe no-op that only supplies the quiz_question_link), and a
-- safe no-op if re-run against this development database. The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).

-- Question 1/5 (dev id 420, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about autoboxing and autounboxing are true?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following statements about autoboxing and autounboxing are true?$$, NULL, NULL,
           $$Both statements are correct; autoboxing automatically converts a primitive to a wrapper, while autounboxing converts a wrapper back to a primitive. This automatic conversion is what makes working with collections easier.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:47:34.768716',
           now(), now()
    FROM topic
    WHERE slug = 'wrapper-classes'
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
    ($$Autoboxing converts a primitive value into its wrapper object.$$, TRUE, 0),
    ($$Autounboxing converts a wrapper object back into its primitive value.$$, TRUE, 1),
    ($$Autoboxing can only be done manually.$$, FALSE, 2),
    ($$Autounboxing can lead to NullPointerExceptions if the wrapper is null.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (dev id 421, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when you try to unbox a null wrapper in Java?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What happens when you try to unbox a null wrapper in Java?$$, NULL, NULL,
           $$Unboxing a null wrapper throws a NullPointerException, which is a significant pitfall when dealing with wrapper classes. This is crucial to remember when working with methods that can return null.$$, $$n8n-ai-judge$$, '2026-08-31 22:44:57.280986',
           now(), now()
    FROM topic
    WHERE slug = 'wrapper-classes'
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
    ($$It returns 0.$$, FALSE, 0),
    ($$It throws a NullPointerException.$$, TRUE, 1),
    ($$It returns null.$$, FALSE, 2),
    ($$It returns an empty string.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (dev id 422, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will be the output of the following code?$$
      AND code_snippet = $$Integer a = 100; Integer b = 100; System.out.println(a == b);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$,
           $$Integer a = 100; Integer b = 100; System.out.println(a == b);$$, $$java$$,
           $$The output will be true because both Integer objects are within the cached range of -128 to 127, meaning they refer to the same cached object. However, using == for comparison is unreliable outside this range.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:47:39.342209',
           now(), now()
    FROM topic
    WHERE slug = 'wrapper-classes'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$NullPointerException$$, FALSE, 2),
    ($$100$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (dev id 423, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Identify the best practices when working with wrapper classes.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Identify the best practices when working with wrapper classes.$$, NULL, NULL,
           $$Using equals() for comparison and avoiding direct assignment of null to primitive variables are critical practices to prevent errors and ensure reliable behavior with wrapper classes.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:47:44.027025',
           now(), now()
    FROM topic
    WHERE slug = 'wrapper-classes'
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
    ($$Always use equals() when comparing wrapper objects.$$, TRUE, 0),
    ($$Assign null directly to primitive variables.$$, FALSE, 1),
    ($$Use primitive types in tight loops instead of wrapper types.$$, TRUE, 2),
    ($$Ignore NumberFormatException when parsing user input.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (dev id 424, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why should you not use == when comparing two Integer objects?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Why should you not use == when comparing two Integer objects?$$, NULL, NULL,
           $$Using == can lead to unreliable results due to Integer caching, which only applies to values from -128 to 127. Always use equals() for accurate comparison.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:47:52.318631',
           now(), now()
    FROM topic
    WHERE slug = 'wrapper-classes'
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
    ($$It is always faster than equals().$$, FALSE, 0),
    ($$It can return true for some values and false for others.$$, TRUE, 1),
    ($$It is the recommended method for all object comparisons.$$, FALSE, 2),
    ($$It does not work with wrapper classes.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

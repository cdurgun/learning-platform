-- Promotion-style migration linking EN Arrays quiz questions to the topic's
-- fixed quiz created in arrays/V522 -- same pattern as git-fundamentals/
-- V467-V468 and string/V491 (WITH ... RETURNING id + NOT EXISTS dedup +
-- ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 367, 368, 369, 370, 371, 372, 373
-- Topic: arrays (language: en)
-- These are ALL 7 EN questions PUBLISHED for this topic (question-
-- promotion/V520 -- AI Judge auto-publish -- and V521 -- human ADMIN
-- review via QuestionReviewService.publish, same business logic as the
-- real Admin UI). Unlike string's V491 (which selected 10 of a larger
-- published pool), arrays' entire published EN pool is small enough to
-- link in full -- no selection/omission involved.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (where V520/
-- V521 will have already created these rows, so this migration's own
-- fallback INSERT branch is a safe no-op that only supplies the
-- quiz_question_link), and a safe no-op if re-run against this development
-- database. The quiz_question_link insert carries ON CONFLICT DO NOTHING as
-- a second safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id,
-- position) from V290).

-- Question 1/7 (dev id 367, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the primary characteristic that distinguishes an array from a collection like ArrayList?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What is the primary characteristic that distinguishes an array from a collection like ArrayList?$$, NULL, NULL,
           $$An array has a fixed size that cannot change after creation, while collections like ArrayList can dynamically resize. This fundamental difference is key to understanding their usage.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.321481',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$Arrays can hold elements of different types.$$, FALSE, 0),
    ($$Arrays have a fixed size that cannot change after creation.$$, TRUE, 1),
    ($$Arrays can be resized dynamically during runtime.$$, FALSE, 2),
    ($$Arrays are always more efficient than collections.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (dev id 368, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about the Arrays utility class are true?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following statements about the Arrays utility class are true?$$, NULL, NULL,
           $$The Arrays utility class provides methods like sort(), equals(), and fill(). It does not compare references but contents with equals(). The statement about copyOfRange() is also correct as it creates a new array.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.340846',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$Arrays.equals() compares the contents of two arrays.$$, TRUE, 0),
    ($$Arrays.sort() creates a new sorted array.$$, FALSE, 1),
    ($$Arrays.fill() sets every element of an array to a specified value.$$, TRUE, 2),
    ($$Arrays.copyOfRange() can create a new array from a specified range.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (dev id 369, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will happen if you try to access an index that is out of bounds in an array?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will happen if you try to access an index that is out of bounds in an array?$$, NULL, NULL,
           $$Accessing an out-of-bounds index will throw an ArrayIndexOutOfBoundsException, which is a runtime error indicating that the index is not valid for the array's size.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.83085',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$It will return null.$$, FALSE, 0),
    ($$It will throw an ArrayIndexOutOfBoundsException.$$, TRUE, 1),
    ($$It will silently return a default value.$$, FALSE, 2),
    ($$It will print an error message to the console.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (dev id 370, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will be the output of the following code?$$
      AND code_snippet = $$int[] numbers = new int[5];
System.out.println(Arrays.toString(numbers));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$,
           $$int[] numbers = new int[5];
System.out.println(Arrays.toString(numbers));$$, $$java$$,
           $$The output will show the contents of the numbers array, which has been initialized with default values of 0 for each element. Arrays.toString() correctly formats the output.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.36254',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$[0, 0, 0, 0, 0]$$, TRUE, 0),
    ($$[I@7ea987ac$$, FALSE, 1),
    ($$[0]$$, FALSE, 2),
    ($$Array is empty$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (dev id 371, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When using Arrays.asList() on an array, what type of List is returned?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$When using Arrays.asList() on an array, what type of List is returned?$$, NULL, NULL,
           $$Arrays.asList() returns a fixed-size List view that wraps the original array, which means it does not create a copy and modifications to the List affect the original array.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.867879',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$A resizable List that can add and remove elements.$$, FALSE, 0),
    ($$A fixed-size List view of the original array.$$, TRUE, 1),
    ($$A deep copy of the original array.$$, FALSE, 2),
    ($$An empty List.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (dev id 372, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are best practices when working with arrays?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when working with arrays?$$, NULL, NULL,
           $$Using Arrays.toString() or Arrays.deepToString() is a best practice for printing arrays, and using Arrays.equals() is essential for content comparison. The other options do not reflect best practices.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.380373',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$Always use Arrays.toString() to print an array's contents.$$, TRUE, 0),
    ($$Use == to compare two arrays for equality.$$, FALSE, 1),
    ($$Use Arrays.equals() to compare two arrays' contents.$$, TRUE, 2),
    ($$Print an array directly with System.out.println().$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (dev id 373, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does it mean that Java arrays are covariant?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What does it mean that Java arrays are covariant?$$, NULL, NULL,
           $$Covariance allows an array of a subtype (like Integer[]) to be assigned to a supertype array variable (like Number[]), but this can lead to runtime errors if not handled carefully.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.397579',
           now(), now()
    FROM topic
    WHERE slug = 'arrays'
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
    ($$Arrays can hold mixed data types.$$, FALSE, 0),
    ($$An Integer[] can be assigned to a Number[] variable.$$, TRUE, 1),
    ($$Arrays can be resized dynamically.$$, FALSE, 2),
    ($$Covariant arrays are always safe to use.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'arrays'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

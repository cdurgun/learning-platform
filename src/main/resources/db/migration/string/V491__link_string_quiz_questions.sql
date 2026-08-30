-- Promotion-style migration linking EN String quiz questions to the
-- topic's fixed quiz created in string/V490 -- same pattern as
-- git-fundamentals/V467-V468 (WITH ... RETURNING id + NOT EXISTS dedup +
-- ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 318, 319, 320, 321, 322, 323, 324, 325, 333, 335
-- Topic: string (language: en)
-- These 10 questions were reviewed against content/en/string.md and
-- content/tr/string.md and PUBLISHED via QuestionReviewService.publish
-- (same business logic the real ADMIN review UI calls). Selected from a
-- larger PUBLISHED pool to avoid near-duplicate topics/phrasing within the
-- same quiz -- see chat transcript for the full published pool and the
-- selection rationale.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database, and a safe
-- no-op if re-run against this development database (where the content
-- already exists from live review/publish). The quiz_question_link insert
-- carries ON CONFLICT DO NOTHING as a second safety net (UNIQUE(quiz_id,
-- question_id), UNIQUE(quiz_id, position) from V290).

-- Question 1/10 (dev id 318, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the primary characteristic of a String in Java?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What is the primary characteristic of a String in Java?$$, NULL, NULL,
           $$The primary characteristic of a String in Java is that it is immutable, meaning once created, its content cannot change. This is in contrast to mutable objects, which can be modified after creation.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.582016',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$Strings are mutable and can be changed after creation.$$, FALSE, 0),
    ($$Strings are immutable and cannot be changed after creation.$$, TRUE, 1),
    ($$Strings are primitive types in Java.$$, FALSE, 2),
    ($$Strings can only contain single-byte characters.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/10 (dev id 319, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following methods can be used to inspect a String in Java?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Which of the following methods can be used to inspect a String in Java?$$, NULL, NULL,
           $$Methods like length(), charAt(), substring(), indexOf(), and contains() are all used to inspect a String. They help retrieve information about the string's content and structure.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.626182',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$length()$$, TRUE, 0),
    ($$charAt()$$, TRUE, 1),
    ($$append()$$, FALSE, 2),
    ($$substring()$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/10 (dev id 320, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when you use the '==' operator to compare two String objects?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What happens when you use the '==' operator to compare two String objects?$$, NULL, NULL,
           $$The '==' operator compares the memory address of the two String objects, not their content. This can lead to incorrect results if the two objects are different instances, even if they contain the same text.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.630077',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$It compares the content of the Strings.$$, FALSE, 0),
    ($$It compares the memory address of the Strings.$$, TRUE, 1),
    ($$It always returns true for identical Strings.$$, FALSE, 2),
    ($$It throws an exception if the Strings are different.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/10 (dev id 321, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will be the output of the following code?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$, $$String a = "hello"; String b = new String("hello"); System.out.println(a == b);$$, $$java$$,
           $$The output will be 'false' because '==' compares the memory addresses of the two String objects. 'a' refers to a string literal in the string pool, while 'b' is a new String object, so they are different.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.633335',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$true$$, FALSE, 0),
    ($$false$$, TRUE, 1),
    ($$hello$$, FALSE, 2),
    ($$null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/10 (dev id 322, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What are the benefits of using StringBuilder over String for concatenation?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What are the benefits of using StringBuilder over String for concatenation?$$, NULL, NULL,
           $$StringBuilder is mutable and allows modifications without creating new objects, making it more efficient for concatenating multiple strings in a loop compared to using immutable Strings, which create new objects each time.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.636252',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$StringBuilder is mutable and modifies the same object.$$, TRUE, 0),
    ($$StringBuilder is slower than using String.$$, FALSE, 1),
    ($$Using StringBuilder avoids O(n²) performance issues.$$, TRUE, 2),
    ($$StringBuilder can only be used with single-byte characters.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/10 (dev id 323, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code output?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What will this code output?$$, $$String str = "   Hello World!   "; System.out.println(str.strip());$$, $$java$$,
           $$The output will be 'Hello World!' because the strip() method removes leading and trailing whitespace, and it is Unicode-aware, making it the preferred method over trim() for whitespace removal.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.638924',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$"Hello World!"$$, TRUE, 0),
    ($$"   Hello World!   "$$, FALSE, 1),
    ($$"Hello World!   "$$, FALSE, 2),
    ($$"   Hello World!"$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/10 (dev id 324, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are common mistakes when working with Strings in Java?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Which of the following are common mistakes when working with Strings in Java?$$, NULL, NULL,
           $$Common mistakes include using '==' for content comparison instead of equals(), forgetting to assign the return value of a String method, and using '+' for concatenation in loops, which leads to performance issues.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.641474',
           now(), now()
    FROM topic
    WHERE slug = 'string'
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
    ($$Using '==' to compare String content.$$, TRUE, 0),
    ($$Forgetting to assign a String method's return value.$$, TRUE, 1),
    ($$Using StringBuilder for concatenation.$$, FALSE, 2),
    ($$Assuming String.format() truncates numbers.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 8/10 (dev id 325, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the purpose of the String.format() method?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What is the purpose of the String.format() method?$$, NULL, NULL,
           $$String.format() provides a way to format strings using placeholders, allowing for controlled insertion of variables into strings, which is useful for creating formatted output.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.644102',
           now(), now()
    FROM topic
    WHERE slug = 'string'
      AND NOT EXISTS (SELECT 1 FROM existing_q8)
    RETURNING id
),
target_q8 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q8
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q8
),
option_ins_q8 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q8.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q8
             CROSS JOIN (VALUES
    ($$To concatenate multiple Strings together.$$, FALSE, 0),
    ($$To format strings with placeholders.$$, TRUE, 1),
    ($$To compare two Strings for equality.$$, FALSE, 2),
    ($$To convert a String to a byte array.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q8.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q8.id, 8
FROM target_q8
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 9/10 (dev id 333, quiz position 9)
WITH existing_q9 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will happen if you call the method toUpperCase() on a String object?$$
),
inserted_q9 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will happen if you call the method toUpperCase() on a String object?$$, NULL, NULL,
           $$Calling toUpperCase() returns a new String object with the modified content, leaving the original String unchanged due to immutability.$$, $$n8n-ai-judge$$, '2026-08-30 13:53:04.686423',
           now(), now()
    FROM topic
    WHERE slug = 'string'
      AND NOT EXISTS (SELECT 1 FROM existing_q9)
    RETURNING id
),
target_q9 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q9
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q9
),
option_ins_q9 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q9.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q9
             CROSS JOIN (VALUES
    ($$The original String will be converted to uppercase$$, FALSE, 0),
    ($$A new String object will be created with uppercase content$$, TRUE, 1),
    ($$The method will throw an exception$$, FALSE, 2),
    ($$The original String will be deleted$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q9.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q9.id, 9
FROM target_q9
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 10/10 (dev id 335, quiz position 10)
WITH existing_q10 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are best practices when working with strings in Java? (Select all that apply)$$
),
inserted_q10 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when working with strings in Java? (Select all that apply)$$, NULL, NULL,
           $$Using equals() for content comparison and StringBuilder for concatenation in loops are recommended practices to avoid common pitfalls.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.655686',
           now(), now()
    FROM topic
    WHERE slug = 'string'
      AND NOT EXISTS (SELECT 1 FROM existing_q10)
    RETURNING id
),
target_q10 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q10
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q10
),
option_ins_q10 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q10.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q10
             CROSS JOIN (VALUES
    ($$Use == for string content comparison$$, FALSE, 0),
    ($$Use StringBuilder for concatenating strings in a loop$$, TRUE, 1),
    ($$Always use equals() for string content comparison$$, TRUE, 2),
    ($$Use String for building multi-line text$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q10.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q10.id, 10
FROM target_q10
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'string'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


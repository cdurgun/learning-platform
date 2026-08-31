-- Promotion-style migration linking EN Scanner quiz questions to the topic's
-- fixed quiz created in scanner/V526 -- same pattern as arrays/V523 and
-- string/V491 (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO
-- NOTHING on the link insert).
--
-- Development Question IDs: 394, 395, 396, 397, 398, 400, 401
-- Topic: scanner (language: en)
-- These are ALL 7 EN questions PUBLISHED for this topic (question-
-- promotion/V525 -- 4 via AI Judge auto-publish, 3 via human ADMIN review
-- correcting AI Judge false-negative rejections). No selection/omission --
-- the entire published EN pool is linked.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (V525 will
-- already have created these rows, so this migration's own fallback INSERT
-- branch is a safe no-op that only supplies the quiz_question_link), and a
-- safe no-op if re-run against this development database. The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).

-- Question 1/7 (dev id 394, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the primary purpose of the Scanner class in Java?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What is the primary purpose of the Scanner class in Java?$$, NULL, NULL,
           $$The Scanner class is primarily used to read input from various sources and tokenize that input into manageable pieces. It simplifies the process of parsing input compared to reading raw bytes or characters.$$, $$n8n-ai-judge$$, '2026-08-31 19:16:04.046567',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$To read raw bytes from an InputStream$$, FALSE, 0),
    ($$To tokenize and read input from a text source$$, TRUE, 1),
    ($$To perform complex mathematical operations$$, FALSE, 2),
    ($$To manage file system operations$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (dev id 395, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are best practices when using the Scanner class?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when using the Scanner class?$$, NULL, NULL,
           $$Best practices include consuming leftover newlines after reading numbers, checking for the presence of tokens before reading, and always closing the Scanner. These practices help avoid common pitfalls and resource leaks.$$, $$gentest-review-admin@example.com$$, '2026-08-31 19:30:05.918513',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$Always close a Scanner after use$$, TRUE, 0),
    ($$Use nextLine() after nextInt() without any additional calls$$, FALSE, 1),
    ($$Check hasNext() before calling next()$$, TRUE, 2),
    ($$Use Scanner for all file operations without exception handling$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (dev id 396, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens if you call nextLine() immediately after nextInt()?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What happens if you call nextLine() immediately after nextInt()?$$, NULL, NULL,
           $$Calling nextLine() right after nextInt() will result in an empty string being returned because nextInt() does not consume the newline character that follows the integer input.$$, $$n8n-ai-judge$$, '2026-08-31 19:25:29.06615',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$It will read the next integer correctly$$, FALSE, 0),
    ($$It will throw an InputMismatchException$$, FALSE, 1),
    ($$It will return an empty string$$, TRUE, 2),
    ($$It will read the next line of input correctly$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (dev id 397, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will be the output of the following code?$$
      AND code_snippet = $$Scanner scanner = new Scanner(System.in);
int number = scanner.nextInt();
String line = scanner.nextLine();
System.out.println(line);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code?$$,
           $$Scanner scanner = new Scanner(System.in);
int number = scanner.nextInt();
String line = scanner.nextLine();
System.out.println(line);$$, $$java$$,
           $$The output will be an empty string because nextInt() consumes the integer input but leaves the newline character in the input stream, which is then read by nextLine().$$, $$n8n-ai-judge$$, '2026-08-31 19:26:07.6487',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$The integer value entered$$, FALSE, 0),
    ($$An empty string$$, TRUE, 1),
    ($$A prompt for the next input$$, FALSE, 2),
    ($$An error message$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (dev id 398, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is Scanner generally slower than BufferedReader?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Why is Scanner generally slower than BufferedReader?$$, NULL, NULL,
           $$Scanner is slower than BufferedReader because it uses regex matching internally to parse tokens, while BufferedReader simply reads raw text lines without any parsing.$$, $$gentest-review-admin@example.com$$, '2026-08-31 19:30:41.54474',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$Scanner reads characters one at a time$$, FALSE, 0),
    ($$Scanner uses regex matching for parsing$$, TRUE, 1),
    ($$BufferedReader cannot read from files$$, FALSE, 2),
    ($$BufferedReader is designed for token parsing$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (dev id 400, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What exception might be thrown when using Scanner to read from a file?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What exception might be thrown when using Scanner to read from a file?$$, NULL, NULL,
           $$FileNotFoundException is thrown when the file path provided to the Scanner constructor is incorrect or the file does not exist.$$, $$gentest-review-admin@example.com$$, '2026-08-31 19:30:57.084208',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$NoSuchElementException$$, FALSE, 0),
    ($$InputMismatchException$$, FALSE, 1),
    ($$FileNotFoundException$$, TRUE, 2),
    ($$IOException$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (dev id 401, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this sequence of commands print?$$
      AND code_snippet = $$Scanner csv = new Scanner("1,2,3,4");
csv.useDelimiter(",");
while (csv.hasNext()) {
    System.out.println(csv.next());
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What will this sequence of commands print?$$,
           $$Scanner csv = new Scanner("1,2,3,4");
csv.useDelimiter(",");
while (csv.hasNext()) {
    System.out.println(csv.next());
}$$, $$java$$,
           $$The output will be four separate lines, each printing a number from the input string, as the custom delimiter ',' splits the string into tokens.$$, $$n8n-ai-judge$$, '2026-08-31 19:26:10.02597',
           now(), now()
    FROM topic
    WHERE slug = 'scanner'
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
    ($$1
2
3
4$$, TRUE, 0),
    ($$1234$$, FALSE, 1),
    ($$1, 2, 3, 4$$, FALSE, 2),
    ($$Error: No tokens found$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'scanner'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

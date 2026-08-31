-- Promotion-style migration linking EN File Reading quiz questions to the
-- topic's fixed quiz created in file-reading/V534 -- same pattern as
-- arrays/V523, scanner/V527, and wrapper-classes/V531 (WITH ... RETURNING
-- id + NOT EXISTS dedup + ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 444, 445, 446, 447, 448, 449, 450, 451
-- Topic: file-reading (language: en)
-- These are ALL 8 EN questions PUBLISHED for this topic (question-
-- promotion/V533). No selection/omission -- the entire published EN pool
-- is linked.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (V533 will
-- already have created these rows, so this migration's own fallback INSERT
-- branch is a safe no-op that only supplies the quiz_question_link), and a
-- safe no-op if re-run against this development database. The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).

-- Question 1/8 (dev id 444, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following is the correct way to count the number of lines in a file using the java.nio.file API without loading the entire file into memory?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Which of the following is the correct way to count the number of lines in a file using the java.nio.file API without loading the entire file into memory?$$, NULL, NULL,
           $$Files.lines(path).count() is the correct way to count lines in a file without loading the entire file into memory. This method returns a Stream<String> and reads the file lazily. Files.readAllLines(path).size() loads the entire file into memory, which is not suitable for large files. Files.readString(path).lines().count() and Files.readString(path).split("\n").length would both load the entire file into memory as a single string, which is not efficient for large files.$$, $$n8n-ai-judge$$, '2026-08-31 23:27:53.752339',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$Files.lines(path).count()$$, TRUE, 0),
    ($$Files.readAllLines(path).size()$$, FALSE, 1),
    ($$Files.readString(path).lines().count()$$, FALSE, 2),
    ($$Files.readString(path).split("\n").length$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/8 (dev id 445, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the consequence of using Files.lines(path) without try-with-resources?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What is the consequence of using Files.lines(path) without try-with-resources?$$, NULL, NULL,
           $$Using Files.lines(path) without try-with-resources leads to a resource leak because the Stream<String> it returns holds a real file handle underneath. If not closed, the resource leaks. It doesn't lead to a compile error or a NoSuchFileException. It is also not related to the performance of the code.$$, $$n8n-ai-judge$$, '2026-08-31 23:27:53.786742',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$It leads to a compile error$$, FALSE, 0),
    ($$It throws a NoSuchFileException$$, FALSE, 1),
    ($$It leads to a resource leak$$, TRUE, 2),
    ($$It decreases the performance of the code$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/8 (dev id 446, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the Path.of(...) method do?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What does the Path.of(...) method do?$$, NULL, NULL,
           $$Path.of(...) creates an object that represents a file location. It does not touch the filesystem, it's just an 'address'. It does not create a new file, check if a file exists or read the file.$$, $$n8n-ai-judge$$, '2026-08-31 23:27:53.814284',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$Creates a new file at the given location$$, FALSE, 0),
    ($$Checks if a file exists at the given location$$, FALSE, 1),
    ($$Reads a file at the given location$$, FALSE, 2),
    ($$Creates an object that represents a file location$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/8 (dev id 447, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will be the output of the following code if the file 'data.txt' contains the lines 'Hello', 'World', 'Java'?$$
      AND code_snippet = $$Path path = Path.of("data.txt");
System.out.println(Files.readAllLines(path).size());$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$What will be the output of the following code if the file 'data.txt' contains the lines 'Hello', 'World', 'Java'?$$,
           $$Path path = Path.of("data.txt");
System.out.println(Files.readAllLines(path).size());$$, $$java$$,
           $$Files.readAllLines(path).size() reads all lines from the file into a List<String> and returns the size of the list, which is the number of lines in the file. In this case, the file contains three lines, so the output will be 3.$$, $$n8n-ai-judge$$, '2026-08-31 23:30:40.062472',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$1$$, FALSE, 0),
    ($$2$$, FALSE, 1),
    ($$3$$, TRUE, 2),
    ($$4$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/8 (dev id 448, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are best practices when reading files in Java?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which of the following are best practices when reading files in Java?$$, NULL, NULL,
           $$Using Files.readAllLines()/Files.readString() for small-to-medium files and Files.lines() for very large files are recommended practices. Using every resource that holds a file handle inside try-with-resources is also a best practice to prevent resource leaks. Catching NoSuchFileException when using the java.nio.file API is the correct exception handling. Using BufferedReader for small files is not a best practice, it can be used for any file size.$$, $$n8n-ai-judge$$, '2026-08-31 23:27:53.825513',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$Use Files.readAllLines()/Files.readString() for small-to-medium files$$, TRUE, 0),
    ($$Use BufferedReader for small files$$, FALSE, 1),
    ($$Use every resource that holds a file handle inside try-with-resources$$, TRUE, 2),
    ($$Catch NoSuchFileException when using the java.nio.file API$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/8 (dev id 449, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following methods reads the entire file into a single String, including line separators?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Which of the following methods reads the entire file into a single String, including line separators?$$, NULL, NULL,
           $$Files.readString() reads the entire file into a single String, including line separators. Files.readAllLines() strips line separators and returns a List. BufferedReader.readLine() reads one line at a time, and Files.lines() reads the file lazily and returns a Stream<String>.$$, $$n8n-ai-judge$$, '2026-08-31 23:27:53.835531',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$Files.readString()$$, TRUE, 0),
    ($$Files.readAllLines()$$, FALSE, 1),
    ($$BufferedReader.readLine()$$, FALSE, 2),
    ($$Files.lines()$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/8 (dev id 450, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which exception is thrown when a file does not exist and you try to read it using the java.nio.file API?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Which exception is thrown when a file does not exist and you try to read it using the java.nio.file API?$$, NULL, NULL,
           $$When using the java.nio.file API, a missing file throws NoSuchFileException. FileNotFoundException is thrown by the classic java.io classes like FileReader/FileInputStream.$$, $$n8n-ai-judge$$, '2026-08-31 23:30:43.06241',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$IOException$$, FALSE, 0),
    ($$FileNotFoundException$$, FALSE, 1),
    ($$NoSuchFileException$$, TRUE, 2),
    ($$FileNotReadableException$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 8/8 (dev id 451, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the BufferedReader.readLine() method return when there's nothing left to read?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$What does the BufferedReader.readLine() method return when there's nothing left to read?$$, NULL, NULL,
           $$BufferedReader.readLine() returns null exactly once, when there's nothing left to read. It does not return an empty string, a special EOF character or throw an EOFException.$$, $$n8n-ai-judge$$, '2026-08-31 23:30:45.821241',
           now(), now()
    FROM topic
    WHERE slug = 'file-reading'
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
    ($$An empty string$$, FALSE, 0),
    ($$A special EOF character$$, FALSE, 1),
    ($$null$$, TRUE, 2),
    ($$Throws an EOFException$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q8.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q8.id, 8
FROM target_q8
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-reading'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

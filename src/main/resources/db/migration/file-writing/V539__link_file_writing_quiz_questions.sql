-- Promotion-style migration linking EN File Writing quiz questions to the
-- topic's fixed quiz created in file-writing/V538 -- same pattern as
-- arrays/V523, scanner/V527, wrapper-classes/V531, and file-reading/V535
-- (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO NOTHING on the
-- link insert).
--
-- All 8 EN questions from question-promotion/V537 (hand-authored and
-- self-reviewed directly in a Claude Code session -- no n8n, no OpenAI, no
-- AI Judge). No selection/omission -- the entire EN batch is linked.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (V537 will
-- already have created these rows, so this migration's own fallback INSERT
-- branch is a safe no-op that only supplies the quiz_question_link). The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).

-- Question 1/8 (EN-1, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$By default, what happens if you call Files.writeString(path, content) on a file that already exists?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$By default, what happens if you call Files.writeString(path, content) on a file that already exists?$$, NULL, NULL,
           $$Files.writeString() creates the file if it doesn't exist and overwrites it entirely if it does -- calling it again simply replaces the previous content, it does not append to it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$The new content is appended to the end of the existing content.$$, FALSE, 0),
    ($$The file's entire existing content is overwritten with the new content.$$, TRUE, 1),
    ($$An exception is thrown because the file already exists.$$, FALSE, 2),
    ($$The call is ignored and the original content is preserved.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/8 (EN-2, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens if you call Files.writeString(path, content, StandardOpenOption.APPEND) on a file that does not exist yet?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens if you call Files.writeString(path, content, StandardOpenOption.APPEND) on a file that does not exist yet?$$, NULL, NULL,
           $$APPEND alone assumes the file already exists. Calling it on a missing file throws NoSuchFileException -- APPEND does not automatically include CREATE.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$It throws NoSuchFileException.$$, TRUE, 0),
    ($$It creates the file and writes the content.$$, FALSE, 1),
    ($$It throws FileAlreadyExistsException.$$, FALSE, 2),
    ($$It silently does nothing and no file is created.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/8 (EN-3, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$You want to append content to a file, but you're not sure whether the file already exists. Which approach does the lesson recommend?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$You want to append content to a file, but you're not sure whether the file already exists. Which approach does the lesson recommend?$$, NULL, NULL,
           $$Passing StandardOpenOption.CREATE together with StandardOpenOption.APPEND works safely whether the file exists or not -- there is no need to check for existence first.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$Use StandardOpenOption.APPEND by itself.$$, FALSE, 0),
    ($$Use StandardOpenOption.CREATE and StandardOpenOption.APPEND together.$$, TRUE, 1),
    ($$Rely on the default behavior of Files.writeString() with no extra options.$$, FALSE, 2),
    ($$First check with Files.exists(), and only then decide which option to pass.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/8 (EN-4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$After this code runs, what will the file contain?$$
      AND code_snippet = $$List<String> lines = List.of("Alpha", "Beta", "Gamma");
Files.write(path, lines);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$After this code runs, what will the file contain?$$,
           $$List<String> lines = List.of("Alpha", "Beta", "Gamma");
Files.write(path, lines);$$, $$java$$,
           $$Files.write(path, list) takes a List<String> and writes each element on its own line -- no need to manually add line separators.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$Three lines: "Alpha", then "Beta", then "Gamma"$$, TRUE, 0),
    ($$A single line: "AlphaBetaGamma"$$, FALSE, 1),
    ($$A single line: "Alpha,Beta,Gamma"$$, FALSE, 2),
    ($$Only "Gamma" (the last element)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/8 (EN-5, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will the resulting file contain after this code runs?$$
      AND code_snippet = $$try (BufferedWriter w = new BufferedWriter(new FileWriter(path.toFile()))) {
    w.write("Line1");
    w.write("Line2");
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What will the resulting file contain after this code runs?$$,
           $$try (BufferedWriter w = new BufferedWriter(new FileWriter(path.toFile()))) {
    w.write("Line1");
    w.write("Line2");
}$$, $$java$$,
           $$BufferedWriter.write() does not add a line separator by itself -- newLine() must be called explicitly for that. Without it, consecutive write() calls are simply concatenated.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$Two separate lines: "Line1" and "Line2"$$, FALSE, 0),
    ($$A single line: "Line1Line2"$$, TRUE, 1),
    ($$Only "Line2"$$, FALSE, 2),
    ($$The code throws an exception because newLine() was never called.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/8 (EN-6, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when Files.copy(source, dest) is called and the destination file already exists?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when Files.copy(source, dest) is called and the destination file already exists?$$, NULL, NULL,
           $$By default, Files.copy() throws FileAlreadyExistsException if the destination already exists. StandardCopyOption.REPLACE_EXISTING makes it overwrite instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$It throws FileAlreadyExistsException.$$, TRUE, 0),
    ($$It silently overwrites the destination.$$, FALSE, 1),
    ($$It throws NoSuchFileException.$$, FALSE, 2),
    ($$It appends the source file's content to the destination.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/8 (EN-7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are best practices when writing files in Java, according to the lesson?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are best practices when writing files in Java, according to the lesson?$$, NULL, NULL,
           $$Using Files.writeString()/Files.write() for simple one-off writes, passing CREATE with APPEND when unsure if a file exists, and always adding REPLACE_EXISTING to Files.copy() when overwriting is intended are all lesson-stated best practices. Deleting a directory tree in natural (shallow-to-deep) order is the opposite of the recommended approach -- it fails on non-empty directories.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$Use Files.writeString()/Files.write() for simple, one-off writes.$$, TRUE, 0),
    ($$Pass StandardOpenOption.CREATE together with APPEND if you're unsure whether the file exists.$$, TRUE, 1),
    ($$Always add StandardCopyOption.REPLACE_EXISTING when calling Files.copy() if you want to overwrite the destination.$$, TRUE, 2),
    ($$Delete a directory tree by walking it in its natural, shallow-to-deep order.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 8/8 (EN-8, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens if you call Files.createDirectories() on a path where the directory already exists?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens if you call Files.createDirectories() on a path where the directory already exists?$$, NULL, NULL,
           $$Files.createDirectories() creates a directory and any missing parent directories, like mkdir -p -- it does not fail if the directory already exists.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'file-writing'
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
    ($$Nothing happens; no exception is thrown.$$, TRUE, 0),
    ($$It throws FileAlreadyExistsException.$$, FALSE, 1),
    ($$It deletes and recreates the directory.$$, FALSE, 2),
    ($$It throws an exception because the parent directories cannot be verified.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q8.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q8.id, 8
FROM target_q8
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'file-writing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

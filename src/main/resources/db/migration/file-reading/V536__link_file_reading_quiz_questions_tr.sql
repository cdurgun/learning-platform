-- Promotion-style migration linking TR File Reading quiz questions to the
-- topic's fixed quiz created in file-reading/V534 -- same pattern as
-- arrays/V524, scanner/V528, and wrapper-classes/V532 (WITH ... RETURNING
-- id + NOT EXISTS dedup + ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 459, 460, 461, 462
-- Topic: file-reading (language: tr)
-- These are the 4 TR questions PUBLISHED for this topic (question-
-- promotion/V533) -- all from a SECOND, scoped TR-only generation attempt
-- (Topic Selection -> {topicSlug: "file-reading", onlyLanguage: "tr",
-- overrideCount: 8}); the FIRST TR attempt (dev ids 452-458) was entirely
-- discarded due to a known n8n transport-layer text-corruption bug (bkz.
-- question-promotion/V533's header and docs/known-constraints.md "Faz
-- 148") -- none of those 7 corrupted questions are included in any
-- migration, and the 3 that had already been auto-published were corrected
-- to REJECTED directly in development before this migration was written.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V535 -- see that file's header for the full rationale.

-- Question 1/4 (dev id 459, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Files.lines(path)` metodu ne tür bir değer döndürür?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$`Files.lines(path)` metodu ne tür bir değer döndürür?$$, NULL, NULL,
           $$`Files.lines(path)` metodu, bir `Stream<String>` döndürür. Bu `Stream`, altında gerçek bir dosya tanıtıcısı tutar ve bu nedenle try-with-resources bloğu içinde kullanılmalıdır.$$, $$n8n-ai-judge$$, '2026-08-31 23:32:16.70264',
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
    ($$`Stream<String>`$$, TRUE, 0),
    ($$`List<String>`$$, FALSE, 1),
    ($$`String`$$, FALSE, 2),
    ($$`File`$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/4 (dev id 460, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java'da dosya okuma için hangi API'ler kullanılabilir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Java'da dosya okuma için hangi API'ler kullanılabilir?$$, NULL, NULL,
           $$Java'da dosya okumak için iki API vardır: klasik `java.io` (`BufferedReader`+`FileReader`, satır satır okuma için) ve modern `java.nio.file` (`Path`+`Files`, `readAllLines()`/`readString()`/`lines()` ile çoğu işlemi tek satıra indirger).$$, $$n8n-ai-judge$$, '2026-08-31 23:32:16.713873',
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
    ($$`java.io`$$, TRUE, 0),
    ($$`java.nio.file`$$, TRUE, 1),
    ($$`java.util`$$, FALSE, 2),
    ($$`java.lang`$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/4 (dev id 461, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi `BufferedReader` kullanırken dikkate alınmalıdır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangisi `BufferedReader` kullanırken dikkate alınmalıdır?$$, NULL, NULL,
           $$`BufferedReader` gerçek bir dosya tanıtıcısı tuttuğu için try-with-resources bloğu içinde kullanılmalıdır. Ayrıca, `readLine()` metodu dosyanın sonuna gelindiğinde tam olarak bir kez `null` döner ve bu, döngünün doğal bitiş koşuludur.$$, $$n8n-ai-judge$$, '2026-08-31 23:32:16.72377',
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
    ($$`BufferedReader`'ı try-with-resources bloğu içinde kullanmalıyız$$, TRUE, 0),
    ($$`readLine()` metodu dosyanın sonuna gelindiğinde `null` döner$$, TRUE, 1),
    ($$`BufferedReader`'ı kapatmaya gerek yoktur$$, FALSE, 2),
    ($$`readLine()` metodu dosyanın sonuna gelindiğinde bir istisna fırlatır$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/4 (dev id 462, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-reading')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Files.readString()` ve `Files.readAllLines()` metotları için hangi istisna tipi yakalanmalıdır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$`Files.readString()` ve `Files.readAllLines()` metotları için hangi istisna tipi yakalanmalıdır?$$, NULL, NULL,
           $$Modern `java.nio.file` API'sinde (`Files.readString()`, `Files.readAllLines()` vb.) eksik bir dosya `NoSuchFileException` fırlatır. Bu, klasik `java.io`'nun `FileNotFoundException`'ı değildir. Bu iki istisna, her ikisi de `IOException`'ı genişletse de, birbiriyle ilişkisiz istisna sınıflarıdır.$$, $$n8n-ai-judge$$, '2026-08-31 23:32:16.733553',
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
    ($$`NoSuchFileException`$$, TRUE, 0),
    ($$`FileNotFoundException`$$, FALSE, 1),
    ($$`IOException`$$, FALSE, 2),
    ($$`FileException`$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR File Writing quiz questions to the
-- topic's fixed quiz created in file-writing/V538 -- same pattern as
-- arrays/V524, scanner/V528, wrapper-classes/V532, and file-reading/V536
-- (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO NOTHING on the
-- link insert).
--
-- All 4 TR questions from question-promotion/V537 (hand-authored and
-- self-reviewed directly in a Claude Code session -- no n8n, no OpenAI, no
-- AI Judge, and NOT translations of the EN set -- each TR question was
-- independently grounded in content/tr/file-writing.md and targets
-- concepts not already covered by the EN batch). No selection/omission --
-- the entire TR batch is linked.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V539 -- see that file's header for the full rationale.

-- Question 1/4 (TR-1, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir dizin ağacını silerken Files.walk(dizin).sorted(Comparator.reverseOrder()) neden doğal sıralama yerine kullanılmalıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir dizin ağacını silerken Files.walk(dizin).sorted(Comparator.reverseOrder()) neden doğal sıralama yerine kullanılmalıdır?$$, NULL, NULL,
           $$Bir dizin, içindeki dosyalar/alt dizinler silinmeden silinemez. Bu yüzden Comparator.reverseOrder() ile en derindeki girişlerden başlanarak silme yapılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Bir dizin, içindeki dosyalar/alt dizinler silinmeden silinemez; bu yüzden en derindeki girişler önce silinmelidir.$$, TRUE, 0),
    ($$Comparator.reverseOrder() silme işlemini doğal sıralamadan daha hızlı yapar.$$, FALSE, 1),
    ($$Files.walk() varsayılan olarak yalnızca ters sırada sonuç döner.$$, FALSE, 2),
    ($$Doğal sıralama gizli dosyaları atlar.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/4 (TR-2, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Derse göre, bir CSV dosyasının tüm satırlarını bir StringBuilder'da toplayıp TEK bir Files.writeString() çağrısıyla yazmak neden tercih edilir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Derse göre, bir CSV dosyasının tüm satırlarını bir StringBuilder'da toplayıp TEK bir Files.writeString() çağrısıyla yazmak neden tercih edilir?$$, NULL, NULL,
           $$Tüm satırları bir StringBuilder'da toplayıp tek bir Files.writeString() çağrısıyla yazmak, her satır için ayrı bir yazma çağrısı yapmaktan daha verimlidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Her satır için ayrı bir yazma çağrısı yapmaktan daha verimlidir.$$, TRUE, 0),
    ($$Bu, doğru satır sonlarını garanti eden tek yöntemdir.$$, FALSE, 1),
    ($$Files.writeString() bir dosya için birden fazla kez çağrılamaz.$$, FALSE, 2),
    ($$Bu yöntem, dosyanın diskte daha az yer kaplamasını sağlar.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/4 (TR-3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştırıldıktan sonra dosyanın içeriği ne olur?$$
      AND code_snippet = $$Files.writeString(path, "First");
Files.writeString(path, "Second");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştırıldıktan sonra dosyanın içeriği ne olur?$$,
           $$Files.writeString(path, "First");
Files.writeString(path, "Second");$$, $$java$$,
           $$Files.writeString() aynı dosyaya art arda çağrıldığında, dosyada yalnızca son çağrının içeriği kalır -- üzerine yazma, biriktirme değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Yalnızca "Second"$$, TRUE, 0),
    ($$"First" ve ardından "Second" birleştirilmiş: "FirstSecond"$$, FALSE, 1),
    ($$Yalnızca "First"$$, FALSE, 2),
    ($$İki ayrı satır: "First" ve "Second"$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/4 (TR-4, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'file-writing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$BufferedWriter.newLine() metodu hakkında aşağıdakilerden hangisi doğrudur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$BufferedWriter.newLine() metodu hakkında aşağıdakilerden hangisi doğrudur?$$, NULL, NULL,
           $$newLine() platforma uygun doğru satır sonunu kullanır: Linux/macOS'ta \n, Windows'ta \r\n.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Her zaman "\n" karakterini ekler, platformdan bağımsızdır.$$, FALSE, 0),
    ($$Platforma uygun doğru satır sonu karakterini kullanır (Linux/macOS'ta \n, Windows'ta \r\n).$$, TRUE, 1),
    ($$Yalnızca dosyanın son satırından sonra çağrılabilir.$$, FALSE, 2),
    ($$write() metodunu otomatik olarak çağırır.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

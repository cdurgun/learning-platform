-- Promotion-style migration linking TR Scanner quiz questions to the topic's
-- fixed quiz created in scanner/V526 -- same pattern as arrays/V524 and
-- string/V492 (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO
-- NOTHING on the link insert).
--
-- Development Question IDs: 402, 404, 405, 406
-- Topic: scanner (language: tr)
-- These are ALL 4 TR questions PUBLISHED for this topic (question-
-- promotion/V525, all 4 via AI Judge auto-publish). Dev ids 403 and 407
-- (REJECTED by the human reviewer for genuine content defects) are
-- correctly excluded, same as they were from V525.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V527 -- see that file's header for the full rationale.

-- Question 1/4 (dev id 402, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Scanner sınıfı hangi pakette tanımlıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Scanner sınıfı hangi pakette tanımlıdır?$$, NULL, NULL,
           $$Scanner sınıfı java.util paketinde tanımlıdır. Diğer seçenekler yanlış çünkü java.io ve java.lang paketleri Scanner ile ilgili değildir.$$, $$n8n-ai-judge$$, '2026-08-31 19:26:12.150974',
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
    ($$java.util$$, TRUE, 0),
    ($$java.io$$, FALSE, 1),
    ($$java.lang$$, FALSE, 2),
    ($$java.text$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/4 (dev id 404, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$nextInt() metodunun ardından gelen satır sonunu tüketmek için ne yapılmalıdır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$nextInt() metodunun ardından gelen satır sonunu tüketmek için ne yapılmalıdır?$$, NULL, NULL,
           $$nextInt() metodunun ardından fazladan bir nextLine() çağrısı yapılmalıdır. Diğer seçenekler yanlış çünkü sadece nextInt() çağırmak yeterli değildir.$$, $$n8n-ai-judge$$, '2026-08-31 19:26:14.436222',
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
    ($$Fazladan bir nextLine() çağırmalısınız$$, TRUE, 0),
    ($$nextInt() yeterlidir$$, FALSE, 1),
    ($$nextLine() yeterlidir$$, FALSE, 2),
    ($$next() çağırmalısınız$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/4 (dev id 405, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kodun çıktısı ne olacaktır?$$
      AND code_snippet = $$Scanner scanner = new Scanner(System.in);
int age = scanner.nextInt();
String name = scanner.nextLine();
System.out.println(name);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki kodun çıktısı ne olacaktır?$$,
           $$Scanner scanner = new Scanner(System.in);
int age = scanner.nextInt();
String name = scanner.nextLine();
System.out.println(name);$$, $$java$$,
           $$Kodda nextInt() çağrısından sonra nextLine() çağrısı yapılmıştır. Bu durumda, eğer kullanıcı bir sayı girdikten sonra enter tuşuna basarsa, name değişkeni boş bir string alır. Bu yüzden çıktı boş olacaktır.$$, $$n8n-ai-judge$$, '2026-08-31 19:26:16.909442',
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
    ($$Bir boş string$$, TRUE, 0),
    ($$Yaş değeri$$, FALSE, 1),
    ($$Hata mesajı$$, FALSE, 2),
    ($$null$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/4 (dev id 406, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'scanner')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Scanner sınıfı hangi durumda daha yavaş çalışır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Scanner sınıfı hangi durumda daha yavaş çalışır?$$, NULL, NULL,
           $$Scanner, her token'ı okurken regex eşleşmesi yapar. BufferedReader ise sadece ham satırları okur ve bu yüzden daha hızlıdır. Bu nedenle, regex tabanlı ayrıştırma nedeniyle Scanner daha yavaştır.$$, $$n8n-ai-judge$$, '2026-08-31 19:26:19.325832',
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
    ($$Regex eşleşmesi yaparken$$, TRUE, 0),
    ($$Sadece satır okurken$$, FALSE, 1),
    ($$Herhangi bir durumda$$, FALSE, 2),
    ($$Konsoldan okurken$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

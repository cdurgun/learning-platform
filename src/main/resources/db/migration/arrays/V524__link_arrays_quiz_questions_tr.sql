-- Promotion-style migration linking TR Arrays quiz questions to the topic's
-- fixed quiz created in arrays/V522 -- same pattern as git-fundamentals/
-- V467-V468 and string/V492 (WITH ... RETURNING id + NOT EXISTS dedup +
-- ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 374, 375, 376, 377, 378, 379
-- Topic: arrays (language: tr)
-- These are ALL 6 TR questions PUBLISHED for this topic (question-
-- promotion/V520 -- AI Judge auto-publish -- and V521 -- human ADMIN
-- review via QuestionReviewService.publish). Dev id 380 (REJECTED by the
-- human reviewer) is correctly excluded, same as it was from V520/V521.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V523 -- see that file's header for the full rationale.

-- Question 1/6 (dev id 374, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir dizinin boyutu ne zaman belirlenir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Bir dizinin boyutu ne zaman belirlenir?$$, NULL, NULL,
           $$Dizinin boyutu oluşturulduğu anda belirlenir ve bir daha değişmez. Bu, dizilerin dinamik boyutlu koleksiyonlardan en temel farkıdır.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.877639',
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
    ($$Oluşturulduğu anda$$, TRUE, 0),
    ($$Program çalışırken$$, FALSE, 1),
    ($$Eleman eklenirken$$, FALSE, 2),
    ($$Bir metot çağrıldığında$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (dev id 375, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri dizilerin temel özelliklerindendir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri dizilerin temel özelliklerindendir?$$, NULL, NULL,
           $$Diziler, aynı tipten sabit sayıda elemanı tutan bir veri yapısıdır ve bellekte ardışık bir blokta yer alır. Bu özellikler, dizilerin O(1) index erişimi sağlamasına olanak tanır.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.412737',
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
    ($$Bellekte ardışık bir blokta tutulur$$, TRUE, 0),
    ($$Dinamik boyutludur$$, FALSE, 1),
    ($$O(1) index erişimi sağlar$$, TRUE, 2),
    ($$Farklı tipte elemanlar içerebilir$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (dev id 376, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri çok boyutlu dizilerin özelliklerindendir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri çok boyutlu dizilerin özelliklerindendir?$$, NULL, NULL,
           $$Çok boyutlu diziler, her satırın bağımsız bir dizi nesnesi olabileceği için farklı uzunluklara sahip olabilir. Bu özellik, jagged array olarak adlandırılır.$$, $$gentest-review-admin@example.com$$, '2026-08-31 18:44:40.428334',
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
    ($$Her satır aynı uzunlukta olmalıdır$$, FALSE, 0),
    ($$Düzenli bir grid yapısı oluşturabilir$$, TRUE, 1),
    ($$Her satır farklı uzunlukta olabilir$$, TRUE, 2),
    ($$Diziler dizisi olarak tanımlanabilir$$, TRUE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (dev id 377, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Arrays.asList() metodu ne tür bir görünüm döner?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Arrays.asList() metodu ne tür bir görünüm döner?$$, NULL, NULL,
           $$Arrays.asList() metodu, orijinal diziyi sabit boyutlu bir liste görünümü ile sarar. Bu görünüm üzerinden yazmak orijinal diziyi de değiştirir.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.888023',
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
    ($$Dinamik boyutlu bir liste$$, FALSE, 0),
    ($$Sabit boyutlu bir liste görünümü$$, TRUE, 1),
    ($$Yeni bir kopya$$, FALSE, 2),
    ($$Boş bir liste$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (dev id 378, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kodun çıktısı ne olacaktır?$$
      AND code_snippet = $$int[] numbers = {1, 2, 3};
System.out.println(Arrays.toString(numbers));$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki kodun çıktısı ne olacaktır?$$,
           $$int[] numbers = {1, 2, 3};
System.out.println(Arrays.toString(numbers));$$, $$java$$,
           $$Kod, dizinin içeriğini Arrays.toString() metodu ile yazdırdığı için [1, 2, 3] şeklinde bir çıktı verir.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.898912',
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
    ($$[1, 2, 3]$$, TRUE, 0),
    ($$[I@7ea987ac$$, FALSE, 1),
    ($$1, 2, 3$$, FALSE, 2),
    ($$null$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (dev id 379, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'arrays')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir dizinin elemanlarını karşılaştırmak için hangi metodu kullanmalıyız?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Bir dizinin elemanlarını karşılaştırmak için hangi metodu kullanmalıyız?$$, NULL, NULL,
           $$İki dizinin içeriğini karşılaştırmak için Arrays.equals() metodunu kullanmalıyız, çünkü == operatörü yalnızca referansı karşılaştırır.$$, $$n8n-ai-judge$$, '2026-08-31 17:07:53.910214',
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
    ($$Arrays.compare()$$, FALSE, 0),
    ($$Arrays.equals()$$, TRUE, 1),
    ($$Arrays.compareTo()$$, FALSE, 2),
    ($$== operatörü$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR Wrapper Classes & Autoboxing quiz
-- questions to the topic's fixed quiz created in wrapper-classes/V530 --
-- same pattern as arrays/V524 and scanner/V528 (WITH ... RETURNING id +
-- NOT EXISTS dedup + ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 426, 427, 428, 429, 431
-- Topic: wrapper-classes (language: tr)
-- These are ALL 5 TR questions PUBLISHED for this topic (question-
-- promotion/V529, 3 via AI Judge auto-publish, 2 via human ADMIN review
-- correcting AI Judge false-negative rejections). Dev ids 430, 432, 433
-- (REJECTED by the human reviewer for genuine content defects) are
-- correctly excluded, same as they were from V529.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V531 -- see that file's header for the full rationale.

-- Question 1/5 (dev id 426, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi Java'daki bir wrapper sınıfıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangisi Java'daki bir wrapper sınıfıdır?$$, NULL, NULL,
           $$Integer, Java'daki int ilkel tipinin wrapper sınıfıdır. Diğer seçenekler ilkel tiplerdir ve wrapper sınıfı değildir.$$, $$n8n-ai-judge$$, '2026-08-31 22:44:57.312923',
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
    ($$Integer$$, TRUE, 0),
    ($$int$$, FALSE, 1),
    ($$double$$, FALSE, 2),
    ($$boolean$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (dev id 427, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki durumlardan hangileri wrapper sınıflarının avantajlarıdır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki durumlardan hangileri wrapper sınıflarının avantajlarıdır?$$, NULL, NULL,
           $$Wrapper sınıfları, ilkel tiplerin null değerini temsil edebilmesi ve generic koleksiyonlarla kullanılabilmesi gibi avantajlara sahiptir. Diğer seçenekler bu avantajları yansıtmaz.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:47:56.940977',
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
    ($$Null değerini temsil edebilme$$, TRUE, 0),
    ($$Generic koleksiyonlarla kullanılabilme$$, TRUE, 1),
    ($$Daha hızlı işlem yapma$$, FALSE, 2),
    ($$Bellek tasarrufu sağlama$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (dev id 428, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kodun çıktısı ne olacaktır?$$
      AND code_snippet = $$Integer a = 100;
Integer b = 100;
System.out.println(a == b);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki kodun çıktısı ne olacaktır?$$,
           $$Integer a = 100;
Integer b = 100;
System.out.println(a == b);$$, $$java$$,
           $$Bu kod, -128 ile 127 arasındaki Integer değerleri için önbellekleme kullanıldığı için true dönecektir. Ancak bu durum her zaman güvenilir değildir, bu yüzden equals() metodu kullanılmalıdır.$$, $$gentest-review-admin@example.com$$, '2026-08-31 22:48:01.612077',
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
    ($$0$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (dev id 429, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi autoboxing'in tanımıdır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangisi autoboxing'in tanımıdır?$$, NULL, NULL,
           $$Autoboxing, derleyicinin bir ilkel değeri otomatik olarak wrapper nesnesine dönüştürmesidir. Bu, wrapper sınıflarının temel işlevlerinden biridir.$$, $$n8n-ai-judge$$, '2026-08-31 22:44:57.322376',
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
    ($$Derleyicinin bir ilkel değeri otomatik olarak wrapper nesnesine dönüştürmesi$$, TRUE, 0),
    ($$Bir wrapper nesnesini otomatik olarak ilkel değere dönüştürmesi$$, FALSE, 1),
    ($$Wrapper nesnelerini karşılaştırma işlemi$$, FALSE, 2),
    ($$Bir koleksiyona ilkel tip ekleme işlemi$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (dev id 431, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wrapper-classes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kodun çıktısı ne olacaktır?$$
      AND code_snippet = $$Integer nullable = null;
int x = nullable + 1;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki kodun çıktısı ne olacaktır?$$,
           $$Integer nullable = null;
int x = nullable + 1;$$, $$java$$,
           $$Bu kod, nullable değişkeni null olduğu için NullPointerException fırlatır. Aritmetik bir ifadede null kullanmak bu hatayı oluşturur.$$, $$n8n-ai-judge$$, '2026-08-31 22:44:57.33164',
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
    ($$NullPointerException$$, TRUE, 0),
    ($$1$$, FALSE, 1),
    ($$0$$, FALSE, 2),
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
WHERE t.slug = 'wrapper-classes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

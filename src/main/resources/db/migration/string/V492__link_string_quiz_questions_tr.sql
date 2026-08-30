-- Promotion-style migration linking TR String quiz questions to the
-- topic's fixed quiz created in string/V490 -- same pattern as
-- git-fundamentals/V467-V468 (WITH ... RETURNING id + NOT EXISTS dedup +
-- ON CONFLICT DO NOTHING on the link insert).
--
-- Development Question IDs: 326, 328, 329, 331, 337, 339, 340, 341, 347, 349
-- Topic: string (language: tr)
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

-- Question 1/10 (dev id 326, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri String nesnelerinin temel özelliklerindendir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String nesnelerinin temel özelliklerindendir?$$, NULL, NULL,
           $$Doğru cevaplar 'Immutable' ve 'String Pool'dur. String nesneleri immutable'dır ve aynı metne sahip string literalleri String Pool içinde paylaşılır. 'Mutable' seçeneği yanlıştır çünkü String nesneleri değiştirilemez.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.646557',
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
    ($$Immutable$$, TRUE, 0),
    ($$Mutable$$, FALSE, 1),
    ($$String Pool$$, TRUE, 2),
    ($$Dinamik$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/10 (dev id 328, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki ifadelerden hangileri String.format() metodunun özellikleridir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Aşağıdaki ifadelerden hangileri String.format() metodunun özellikleridir?$$, NULL, NULL,
           $$Doğru cevaplar '%s, %d, %.2f' ve 'printf tarzı biçimlendirme' ifadeleridir. Bu ifadeler String.format() metodunun işlevselliğini tanımlar. 'String birleştirme' yanlıştır çünkü bu metod birleştirme işlemi yapmaz.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.648863',
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
    ($$%s, %d, %.2f$$, TRUE, 0),
    ($$String birleştirme$$, FALSE, 1),
    ($$Hata mesajı yazdırma$$, FALSE, 2),
    ($$printf tarzı biçimlendirme$$, TRUE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/10 (dev id 329, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$String nesneleri arasında içerik karşılaştırması yapmak için hangi metot kullanılmalıdır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$String nesneleri arasında içerik karşılaştırması yapmak için hangi metot kullanılmalıdır?$$, NULL, NULL,
           $$Doğru cevap 'equals()' metodudur. equals() metodu içerik karşılaştırması yapar. '==' operatörü ise nesne kimliğini karşılaştırdığı için yanlış bir seçimdir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.651658',
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
    ($$==$$, FALSE, 0),
    ($$equals()$$, TRUE, 1),
    ($$compareTo()$$, FALSE, 2),
    ($$equalsIgnoreCase()$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/10 (dev id 331, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java'da bir String nesnesi oluşturmanın en yaygın yolu nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Java'da bir String nesnesi oluşturmanın en yaygın yolu nedir?$$, NULL, NULL,
           $$Doğru cevap 'literal yazmak'tır. String nesneleri genellikle bir literal ile oluşturulur. 'new String() kullanmak' yanlıştır çünkü bu, her zaman yeni bir nesne yaratır ve genellikle gereksizdir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.653739',
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
    ($$new String() kullanmak$$, FALSE, 0),
    ($$literal yazmak$$, TRUE, 1),
    ($$char[] kullanmak$$, FALSE, 2),
    ($$StringBuilder kullanmak$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/10 (dev id 337, quiz position 5)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri String sınıfının immutability özelliğinden kaynaklanan avantajlardır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String sınıfının immutability özelliğinden kaynaklanan avantajlardır?$$, NULL, NULL,
           $$Doğru seçenekler, immutability'nin sağladığı avantajlardır. Thread-safe olması, hashCode değerinin önbelleğe alınabilmesi ve string pool'un varlığı bu avantajlar arasındadır. Diğer seçenekler ise immutability ile doğrudan ilgili değildir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.657794',
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
    ($$Thread-safe olması$$, TRUE, 0),
    ($$Bellek tasarrufu sağlaması$$, TRUE, 1),
    ($$Daha hızlı string birleştirme$$, FALSE, 2),
    ($$Daha fazla bellek kullanması$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/10 (dev id 339, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$String birleştirmede hangi yöntem daha performanslıdır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$String birleştirmede hangi yöntem daha performanslıdır?$$, NULL, NULL,
           $$StringBuilder, string birleştirme işlemlerinde daha performanslıdır çünkü her birleştirme işlemi yeni bir nesne yaratmaz. Diğer yöntemler, özellikle döngülerde kullanıldığında, O(n²) maliyetine yol açabilir.$$, $$n8n-ai-judge$$, '2026-08-30 13:53:04.753423',
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
    ($$StringBuilder kullanmak$$, TRUE, 0),
    ($$String.format() kullanmak$$, FALSE, 1),
    ($$String literal kullanmak$$, FALSE, 2),
    ($$String.concat() kullanmak$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/10 (dev id 340, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri String sınıfının yaygın hataları arasında yer alır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String sınıfının yaygın hataları arasında yer alır?$$, NULL, NULL,
           $$Doğru seçenekler, string karşılaştırmalarında ve metot dönüş değerlerinin atanmamasıyla ilgili yaygın hatalardır. Diğer seçenekler ise yaygın hatalar arasında sayılmaz.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.660218',
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
    ($$== ile string içeriğini karşılaştırmak$$, TRUE, 0),
    ($$Bir String metodunun dönüş değerini atamamak$$, TRUE, 1),
    ($$StringBuilder kullanmak$$, FALSE, 2),
    ($$String.format() kullanmak$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 8/10 (dev id 341, quiz position 8)
WITH existing_q8 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$StringBuilder ile ilgili hangisi doğrudur?$$
),
inserted_q8 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$StringBuilder ile ilgili hangisi doğrudur?$$, NULL, NULL,
           $$StringBuilder, mutable bir karakter dizisi tutarak aynı nesneyi yerinde değiştirir. Bu, yeni bir nesne döndürmediği için performans açısından avantaj sağlar.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.662466',
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
    ($$Mutable bir karakter dizisi tutar$$, TRUE, 0),
    ($$Her zaman yeni bir nesne döndürür$$, FALSE, 1),
    ($$Sadece tek satırlı string'ler için kullanılır$$, FALSE, 2),
    ($$Thread-safe değildir$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 9/10 (dev id 347, quiz position 9)
WITH existing_q9 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri String birleştirme işlemleri için en iyi uygulamalardır?$$
),
inserted_q9 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'OPENAI',
           $$Aşağıdakilerden hangileri String birleştirme işlemleri için en iyi uygulamalardır?$$, NULL, NULL,
           $$Doğru cevaplar 'StringBuilder kullanmak' ve 'Kısa birleştirmeler için + kullanmak'. StringBuilder, döngülerde string birleştirme için daha verimlidir. 'String kullanmak' ve '+= operatörünü kullanmak' yanlıştır çünkü bu yöntemler performans sorunlarına yol açabilir.$$, $$cdurgun@gmail.com$$, '2026-08-30 15:35:44.664725',
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
    ($$String kullanmak$$, FALSE, 0),
    ($$StringBuilder kullanmak$$, TRUE, 1),
    ($$+ operatörünü kullanmak$$, FALSE, 2),
    ($$Kısa birleştirmeler için + kullanmak$$, TRUE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 10/10 (dev id 349, quiz position 10)
WITH existing_q10 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'string')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java 15 ile gelen çok satırlı string tanımlama yöntemi nedir?$$
),
inserted_q10 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'OPENAI',
           $$Java 15 ile gelen çok satırlı string tanımlama yöntemi nedir?$$, NULL, NULL,
           $$Doğru cevap 'Text Block' çünkü bu, çok satırlı string'leri tanımlamak için kullanılan yeni bir sözdizimidir. 'String.format()' yanlıştır çünkü bu sadece biçimlendirme için kullanılır.$$, $$n8n-ai-judge$$, '2026-08-30 14:35:28.878312',
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
    ($$String.format()$$, FALSE, 0),
    ($$Text Block$$, TRUE, 1),
    ($$StringBuilder$$, FALSE, 2),
    ($$String.join()$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;


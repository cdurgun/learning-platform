-- Links the TR jsx questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jsx')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JSX aslında nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JSX aslında nedir?$$,
           NULL, NULL,
           $$JSX, HTML'e çok benzeyen ama gerçekte JavaScript'in bir uzantısı olan bir söz dizimidir. Tarayıcı onu doğrudan anlayamaz; proje build edilirken kendiliğinden düz JavaScript'e dönüştürülür ve tarayıcıya yalnızca JavaScript ulaşır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'jsx'
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
        ($$HTML'in React için hazırlanmış yeni bir sürümü$$, FALSE, 0),
        ($$Tarayıcıların doğrudan çalıştırdığı ayrı bir programlama dili$$, FALSE, 1),
        ($$HTML'e çok benzeyen, JavaScript'in bir uzantısı olan bir söz dizimi$$, TRUE, 2),
        ($$Yalnızca stil tanımlamak için kullanılan bir şablon dili$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jsx'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jsx')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JSX ile düz HTML arasındaki en önemli farklardan biri nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JSX ile düz HTML arasındaki en önemli farklardan biri nedir?$$,
           NULL, NULL,
           $$JSX sonuçta bir JavaScript değeridir: bir değişkene atanabilir, bir fonksiyondan döndürülebilir ya da bir listeye konabilir. Görünüş ise büyük ölçüde aynıdır; `<div>` ve `<button>` gibi etiketler JSX'te de kullanılır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'jsx'
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
        ($$JSX'te `<div>` ve `<button>` gibi etiketler kullanılamaz$$, FALSE, 0),
        ($$JSX'te elemanlar iç içe yazılamaz$$, FALSE, 1),
        ($$JSX tarayıcıda derlenmeden doğrudan çalışır$$, FALSE, 2),
        ($$JSX bir JavaScript değeridir; değişkene atanabilir ya da fonksiyondan döndürülebilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jsx'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jsx')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JSX'te süslü parantezlerin içine aşağıdakilerden hangileri yazılabilir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JSX'te süslü parantezlerin içine aşağıdakilerden hangileri yazılabilir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Süslü parantezlerin içine bir değer üreten her şey yazılabilir: bir değişken, bir hesaplama ya da bir fonksiyon çağrısı. `if` bloğu bir değer üretmez, yalnızca bir kod bloğunun çalışıp çalışmayacağına karar verir; bu yüzden oraya yazılamaz. Koşula göre değer gerekiyorsa üçlü operatör kullanılır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'jsx'
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
        ($$Bir fonksiyon çağrısı$$, TRUE, 0),
        ($$Üçlü operatör (`? :`) ile yazılmış bir ifade$$, TRUE, 1),
        ($$Bir `if` bloğu$$, FALSE, 2),
        ($$Değer üretmeyen bir deyim$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jsx'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jsx')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JSX'te bir attribute'un değeri bir JavaScript ifadesine nasıl bağlanır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JSX'te bir attribute'un değeri bir JavaScript ifadesine nasıl bağlanır?$$,
           NULL, NULL,
           $$Metin içeriğinde olduğu gibi, attribute değeri de süslü parantez içine yazılarak bir JavaScript ifadesine bağlanır. Tırnak içine yazılan değer ise ifade olarak değerlendirilmez, olduğu gibi bir metin olarak kalır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'jsx'
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
        ($$Değer tırnak içine yazılarak, örneğin `src="adres"`$$, FALSE, 0),
        ($$Değer süslü parantez içine yazılarak, örneğin `src={adres}`$$, TRUE, 1),
        ($$Attribute adı `className` ile değiştirilerek$$, FALSE, 2),
        ($$Yalnızca `class` attribute'u bir ifadeye bağlanabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jsx'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jsx')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi geçerli bir JSX kuralıdır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangisi geçerli bir JSX kuralıdır?$$,
           NULL, NULL,
           $$JSX'te `<img>` ve `<input>` gibi kendi kendini kapatan etiketler her zaman `/` ile kapatılmalıdır. Bir JSX bloğu tek bir kök elemana sahip olmalıdır, attribute adları camelCase yazılır (`onClick`) ve Fragment sayfaya fazladan bir eleman eklemez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'jsx'
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
        ($$Bir JSX bloğu yan yana iki kök eleman döndürebilir$$, FALSE, 0),
        ($$Attribute adları tamamı küçük harfle yazılır: `onclick`$$, FALSE, 1),
        ($$Kendi kendini kapatan etiketler `/` ile kapatılır: `<img />`$$, TRUE, 2),
        ($$Fragment (`<> </>`) sayfaya fazladan bir `<div>` ekler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jsx'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

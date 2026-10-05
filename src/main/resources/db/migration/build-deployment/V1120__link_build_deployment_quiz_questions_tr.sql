-- Links the TR build-deployment questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'build-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`npm run build` çalıştırıldığında ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`npm run build` çalıştırıldığında ne olur?$$,
           NULL, NULL,
           $$Build, kodu küçültür, gereksiz olanı atar ve statik `.html`/`.js`/`.css` dosyalarını `dist/` klasörüne yazar; deploy edilen şey tam olarak bu klasördür. Kodun her değişiklikte tarayıcıya anında gönderilmesi ise `npm run dev`'in geliştirme sırasındaki davranışıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'build-deployment'
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
        ($$Kod, her değişiklikte tarayıcıya anında yeniden gönderilir$$, FALSE, 0),
        ($$Proje kendiliğinden yayınlanır ve canlı bir adres üretilir$$, FALSE, 1),
        ($$Kod küçültülür ve statik dosyalar `dist/` klasörüne yazılır$$, TRUE, 2),
        ($$`.env` dosyasındaki değerler git deposuna eklenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'build-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'build-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Vite, ortam değişkenlerini istemci koduna nasıl yerleştirir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Vite, ortam değişkenlerini istemci koduna nasıl yerleştirir?$$,
           NULL, NULL,
           $$Vite, `VITE_` ön ekiyle başlayan değişkenleri build sırasında koda gömer. Ön eki olmayanlar istemci koduna hiç girmez; bu, gizli bir anahtarın yanlışlıkla tarayıcı koduna sızmasını önleyen bilinçli bir tercihtir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'build-deployment'
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
        ($$Build sırasında; `.env` dosyasındaki tüm değişkenleri$$, FALSE, 0),
        ($$Sayfa her açıldığında sunucudan okuyarak; tüm değişkenleri$$, FALSE, 1),
        ($$Yalnızca `npm run dev` çalışırken; ön eki olmayanları$$, FALSE, 2),
        ($$Build sırasında; yalnızca `VITE_` ön ekiyle başlayanları$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'build-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'build-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`import.meta.env` içinden okunan bir feature flag'in açık olup olmadığı nasıl kontrol edilmelidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`import.meta.env` içinden okunan bir feature flag'in açık olup olmadığı nasıl kontrol edilmelidir?$$,
           NULL, NULL,
           $$`import.meta.env` içindeki her değer bir string'dir; `"false"` bile boş olmayan bir string olduğu için truthy sayılır. Bu yüzden değer `=== "true"` ile açıkça karşılaştırılmalıdır; doğrudan `if` içine yazmak kapalı bir bayrağı da açık gösterir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'build-deployment'
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
        ($$`=== "true"` ile açıkça karşılaştırılarak, çünkü tüm değerler string'dir$$, TRUE, 0),
        ($$Doğrudan `if` içine yazılarak, çünkü değerler boolean olarak gelir$$, FALSE, 1),
        ($$`=== true` ile karşılaştırılarak, çünkü Vite değerleri boolean'a çevirir$$, FALSE, 2),
        ($$`!== undefined` ile karşılaştırılarak, çünkü kapalı bayraklar tanımsızdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'build-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'build-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`.env` dosyaları neden genellikle git'e eklenmez?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`.env` dosyaları neden genellikle git'e eklenmez?$$,
           NULL, NULL,
           $$Gerçek değerler kişiye ya da ortama özel olabilir; bu yüzden `.env` dosyası `.gitignore`'a eklenir. Onun yerine hangi değişkenlerin gerektiğini gerçek değerler olmadan gösteren bir `.env.example` commit edilir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'build-deployment'
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
        ($$Git, adı nokta ile başlayan dosyaları saklayamadığı için$$, FALSE, 0),
        ($$Gerçek değerler kişiye ya da ortama özel olabildiği için$$, TRUE, 1),
        ($$Vite bu dosyayı her build'de sildiği için$$, FALSE, 2),
        ($$Dosya yalnızca production ortamında okunduğu için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'build-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'build-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Vercel, bir Vite projesi için aşağıdakilerden hangilerini kendiliğinden doğru ayarlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Vercel, bir Vite projesi için aşağıdakilerden hangilerini kendiliğinden doğru ayarlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Vercel Vite projelerini otomatik tanır; build komutu (`npm run build`) ve çıktı klasörü (`dist`) senin için doğru ayarlanır. Ortam değişkenlerini ise kendin eklemen gerekir; monorepo'da ilgili proje klasörünü de sen belirtirsin.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'build-deployment'
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
        ($$`.env` dosyandaki ortam değişkenlerini$$, FALSE, 0),
        ($$Monorepo içindeki proje klasörünü$$, FALSE, 1),
        ($$Build komutunu (`npm run build`)$$, TRUE, 2),
        ($$Çıktı klasörünü (`dist`)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'build-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

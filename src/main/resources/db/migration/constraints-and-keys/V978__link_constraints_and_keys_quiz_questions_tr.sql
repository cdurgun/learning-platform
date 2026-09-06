-- Promotion-style migration linking TR constraints-and-keys quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `PRIMARY KEY` hangi iki kısıtı birlikte paketler?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `PRIMARY KEY` hangi iki kısıtı birlikte paketler?$$,
           NULL, NULL,
           $$Ders, PRIMARY KEY'in gerçekte birlikte paketlenmiş iki kısıt olduğunu belirtir: NOT NULL (bir primary key sütunu asla boş olamaz) artı UNIQUE (hiçbir iki satır aynı değeri paylaşamaz) -- ve PostgreSQL onun üzerine otomatik olarak bir index inşa eder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$`UNIQUE` artı `FOREIGN KEY`$$, FALSE, 0),
    ($$`NOT NULL` artı `CHECK`$$, FALSE, 1),
    ($$`NOT NULL` artı `UNIQUE`$$, TRUE, 2),
    ($$`CHECK` artı `FOREIGN KEY`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, uygulama kodu, öyle bir id'ye sahip bir kurs olmadığında `course_id`'si `9999` olan bir `category` satırını `INSERT` etmeye çalışırsa gerçekte ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, uygulama kodu, öyle bir id'ye sahip bir kurs olmadığında `course_id`'si `9999` olan bir `category` satırını `INSERT` etmeye çalışırsa gerçekte ne olur?$$,
           NULL, NULL,
           $$Ders, FOREIGN KEY kısıtının referential integrity'yi zorunlu kıldığını belirtir: PostgreSQL'in kendisi, Java kodunun önceden neyi doğrulayıp doğrulamadığından bağımsız olarak, gerçek, spesifik bir hatayla ('violates foreign key constraint') INSERT'i doğrudan reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$Satır başarıyla eklenir, `course_id` sessizce `9999` yerine `NULL` olarak ayarlanır$$, FALSE, 0),
    ($$Satır başarıyla eklenir, ve PostgreSQL otomatik olarak `9999` id'sine sahip yeni bir `course` satırı oluşturur$$, FALSE, 1),
    ($$Satır başarıyla eklenir, ama işlem başarısız olmak yerine bir uyarı loglanır$$, FALSE, 2),
    ($$PostgreSQL, Java seviyesinde doğrulamadan bağımsız olarak, spesifik bir 'violates foreign key constraint' hatasıyla INSERT'i doğrudan reddeder$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$V1__init_schema.sql'den alınan bu gerçek foreign key göz önüne alındığında, bir `course` satırı silinirse, ona referans veren `category` satırlarına ne olur?$$
      AND code_snippet = $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$V1__init_schema.sql'den alınan bu gerçek foreign key göz önüne alındığında, bir `course` satırı silinirse, ona referans veren `category` satırlarına ne olur?$$,
           $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$, $$sql$$,
           $$Ders, ON DELETE CASCADE'in, bir course satırını silmenin ona referans veren her category satırını da otomatik olarak sildiği anlamına geldiğini açıklar -- bu, o kategorilere bağımlı her topic ve topic_translation'a daha da yayılır, çünkü bir satırı silmek bilerek tüm bağımlı alt ağacı siler.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$O course'a referans veren her `category` satırı da otomatik olarak silinir, bu da bağımlı `topic` satırlarına daha da yayılır$$, TRUE, 0),
    ($$`course` üzerindeki `DELETE` doğrudan başarısız olur, çünkü bir foreign key her zaman referans verilen bir satırı silmeyi engeller$$, FALSE, 1),
    ($$`category` satırları değişmeden kalır, ama `course_id` sütunları `NULL` olarak ayarlanır$$, FALSE, 2),
    ($$`category` satırlarına hiçbir şey olmaz -- `ON DELETE CASCADE` yalnızca `course` tablosunun kendi satırlarını etkiler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`quiz_question_link`'ten alınan bu gerçek kısıt göz önüne alındığında, hâlâ yayınlanmış bir quiz'e bağlı bir soru için `DELETE FROM question WHERE id = ...` denendiğinde ne olur?$$
      AND code_snippet = $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`quiz_question_link`'ten alınan bu gerçek kısıt göz önüne alındığında, hâlâ yayınlanmış bir quiz'e bağlı bir soru için `DELETE FROM question WHERE id = ...` denendiğinde ne olur?$$,
           $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$, $$sql$$,
           $$Ders, ON DELETE RESTRICT'in silmeyi doğrudan engellediğini açıklar: bir soru herhangi bir yayınlanmış quiz'e bağlı olduğu sürece, DELETE FROM question, bağlantıyı onunla birlikte sessizce kaldırmak yerine bir hatayla başarısız olur -- CASCADE'in davranışının tam tersi.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$Hiçbir şey olmaz -- `RESTRICT` tamamen dokümantasyondur ve gerçek bir zorlama etkisi yoktur$$, FALSE, 0),
    ($$`DELETE` bir hatayla başarısız olur -- `ON DELETE RESTRICT`, bağlantı hâlâ var olduğu sürece bunu doğrudan engeller$$, TRUE, 1),
    ($$`question` satırı silinir, ve `quiz_question_link` satırı onunla birlikte otomatik olarak silinir$$, FALSE, 2),
    ($$`question` satırı silinir, ve `quiz_question_link.question_id` otomatik olarak `NULL` olarak ayarlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projenin gerçek `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)`'ı, iki farklı kursun her birinin `fundamentals` slug'ına sahip bir kategoriye sahip olmasına izin verir. Bu derse göre, neden?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)`'ı, iki farklı kursun her birinin `fundamentals` slug'ına sahip bir kategoriye sahip olmasına izin verir. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, kompozit (tablo seviyesi) bir UNIQUE'in yalnızca her iki sütunun kombinasyonundaki yinelemeleri reddettiğini açıklar -- iki farklı kurs, her biri `fundamentals` slug'ına sahip bir kategoriye sahip olmakta serbesttir, ama aynı kursun iki tanesi olamaz; bu, her biri tek başına o sütunun yinelemelerini reddedecek iki ayrı tek-sütunlu UNIQUE kısıtından gerçekten farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$PostgreSQL'de `UNIQUE` kısıtları yalnızca listelenen ilk sütuna uygulanır, ek sütunları sessizce yok sayar$$, FALSE, 0),
    ($$Kompozit kısıt yalnızca kısıt eklendikten sonra eklenen satırlara uygulanır, tablo seviyesi bir garantiye değil$$, FALSE, 1),
    ($$Kompozit bir UNIQUE, yalnızca her iki sütunun kombinasyonundaki yinelemeleri reddeder -- iki farklı `course_id` altında aynı `slug` bir yineleme değildir$$, TRUE, 2),
    ($$Bu projenin şemasında bir hatadır -- kompozit bir UNIQUE'in iki ayrı tek-sütunlu UNIQUE kısıtı gibi davranması gerekiyordu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projenin gerçek `topic.estimated_minutes` sütununun bugün hiçbir `CHECK` kısıtı yok. Bu derse göre, bu pratikte ne anlama gelir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `topic.estimated_minutes` sütununun bugün hiçbir `CHECK` kısıtı yok. Bu derse göre, bu pratikte ne anlama gelir?$$,
           NULL, NULL,
           $$Ders, bunun gerçek, dürüst bir boşluk olduğunu belirtir: şu anda veritabanı seviyesinde hiçbir şey bir migration'ın estimated_minutes'a negatif bir değer eklemesini engellemiyor -- şimdiye kadar yalnızca uygulama seviyesi özen (ve doğru migration'lar) her satırı geçerli tutmuştur; bir CHECK kısıtı bu varsayımı PostgreSQL'in kendisinin bir satırın ihlal etmesine izin vermediği bir şeye dönüştürürdü.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$PostgreSQL, açık bir CHECK olmasa bile, herhangi bir INTEGER sütunu için makul, yalnızca pozitif bir aralığı otomatik olarak çıkarır$$, FALSE, 0),
    ($$Hibernate bu sütun üzerinde otomatik olarak pozitif-değer kuralını zorunlu kılar, bu yüzden veritabanı seviyesinde bir CHECK gereksizdir$$, FALSE, 1),
    ($$Bu sütunun, BIGSERIAL tipinin tasarımı gereği hiçbir zaman negatif bir değere ayarlanamayacağı tanımlanır$$, FALSE, 2),
    ($$Şu anda veritabanı seviyesinde hiçbir şey bir migration'ın negatif bir `estimated_minutes` değeri eklemesini engellemiyor -- şimdiye kadar yalnızca uygulama seviyesi özen satırları geçerli tuttu$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, kısıtlar ve anahtarlar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, kısıtlar ve anahtarlar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (hiç ON DELETE ifadesi belirtilmediğinde varsayılan davranışın etkili bir şekilde RESTRICT olması, silmeyi engellemesi; uq_category_course_slug gibi birden fazla sütuna yayılan tablo seviyesi kısıtların, otomatik oluşturulan bir ada güvenmek yerine bu projede her zaman açıkça adlandırılması); ders, UNIQUE'in NOT NULL anlamına GELMEDİĞİNİ (bir UNIQUE sütunun birden fazla NULL tutabileceğini) açıkça belirtir, ve bir CHECK kısıtının yalnızca mevcut satırın kendi değerlerini görebileceğini, başka bir tablonun verisini değil -- çapraz tablo doğrulamasının bunun yerine bir trigger ya da uygulama seviyesi kontrol gerektirdiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$Hiç `ON DELETE` ifadesi belirtilmediğinde, varsayılan davranış etkili bir şekilde `RESTRICT`tir -- silme engellenir$$, TRUE, 0),
    ($$Bu proje, birden fazla sütuna yayılan tablo seviyesi kısıtları, otomatik oluşturulan bir ada güvenmek yerine her zaman açıkça adlandırır$$, TRUE, 1),
    ($$Bir sütundaki `UNIQUE` kısıtı, o sütunun aynı zamanda `NOT NULL` olduğu anlamına otomatik olarak gelir$$, FALSE, 2),
    ($$Bir `CHECK` kısıtı, yalnızca mevcut satırın kendi değerlerini değil, başka bir tablonun verisini referans alıp doğrulayabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

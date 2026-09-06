-- Promotion-style migration linking TR postgresql-specific-data-types quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `gen_random_uuid()` ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `gen_random_uuid()` ne yapar?$$,
           NULL, NULL,
           $$Ders, gen_random_uuid()'in, bir sütun default'u olarak rastgele (version 4) bir UUID üreten, PostgreSQL'in kendi yerleşik fonksiyonu olduğunu belirtir -- BIGSERIAL'in örtük sequence'inin doğrudan UUID eşdeğeri, hiçbir uygulama kodu dahil olmadan.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$Her çağrıldığında birer birer artan, sıralı, tahmin edilebilir bir UUID üretir$$, FALSE, 0),
    ($$Gerçek bir PostgreSQL fonksiyonu değil, Hibernate tarafından sağlanan bir Java metodudur$$, FALSE, 1),
    ($$Bir sütun default'u olarak kullanılabilen, rastgele (version 4) bir UUID üreten PostgreSQL'in yerleşik fonksiyonu$$, TRUE, 2),
    ($$Bir tablodaki var olan bir `BIGSERIAL` değerini kendi `UUID` gösterimine dönüştürür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `JSON` ile `JSONB` arasındaki temel fark nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `JSON` ile `JSONB` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, JSON'ın gönderilen metni tam olarak, byte byte depoladığını, her sorgulandığında yeniden ayrıştırdığını; JSONB'nin ise ayrıştırılmış, daha verimli bir içsel gösterim depoladığını, indexlemeyi desteklediğini (sade JSON'ın desteklemediği), bunun bedeli olarak orijinal anahtar sırasını ya da yinelenen anahtarları korumadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$`JSON` indexlemeyi destekler, `JSONB` desteklemez, çünkü `JSONB` daha eski, daha az verimli formattır$$, FALSE, 0),
    ($$Her açıdan işlevsel olarak aynıdırlar -- `JSONB` yalnızca `JSON`'ın daha yeni bir takma adıdır$$, FALSE, 1),
    ($$`JSONB` her sorguda metni yeniden ayrıştırır, `JSON` ise indexlenebilir bir ikili gösterim depolar$$, FALSE, 2),
    ($$`JSON`, gönderilen metni tam olarak depolar ve her sorguda yeniden ayrıştırır; `JSONB` ayrıştırılmış bir ikili form depolar ve indexlemeyi destekler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ayarlar` değeri `{"tema": "karanlik"}` olduğunda, bu iki karşılaştırma neye değerlenir?$$
      AND code_snippet = $$SELECT ayarlar -> 'tema' = 'karanlik' AS ok_ile,
       ayarlar ->> 'tema' = 'karanlik' AS cift_ok_ile
FROM kullanici_tercihi;$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`ayarlar` değeri `{"tema": "karanlik"}` olduğunda, bu iki karşılaştırma neye değerlenir?$$,
           $$SELECT ayarlar -> 'tema' = 'karanlik' AS ok_ile,
       ayarlar ->> 'tema' = 'karanlik' AS cift_ok_ile
FROM kullanici_tercihi;$$, $$sql$$,
           $$Ders, ->'in bir değeri JSONB OLARAK çıkardığını, ->>'nin ise onu text olarak çıkardığını açıklar; bir JSONB değerini = ile düz bir text literal'e karşılaştırmak asla eşleşmez (görünüşte aynı olsalar bile farklı tiplerdir), bu yüzden ok_ile false'tur; ->> text verir, bu yüzden text = text doğru şekilde true'ya değerlenir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$`ok_ile` = false; `cift_ok_ile` = true$$, TRUE, 0),
    ($$`ok_ile` ve `cift_ok_ile` ikisi de true$$, FALSE, 1),
    ($$`ok_ile` ve `cift_ok_ile` ikisi de false$$, FALSE, 2),
    ($$`ok_ile` = true; `cift_ok_ile` = false$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu iki `kullanici_tercihi.ayarlar` satırı göz önüne alındığında, bu sorgu ne döndürür?$$
      AND code_snippet = $$-- satir 1 ayarlar: {"tema": "karanlik", "dil": "tr"}
-- satir 2 ayarlar: {"tema": "aydinlik"}

SELECT count(*) FROM kullanici_tercihi WHERE ayarlar @> '{"tema": "karanlik"}';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu iki `kullanici_tercihi.ayarlar` satırı göz önüne alındığında, bu sorgu ne döndürür?$$,
           $$-- satir 1 ayarlar: {"tema": "karanlik", "dil": "tr"}
-- satir 2 ayarlar: {"tema": "aydinlik"}

SELECT count(*) FROM kullanici_tercihi WHERE ayarlar @> '{"tema": "karanlik"}';$$, $$sql$$,
           $$Ders, @>'nin bir JSONB değerinin başka birini içerip içermediğini kontrol ettiğini açıklar -- satır 1'in ayarları {"tema": "karanlik"}'i içerir (nesnede başka ne olursa olsun), satır 2'ninki içermez (teması aydınlık), bu yüzden tam olarak 1 satır eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$Bir hata -- `@>` yalnızca array'lerde çalışır, JSONB nesnelerinde değil$$, FALSE, 0),
    ($$1 -- yalnızca satır 1'in `ayarlar`ı `{"tema": "karanlik"}`'i içerir$$, TRUE, 1),
    ($$2 -- her iki satır da eşleşir, çünkü `@>` gerçek anahtar değerlerini yok sayar$$, FALSE, 2),
    ($$0 -- `@>`, kısmi değil, tüm JSONB nesnesinin tam, eksiksiz bir eşleşmesini gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`kod_ornegi.etiketler` değeri `ARRAY['kayitlar', 'degismezlik']` olduğunda, `etiketler[1]` ve `'kayitlar' = ANY(etiketler)` neye değerlenir?$$
      AND code_snippet = $$SELECT etiketler[1] AS ilk_etiket, 'kayitlar' = ANY(etiketler) AS kayitlar_var_mi
FROM kod_ornegi;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`kod_ornegi.etiketler` değeri `ARRAY['kayitlar', 'degismezlik']` olduğunda, `etiketler[1]` ve `'kayitlar' = ANY(etiketler)` neye değerlenir?$$,
           $$SELECT etiketler[1] AS ilk_etiket, 'kayitlar' = ANY(etiketler) AS kayitlar_var_mi
FROM kod_ornegi;$$, $$sql$$,
           $$Ders, PostgreSQL array'lerinin 0-indeksli değil, 1-indeksli olduğunu açıkça belirtir -- bu yüzden etiketler[1] ilk eleman olan 'kayitlar'dır; ANY(etiketler), tek bir değerin array'in herhangi bir yerinde görünüp görünmediğini kontrol eder, ve 'kayitlar' gerçekten görünür, bu yüzden kayitlar_var_mi true'dur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$`ilk_etiket` = `'degismezlik'`; `kayitlar_var_mi` = `true`$$, FALSE, 0),
    ($$`ilk_etiket` = `'kayitlar'`; `kayitlar_var_mi` = `false`, çünkü `ANY` yalnızca ilk elemanı kontrol eder$$, FALSE, 1),
    ($$`ilk_etiket` = `'kayitlar'`; `kayitlar_var_mi` = `true`$$, TRUE, 2),
    ($$`ilk_etiket` = `NULL`, çünkü PostgreSQL array'leri 0-indekslidir ve iki elemanlı bir array için indeks 1 sınırların dışındadır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, PostgreSQL'e özgü veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, PostgreSQL'e özgü veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (JSONB'nin girdiyi normalleştirmesi, bunun tam olarak JSON'ın aksine orijinal anahtar sırasını ya da yinelenen anahtarları KORUMAMASININ nedeni olması; PostgreSQL array'lerinin açıkça 1-indeksli olması, Java'dan gerçek, unutulması kolay bir fark olarak adlandırılması); ders, bir UUID'nin sıralı bilgiyi gizlediğini ama bunun 'güvenli' ile aynı olmadığını -- erişim kontrolünün anahtar tipinden bağımsız olarak hâlâ uygulama/yetkilendirme katmanında gerçekleştiğini açıkça belirtir, ve veriyi JSONB olarak depolamanın şema tasarım kararını tamamen ortadan kaldırmak yerine ertelediğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$PostgreSQL array'leri 0-indeksli değil, 1-indekslidir$$, TRUE, 0),
    ($$Bu derste bir `UUID` primary key, nokta, her zaman `BIGSERIAL`'den daha güvenli olarak tanımlanır$$, FALSE, 1),
    ($$Bu derste veriyi `JSONB` olarak depolamak, bir şema tasarlama ihtiyacını tamamen ortadan kaldırmak olarak tanımlanır$$, FALSE, 2),
    ($$`JSONB`, sade `JSON`'ın yaptığı gibi orijinal anahtar sırasını ya da yinelenen anahtarları korumaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

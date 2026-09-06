-- Promotion batch
-- Topic: postgresql-specific-data-types (language: en x6, tr x6)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/postgresql-specific-data-types.md and content/tr/postgresql-specific-data-types.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker/PostgreSQL
-- Foundations batches.
--
-- Strict 50/50 EN/TR split (6+6) organized as 6 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different sample data/framing/options), not a
-- translation. Every question whose answer depends on shown SQL/code
-- output is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet
-- for CODE_OUTPUT questions, per the bug found and fixed in
-- try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these questions at all.


-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does `gen_random_uuid()` do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states gen_random_uuid() is PostgreSQL's own built-in function for generating a random (version 4) UUID as a column default -- the direct UUID equivalent of BIGSERIAL's implicit sequence, with no application code involved.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL's built-in function for generating a random (version 4) UUID, usable as a column default$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Converts an existing `BIGSERIAL` value in a table into its equivalent `UUID` representation$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Generates a sequential, predictable UUID, incrementing by one each time it's called$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A Java method provided by Hibernate, not an actual PostgreSQL function$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `gen_random_uuid()` ne yapar?$$,
           NULL, NULL,
           $$Ders, gen_random_uuid()'in, bir sütun default'u olarak rastgele (version 4) bir UUID üreten, PostgreSQL'in kendi yerleşik fonksiyonu olduğunu belirtir -- BIGSERIAL'in örtük sequence'inin doğrudan UUID eşdeğeri, hiçbir uygulama kodu dahil olmadan.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her çağrıldığında birer birer artan, sıralı, tahmin edilebilir bir UUID üretir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Gerçek bir PostgreSQL fonksiyonu değil, Hibernate tarafından sağlanan bir Java metodudur$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir sütun default'u olarak kullanılabilen, rastgele (version 4) bir UUID üreten PostgreSQL'in yerleşik fonksiyonu$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir tablodaki var olan bir `BIGSERIAL` değerini kendi `UUID` gösterimine dönüştürür$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the key difference between `JSON` and `JSONB`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states JSON stores the exact text submitted, byte for byte, re-parsing it every time it's queried; JSONB stores a parsed, more efficient internal representation, supports indexing (which plain JSON doesn't), at the cost of not preserving original key order or duplicate keys.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`JSONB` re-parses the text on every query, while `JSON` stores an indexable binary representation$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$`JSON` stores the exact submitted text and re-parses it on every query; `JSONB` stores a parsed binary form and supports indexing$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$`JSON` supports indexing while `JSONB` does not, since `JSONB` is the older, less efficient format$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$They are functionally identical in every respect -- `JSONB` is purely a newer alias for `JSON`$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `JSON` ile `JSONB` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, JSON'ın gönderilen metni tam olarak, byte byte depoladığını, her sorgulandığında yeniden ayrıştırdığını; JSONB'nin ise ayrıştırılmış, daha verimli bir içsel gösterim depoladığını, indexlemeyi desteklediğini (sade JSON'ın desteklemediği), bunun bedeli olarak orijinal anahtar sırasını ya da yinelenen anahtarları korumadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`JSON` indexlemeyi destekler, `JSONB` desteklemez, çünkü `JSONB` daha eski, daha az verimli formattır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her açıdan işlevsel olarak aynıdırlar -- `JSONB` yalnızca `JSON`'ın daha yeni bir takma adıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`JSONB` her sorguda metni yeniden ayrıştırır, `JSON` ise indexlenebilir bir ikili gösterim depolar$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$`JSON`, gönderilen metni tam olarak depolar ve her sorguda yeniden ayrıştırır; `JSONB` ayrıştırılmış bir ikili form depolar ve indexlemeyi destekler$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given a `settings` value of `{"theme": "dark"}`, what do these two comparisons evaluate to?$$,
           $$SELECT settings -> 'theme' = 'dark' AS via_arrow,
       settings ->> 'theme' = 'dark' AS via_double_arrow
FROM user_preference;$$, $$sql$$,
           $$The lesson explains -> extracts a value AS JSONB, while ->> extracts it as text; comparing a JSONB value to a plain text literal with = never matches (different types, even when they "look" the same), so via_arrow is false; ->> gives text, so text = text correctly evaluates to true.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both `via_arrow` and `via_double_arrow` = false$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$`via_arrow` = true; `via_double_arrow` = false$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$`via_arrow` = false; `via_double_arrow` = true$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Both `via_arrow` and `via_double_arrow` = true$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`ayarlar` değeri `{"tema": "karanlik"}` olduğunda, bu iki karşılaştırma neye değerlenir?$$,
           $$SELECT ayarlar -> 'tema' = 'karanlik' AS ok_ile,
       ayarlar ->> 'tema' = 'karanlik' AS cift_ok_ile
FROM kullanici_tercihi;$$, $$sql$$,
           $$Ders, ->'in bir değeri JSONB OLARAK çıkardığını, ->>'nin ise onu text olarak çıkardığını açıklar; bir JSONB değerini = ile düz bir text literal'e karşılaştırmak asla eşleşmez (görünüşte aynı olsalar bile farklı tiplerdir), bu yüzden ok_ile false'tur; ->> text verir, bu yüzden text = text doğru şekilde true'ya değerlenir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`ok_ile` = false; `cift_ok_ile` = true$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$`ok_ile` ve `cift_ok_ile` ikisi de true$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`ok_ile` ve `cift_ok_ile` ikisi de false$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$`ok_ile` = true; `cift_ok_ile` = false$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given these two `user_preference.settings` rows, what does this query return?$$,
           $$-- row 1 settings: {"theme": "dark", "lang": "en"}
-- row 2 settings: {"theme": "light"}

SELECT count(*) FROM user_preference WHERE settings @> '{"theme": "dark"}';$$, $$sql$$,
           $$The lesson explains @> checks whether one JSONB value contains another -- row 1's settings contains {"theme": "dark"} (however much else the object has), row 2's does not (its theme is light), so exactly 1 row matches.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2 -- both rows match, since `@>` ignores the actual key values$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$0 -- `@>` requires an exact, full match of the entire JSONB object, not a partial one$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$An error -- `@>` only works on arrays, not on `JSONB` objects$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$1 -- only row 1's `settings` contains `{"theme": "dark"}`$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu iki `kullanici_tercihi.ayarlar` satırı göz önüne alındığında, bu sorgu ne döndürür?$$,
           $$-- satir 1 ayarlar: {"tema": "karanlik", "dil": "tr"}
-- satir 2 ayarlar: {"tema": "aydinlik"}

SELECT count(*) FROM kullanici_tercihi WHERE ayarlar @> '{"tema": "karanlik"}';$$, $$sql$$,
           $$Ders, @>'nin bir JSONB değerinin başka birini içerip içermediğini kontrol ettiğini açıklar -- satır 1'in ayarları {"tema": "karanlik"}'i içerir (nesnede başka ne olursa olsun), satır 2'ninki içermez (teması aydınlık), bu yüzden tam olarak 1 satır eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir hata -- `@>` yalnızca array'lerde çalışır, JSONB nesnelerinde değil$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$1 -- yalnızca satır 1'in `ayarlar`ı `{"tema": "karanlik"}`'i içerir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$2 -- her iki satır da eşleşir, çünkü `@>` gerçek anahtar değerlerini yok sayar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$0 -- `@>`, kısmi değil, tüm JSONB nesnesinin tam, eksiksiz bir eşleşmesini gerektirir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given a `code_example.tags` value of `ARRAY['records', 'immutability']`, what do `tags[1]` and `'records' = ANY(tags)` evaluate to?$$,
           $$SELECT tags[1] AS first_tag, 'records' = ANY(tags) AS has_records
FROM code_example;$$, $$sql$$,
           $$The lesson explicitly states PostgreSQL arrays are 1-indexed, not 0-indexed -- so tags[1] is the first element, 'records'; ANY(tags) checks whether a single value appears anywhere in the array, and 'records' does appear, so has_records is true.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`first_tag` = `'records'`; `has_records` = `true`$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$`first_tag` = `NULL`, since PostgreSQL arrays are 0-indexed and index 1 is out of bounds for a two-element array$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$`first_tag` = `'immutability'`; `has_records` = `true`$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$`first_tag` = `'records'`; `has_records` = `false`, since `ANY` only checks the first element$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`kod_ornegi.etiketler` değeri `ARRAY['kayitlar', 'degismezlik']` olduğunda, `etiketler[1]` ve `'kayitlar' = ANY(etiketler)` neye değerlenir?$$,
           $$SELECT etiketler[1] AS ilk_etiket, 'kayitlar' = ANY(etiketler) AS kayitlar_var_mi
FROM kod_ornegi;$$, $$sql$$,
           $$Ders, PostgreSQL array'lerinin 0-indeksli değil, 1-indeksli olduğunu açıkça belirtir -- bu yüzden etiketler[1] ilk eleman olan 'kayitlar'dır; ANY(etiketler), tek bir değerin array'in herhangi bir yerinde görünüp görünmediğini kontrol eder, ve 'kayitlar' gerçekten görünür, bu yüzden kayitlar_var_mi true'dur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`ilk_etiket` = `'degismezlik'`; `kayitlar_var_mi` = `true`$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$`ilk_etiket` = `'kayitlar'`; `kayitlar_var_mi` = `false`, çünkü `ANY` yalnızca ilk elemanı kontrol eder$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$`ilk_etiket` = `'kayitlar'`; `kayitlar_var_mi` = `true`$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$`ilk_etiket` = `NULL`, çünkü PostgreSQL array'leri 0-indekslidir ve iki elemanlı bir array için indeks 1 sınırların dışındadır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about PostgreSQL-specific data types, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (JSONB normalizes the input, which is exactly why it does NOT preserve original key order or duplicate keys, unlike JSON; PostgreSQL arrays are explicitly 1-indexed, called out as a real, easy-to-forget difference from Java); the lesson explicitly says a UUID hides sequential information but that isn't the same as "secure" -- access control still happens at the application/authorization layer regardless of key type, and it says storing data as JSONB defers the schema design decision rather than eliminating it entirely.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Storing data as `JSONB` is described in this lesson as eliminating the need to design a schema at all$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`JSONB` does not preserve the original key order or duplicate keys the way plain `JSON` does$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$PostgreSQL arrays are 1-indexed, not 0-indexed$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A `UUID` primary key is described in this lesson as always more secure than `BIGSERIAL`, full stop$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, PostgreSQL'e özgü veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (JSONB'nin girdiyi normalleştirmesi, bunun tam olarak JSON'ın aksine orijinal anahtar sırasını ya da yinelenen anahtarları KORUMAMASININ nedeni olması; PostgreSQL array'lerinin açıkça 1-indeksli olması, Java'dan gerçek, unutulması kolay bir fark olarak adlandırılması); ders, bir UUID'nin sıralı bilgiyi gizlediğini ama bunun 'güvenli' ile aynı olmadığını -- erişim kontrolünün anahtar tipinden bağımsız olarak hâlâ uygulama/yetkilendirme katmanında gerçekleştiğini açıkça belirtir, ve veriyi JSONB olarak depolamanın şema tasarım kararını tamamen ortadan kaldırmak yerine ertelediğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-specific-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL array'leri 0-indeksli değil, 1-indekslidir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu derste bir `UUID` primary key, nokta, her zaman `BIGSERIAL`'den daha güvenli olarak tanımlanır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu derste veriyi `JSONB` olarak depolamak, bir şema tasarlama ihtiyacını tamamen ortadan kaldırmak olarak tanımlanır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`JSONB`, sade `JSON`'ın yaptığı gibi orijinal anahtar sırasını ya da yinelenen anahtarları korumaz$$, TRUE, 3 FROM new_question_tr6;

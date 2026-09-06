-- Promotion batch
-- Topic: postgresql-data-types (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/postgresql-data-types.md and content/tr/postgresql-data-types.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker course batch.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
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
           $$What is `BIGSERIAL`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BIGSERIAL isn't a distinct storage type -- it's BIGINT plus an automatically created sequence that generates the next value, which is exactly what backs GenerationType.IDENTITY on this project's own primary keys.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$BIGINT plus an automatically created sequence that generates the next value -- not a distinct storage type of its own$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A completely separate storage type from BIGINT, with its own distinct binary representation$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A string type specifically used for storing large serialized JSON objects$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A type that can only be used for foreign key columns, never for primary keys$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `BIGSERIAL` nedir?$$,
           NULL, NULL,
           $$Ders, BIGSERIAL'in ayrı bir depolama tipi olmadığını -- BIGINT artı bir sonraki değeri üreten otomatik olarak oluşturulmuş bir sequence olduğunu belirtir, bu tam olarak bu projenin kendi primary key'lerindeki GenerationType.IDENTITY'nin arkasındaki mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Büyük serileştirilmiş JSON nesnelerini depolamak için özellikle kullanılan bir string tipi$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca foreign key sütunları için kullanılabilen, primary key'ler için asla kullanılamayan bir tip$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$BIGINT artı bir sonraki değeri üreten otomatik olarak oluşturulmuş bir sequence -- kendi başına ayrı bir depolama tipi değil$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$BIGINT'ten tamamen ayrı, kendi ayrı ikili gösterimine sahip bir depolama tipi$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Is `TEXT` slower than a length-limited `VARCHAR(n)` in PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states PostgreSQL stores VARCHAR(n), unbounded VARCHAR, and TEXT all the same way internally, applying no performance penalty to TEXT over a length-limited VARCHAR -- unlike some other databases, where TEXT is a slower, separately stored type.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This lesson doesn't address performance differences between VARCHAR and TEXT at all$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$No -- PostgreSQL stores all three the same way internally, with no performance penalty for TEXT$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- TEXT is always significantly slower than VARCHAR(n) in PostgreSQL specifically$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Yes, but only for columns longer than 255 characters$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, PostgreSQL'de `TEXT`, uzunluğu sınırlı bir `VARCHAR(n)`'den daha mı yavaştır?$$,
           NULL, NULL,
           $$Ders, PostgreSQL'in VARCHAR(n)'i, sınırsız VARCHAR'ı ve TEXT'i içsel olarak hepsini aynı şekilde depoladığını, TEXT'e uzunluğu sınırlı bir VARCHAR'a kıyasla hiçbir performans cezası uygulamadığını açıkça belirtir -- TEXT'in daha yavaş, ayrı depolanan bir tip olduğu bazı diğer veritabanlarının aksine.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- TEXT, özellikle PostgreSQL'de her zaman VARCHAR(n)'den önemli ölçüde daha yavaştır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet, ama yalnızca 255 karakterden uzun sütunlar için$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu ders, VARCHAR ile TEXT arasındaki performans farklarını hiç ele almaz$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- PostgreSQL üçünü de içsel olarak aynı şekilde depolar, TEXT için hiçbir performans cezası yoktur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What values can a `BOOLEAN` column store in PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BOOLEAN stores exactly true, false, or NULL -- no 0/1 integer substitute, unlike some databases; 0/1 are integers, a genuinely different type, even though some client libraries accept them as loose input.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`true`, `false`, `0`, `1`, and `NULL`, all treated as five equally valid values$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Only `true` or `false` -- a BOOLEAN column can never hold NULL under any circumstance$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Exactly `true`, `false`, or `NULL` -- no `0`/`1` integer substitute$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Only `0` or `1`, the same as an integer flag in many other database systems$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, PostgreSQL'de bir `BOOLEAN` sütunu hangi değerleri depolayabilir?$$,
           NULL, NULL,
           $$Ders, BOOLEAN'ın tam olarak true, false ya da NULL depoladığını belirtir -- bazı veritabanlarının aksine, 0/1 tamsayı ikamesi yoktur; 0/1 tamsayıdır, bazı istemci kütüphaneleri onları gevşek girdi olarak kabul etse de, gerçekten farklı bir tiptir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak `true`, `false` ya da `NULL` -- `0`/`1` tamsayı ikamesi yoktur$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca `0` ya da `1`, birçok diğer veritabanı sistemindeki bir tamsayı bayrağıyla aynı$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`true`, `false`, `0`, `1` ve `NULL`, hepsi eşit derecede geçerli beş değer olarak ele alınır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca `true` ya da `false` -- bir BOOLEAN sütunu hiçbir koşulda NULL tutamaz$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the key difference between `TIMESTAMP` and `TIMESTAMPTZ`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states plain TIMESTAMP stores a date and time with no time zone attached at all -- just a naive point in time, as written -- while TIMESTAMPTZ stores a point in time that PostgreSQL always normalizes to UTC internally, converting to and from whatever time zone the connecting client is in.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They are functionally identical in every respect, with TIMESTAMPTZ being purely a longer alias for TIMESTAMP$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$TIMESTAMP includes time zone handling, while TIMESTAMPTZ explicitly does not$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$TIMESTAMPTZ can only store dates, never times, unlike TIMESTAMP$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$TIMESTAMP has no time zone attached at all; TIMESTAMPTZ normalizes to UTC internally and converts based on the client's time zone$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `TIMESTAMP` ile `TIMESTAMPTZ` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, sade TIMESTAMP'in hiçbir zaman dilimi bilgisi eklenmemiş bir tarih ve saat depoladığını -- yazıldığı gibi saf bir an olduğunu -- belirtirken, TIMESTAMPTZ'nin PostgreSQL'in içsel olarak her zaman UTC'ye normalleştirdiği, bağlanan client'ın hangi zaman diliminde olduğuna göre dönüştürdüğü bir anı depoladığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$TIMESTAMPTZ, TIMESTAMP'in aksine yalnızca tarihleri depolayabilir, hiçbir zaman saatleri değil$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$TIMESTAMP'e hiç zaman dilimi eklenmez; TIMESTAMPTZ içsel olarak UTC'ye normalleştirir ve client'ın zaman dilimine göre dönüştürür$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Her açıdan işlevsel olarak aynıdırlar, TIMESTAMPTZ yalnızca TIMESTAMP'in daha uzun bir takma adıdır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$TIMESTAMP zaman dilimi işlemeyi içerir, TIMESTAMPTZ ise açıkça içermez$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real `\d topic_translation` output, what SQL type was actually used to declare the `summary` column?$$,
           $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$, $$text$$,
           $$The lesson explains psql reports PostgreSQL's internal type names, which are lowercase and occasionally differ from the SQL keyword used to declare them -- `text` shown here directly is the SQL type TEXT (there's no separate "internal" spelling for TEXT the way there is for `character varying` vs `VARCHAR`), and TEXT is exactly what this project maps `topic_translation.summary` to via an explicit `columnDefinition`.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`TEXT` -- shown as `text` in psql's output, matching this project's explicit `columnDefinition = "TEXT"` on `TopicTranslation.summary`$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$`VARCHAR(255)`, the same type as the `title` column shown just above it$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$`BIGINT`, the same type as the `id` and `topic_id` columns$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$`BOOLEAN`, the same type as the `published` column shown just below it$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek `\d topic_translation` çıktısı göz önüne alındığında, `summary` sütununu tanımlamak için gerçekte hangi SQL tipi kullanılmıştı?$$,
           $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$, $$text$$,
           $$Ders, psql'in PostgreSQL'in içsel tip adlarını raporladığını, bunların küçük harfli olduğunu ve bazen onları tanımlamak için kullanılan SQL anahtar kelimesinden farklı olduğunu açıklar -- burada gösterilen `text`, doğrudan TEXT SQL tipidir (character varying'in VARCHAR'a göre olduğu gibi TEXT için ayrı bir 'içsel' yazım yoktur), ve TEXT tam olarak bu projenin `topic_translation.summary`'yi açık bir `columnDefinition` aracılığıyla eşlediği tiptir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`BIGINT`, `id` ve `topic_id` sütunlarıyla aynı tip$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$`BOOLEAN`, hemen altında gösterilen `published` sütunuyla aynı tip$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$`TEXT` -- psql çıktısında `text` olarak gösterilir, bu projenin `TopicTranslation.summary` üzerindeki açık `columnDefinition = "TEXT"`ine uyar$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$`VARCHAR(255)`, hemen üstünde gösterilen `title` sütunuyla aynı tip$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does this project's `topic_translation.published` column being `BOOLEAN NOT NULL` matter for its Java mapping to a primitive `boolean`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a primitive boolean field in Java can never hold null, so if the column allowed NULL, a NULL value read from the database would have nowhere valid to go -- a NOT NULL column and a non-nullable Java type need to agree, or reading a row can fail in ways that have nothing to do with application logic.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hibernate automatically converts any NULL boolean value into a boxed `Boolean` regardless of the Java field's declared type$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A primitive `boolean` in Java can never hold `null` -- if the column allowed NULL, a NULL value read back would have nowhere valid to go$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It doesn't matter at all -- Java's primitive `boolean` can represent a database NULL without any issue$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`NOT NULL` is purely a performance optimization here with no relationship to how Java maps the value$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin `topic_translation.published` sütununun `BOOLEAN NOT NULL` olması, onun ilkel bir `boolean`a Java eşlemesi için neden önemlidir?$$,
           NULL, NULL,
           $$Ders, Java'da ilkel bir boolean alanının asla null tutamayacağını, bu yüzden sütun NULL'a izin verseydi, veritabanından okunan bir NULL değerinin gidecek geçerli bir yeri olmayacağını belirtir -- bir NOT NULL sütunu ile null olamayan bir Java tipinin uyuşması gerekir, aksi halde bir satırı okumak uygulama mantığıyla hiç ilgisi olmayan şekillerde başarısız olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiç önemli değildir -- Java'nın ilkel `boolean`'ı hiçbir sorun olmadan bir veritabanı NULL'unu temsil edebilir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`NOT NULL` burada Java'nın değeri nasıl eşlediğiyle hiçbir ilişkisi olmayan, tamamen bir performans optimizasyonudur$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hibernate, Java alanının bildirilen tipinden bağımsız olarak, herhangi bir NULL boolean değerini otomatik olarak kutulanmış bir `Boolean`a dönüştürür$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Java'da ilkel bir `boolean` asla `null` tutamaz -- sütun NULL'a izin verseydi, geri okunan bir NULL değerinin gidecek geçerli bir yeri olmazdı$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about PostgreSQL data types, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (INTEGER/BIGINT map to Java's Integer/Long; choosing BIGINT/BIGSERIAL for every primary key even in a small table is called a defensive default, since changing a primary key's type later after foreign keys reference it is far more disruptive than the extra bytes cost); mapping a TIMESTAMPTZ column to LocalDateTime is explicitly named as a common mistake that silently loses time zone information (not a safe, lossless choice), and this lesson's own examples show every SQL-to-Java mapping handled automatically by Hibernate WITHOUT any explicit type-conversion annotation (except the TEXT columnDefinition case) -- not requiring one for every single mapping.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Mapping a `TIMESTAMPTZ` column to `LocalDateTime` is a safe, lossless choice with no downside according to this lesson$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$This project's entities require an explicit type-conversion annotation for every single SQL-to-Java type mapping shown in this lesson, with no exceptions$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Choosing `BIGINT`/`BIGSERIAL` for every primary key, even in a table that will stay small, is described as a defensive default worth keeping$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`INTEGER`/`BIGINT` map to Java's `Integer`/`Long`, matching this project's own `topic.estimated_minutes` (`INTEGER`) and `id` (`BIGSERIAL`) columns$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, PostgreSQL veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (INTEGER/BIGINT'in Java'nın Integer/Long'una eşlenmesi; küçük kalacak bir tabloda bile her primary key için BIGINT/BIGSERIAL seçmenin, foreign key'ler ona referans verdikten sonra bir primary key'in tipini daha sonra değiştirmenin ekstra bayt maliyetinden çok daha yıkıcı olduğu için savunmacı bir varsayılan olarak adlandırılması); bir TIMESTAMPTZ sütununu LocalDateTime'a eşlemenin, zaman dilimi bilgisini sessizce kaybeden yaygın bir hata olarak açıkça adlandırılması (güvenli, kayıpsız bir seçim değil), ve bu dersin kendi örneklerinin, her SQL-Java eşlemesinin (TEXT columnDefinition durumu hariç) hiçbir açık tip dönüştürme anotasyonu OLMADAN Hibernate tarafından otomatik olarak ele alındığını göstermesi -- her tek eşleme için birine ihtiyaç duyulmaması.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-data-types'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Küçük kalacak bir tabloda bile her primary key için `BIGINT`/`BIGSERIAL` seçmek, korunmaya değer savunmacı bir varsayılan olarak tanımlanır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`INTEGER`/`BIGINT`, bu projenin kendi `topic.estimated_minutes` (`INTEGER`) ve `id` (`BIGSERIAL`) sütunlarına uyacak şekilde, Java'nın `Integer`/`Long`'una eşlenir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu derse göre, bir `TIMESTAMPTZ` sütununu `LocalDateTime`a eşlemek, hiçbir dezavantajı olmayan güvenli, kayıpsız bir seçimdir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu projenin entity'leri, bu derste gösterilen her tek SQL-Java tip eşlemesi için, istisnasız açık bir tip dönüştürme anotasyonu gerektirir$$, FALSE, 3 FROM new_question_tr7;

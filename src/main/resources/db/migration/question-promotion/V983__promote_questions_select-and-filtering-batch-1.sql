-- Promotion batch
-- Topic: select-and-filtering (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/select-and-filtering.md and content/tr/select-and-filtering.md -- NOT produced by n8n,
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
           $$What is the full shape of a basic `SELECT` statement, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states the shape is SELECT <columns> FROM <table> WHERE <condition>; -- columns first, then the table, then an optional filter.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`SELECT <columns> FROM <table> WHERE <condition>;`$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$`FROM <table> SELECT <columns> WHERE <condition>;`$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$`WHERE <condition> SELECT <columns> FROM <table>;`$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$`SELECT <table> FROM <columns> WHERE <condition>;`$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, temel bir `SELECT` ifadesinin tam şekli nedir?$$,
           NULL, NULL,
           $$Ders, şeklin `SELECT <sutunlar> FROM <tablo> WHERE <kosul>;` olduğunu belirtir -- önce sütunlar, sonra tablo, sonra opsiyonel bir filtre.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`WHERE <kosul> SELECT <sutunlar> FROM <tablo>;`$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$`SELECT <tablo> FROM <sutunlar> WHERE <kosul>;`$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$`SELECT <sutunlar> FROM <tablo> WHERE <kosul>;`$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$`FROM <tablo> SELECT <sutunlar> WHERE <kosul>;`$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is `SELECT *` worth avoiding in anything meant to last?$$,
           NULL, NULL,
           $$The lesson states SELECT * silently changes shape the moment a migration adds a column, and it fetches columns nothing downstream needed -- naming columns explicitly keeps a query's output shape stable regardless of what the table grows into later.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It runs measurably slower than naming every column explicitly, in every single case$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It silently changes result shape the moment a migration adds a column, and fetches columns nothing downstream needs$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It is syntactically invalid in PostgreSQL and will always produce an error$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It only works correctly on tables that have exactly one column$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `SELECT *`, kalıcı olması amaçlanan herhangi bir şeyde neden kaçınılmaya değerdir?$$,
           NULL, NULL,
           $$Ders, SELECT *'in, bir migration bir sütun eklediği anda sonuç şeklini sessizce değiştirdiğini, ve sonrasında hiçbir şeyin ihtiyaç duymadığı sütunları getirdiğini belirtir -- sütunları açıkça adlandırmak, tablo daha sonra ne olursa olsun bir sorgunun çıktı şeklini sabit tutar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL'de sözdizimsel olarak geçersizdir ve her zaman bir hata üretir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca tam olarak bir sütunu olan tablolarda doğru çalışır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Her tek durumda, her sütunu açıkça adlandırmaktan ölçülebilir şekilde daha yavaş çalışır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir migration bir sütun eklediği anda sonuç şeklini sessizce değiştirir, ve sonrasında hiçbir şeyin ihtiyaç duymadığı sütunları getirir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In `WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (no parentheses), how does this actually get evaluated, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states AND binds tighter than OR, the same precedence arithmetic's * has over + -- so this reads as "difficulty = 'ADVANCED'" OR ("difficulty = 'BEGINNER' AND category_id = 5"), which is almost certainly not what's intended without parentheses making the grouping explicit.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL rejects this statement outright as ambiguous, requiring explicit parentheses to run at all$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Left to right with no precedence rules at all, evaluating each condition strictly in the order written$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$As `difficulty = 'ADVANCED'` OR (`difficulty = 'BEGINNER' AND category_id = 5`) -- `AND` binds tighter than `OR`$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$As (`difficulty = 'ADVANCED'` OR `difficulty = 'BEGINNER'`) AND `category_id = 5` -- `OR` binds tighter than `AND`$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (parantez yok) ifadesi, bu derse göre gerçekte nasıl değerlendirilir?$$,
           NULL, NULL,
           $$Ders, AND'in OR'dan daha sıkı bağlandığını, aritmetikte *'ın +'ya göre olduğu aynı önceliği belirtir -- bu yüzden bu, "difficulty = 'ADVANCED'" OR ("difficulty = 'BEGINNER' AND category_id = 5") olarak okunur, gruplamayı açıkça yapan parantezler olmadan bu neredeyse kesinlikle amaçlanan şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`difficulty = 'ADVANCED'` OR (`difficulty = 'BEGINNER' AND category_id = 5`) olarak -- `AND`, `OR`'dan daha sıkı bağlanır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$(`difficulty = 'ADVANCED'` OR `difficulty = 'BEGINNER'`) AND `category_id = 5` olarak -- `OR`, `AND`'den daha sıkı bağlanır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL bu ifadeyi belirsiz olduğu için doğrudan reddeder, çalışması için açık parantez gerektirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir öncelik kuralı olmadan soldan sağa, her koşulu tam olarak yazıldığı sırada değerlendirerek$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this project's real `topic` slugs `postgresql-and-the-relational-model`, `postgresql-data-types`, and `connecting-to-postgresql`, which ones does `WHERE slug LIKE 'postgresql%'` match?$$,
           $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$, $$sql$$,
           $$The lesson explains the trailing % only matches slugs STARTING WITH postgresql -- connecting-to-postgresql does NOT match (postgresql appears at the end, not the start), while postgresql-and-the-relational-model and postgresql-data-types both do.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$All three slugs, since `postgresql` appears somewhere in each one$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Only `connecting-to-postgresql`, since it ends with `postgresql`$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$None of the three -- `LIKE` requires wildcards on both sides to match anything at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$`postgresql-and-the-relational-model` and `postgresql-data-types` -- `connecting-to-postgresql` doesn't start with `postgresql`$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `topic` slug'ları `postgresql-and-the-relational-model`, `postgresql-data-types` ve `connecting-to-postgresql` göz önüne alındığında, `WHERE slug LIKE 'postgresql%'` hangilerini eşleştirir?$$,
           $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$, $$sql$$,
           $$Ders, sondaki %'nin yalnızca postgresql İLE BAŞLAYAN slug'ları eşleştirdiğini açıklar -- connecting-to-postgresql eşleşmez (postgresql başta değil sonda görünür), postgresql-and-the-relational-model ve postgresql-data-types'ın ikisi de eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Üçünden hiçbiri -- `LIKE`'ın herhangi bir şeyi eşleştirmesi için her iki tarafta da joker karakter gerekir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$`postgresql-and-the-relational-model` ve `postgresql-data-types` -- `connecting-to-postgresql`, `postgresql` ile başlamaz$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Her üç slug da, çünkü `postgresql` her birinde bir yerde görünür$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca `connecting-to-postgresql`, çünkü `postgresql` ile biter$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Is `estimated_minutes BETWEEN 15 AND 20` inclusive or exclusive of its bounds, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BETWEEN checks an inclusive range in one condition -- equivalent to estimated_minutes >= 15 AND estimated_minutes <= 20, both bounds included.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Inclusive of both bounds -- equivalent to `>= 15 AND <= 20`$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Exclusive of both bounds -- equivalent to `> 15 AND < 20`$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Inclusive of the lower bound only -- equivalent to `>= 15 AND < 20`$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Inclusive of the upper bound only -- equivalent to `> 15 AND <= 20`$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `estimated_minutes BETWEEN 15 AND 20`, sınırlarını dahil eder mi yoksa hariç mi tutar?$$,
           NULL, NULL,
           $$Ders, BETWEEN'in tek bir koşulda dahil edici bir aralığı kontrol ettiğini belirtir -- estimated_minutes >= 15 AND estimated_minutes <= 20 ile eşdeğerdir, her iki sınır da dahildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca alt sınırı dahil eder -- `>= 15 AND < 20` ile eşdeğerdir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca üst sınırı dahil eder -- `> 15 AND <= 20` ile eşdeğerdir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Her iki sınırı da dahil eder -- `>= 15 AND <= 20` ile eşdeğerdir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Her iki sınırı da hariç tutar -- `> 15 AND < 20` ile eşdeğerdir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This project's `topic.estimated_minutes` column is nullable, and some rows have it set to `NULL`. What does `SELECT slug FROM topic WHERE estimated_minutes = NULL;` return?$$,
           $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$, $$sql$$,
           $$The lesson explicitly states this returns ZERO rows, always -- not "rows where estimated_minutes is NULL." Comparing anything to NULL with = evaluates to unknown in PostgreSQL's three-valued logic, and WHERE only keeps rows where the condition is true, so an unknown row is silently dropped. IS NULL is the only correct way to test for NULL.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every row in the table, since `NULL` is treated as a wildcard matching any value$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Zero rows, always -- `= NULL` never evaluates to true, even for rows that genuinely have `NULL`$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Every row where `estimated_minutes` is actually `NULL` -- the same result `IS NULL` would give$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A syntax error -- PostgreSQL doesn't allow `NULL` as a literal on the right-hand side of `=`$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu projenin `topic.estimated_minutes` sütunu nullable'dır, ve bazı satırlarda `NULL` olarak ayarlanmıştır. `SELECT slug FROM topic WHERE estimated_minutes = NULL;` ne döndürür?$$,
           $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$, $$sql$$,
           $$Ders, bunun her zaman SIFIR satır döndürdüğünü açıkça belirtir -- 'estimated_minutes'ın NULL olduğu satırlar' değil. PostgreSQL'in üç değerli mantığında herhangi bir şeyi NULL ile = ile karşılaştırmak unknown'a değerlenir, ve WHERE yalnızca koşulun true olduğu satırları tutar, bu yüzden bir unknown satır sessizce düşürülür. NULL için test etmenin tek doğru yolu IS NULL'dır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`estimated_minutes`'ın gerçekten `NULL` olduğu her satır -- `IS NULL`'ın vereceği aynı sonuç$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir sözdizimi hatası -- PostgreSQL, `=`'in sağ tarafında `NULL`'a bir literal olarak izin vermez$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tablodaki her satır, çünkü `NULL` herhangi bir değerle eşleşen bir joker karakter olarak ele alınır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Her zaman sıfır satır -- `= NULL`, gerçekten `NULL` olan satırlar için bile asla true'ya değerlenmez$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about SELECT and filtering, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (!= and <> are both "not equal," with <> being the SQL-standard spelling and != a widely supported alias -- this project has no strong preference between them; ILIKE is PostgreSQL-specific, not part of standard SQL, and is the case-insensitive version of LIKE); the lesson explicitly says LIKE '%text%' and full-text search are NOT the same thing (LIKE has no notion of word boundaries, relevance ranking, or stemming), and IN(...) offers no automatic deduplication or type coercion beyond what a single = comparison would already do.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`LIKE '%text%'` and PostgreSQL's actual full-text search feature are described in this lesson as being the same thing$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`IN (...)` automatically deduplicates its list of values and performs type coercion beyond what a single `=` comparison would do$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`!=` and `<>` both mean "not equal" -- `<>` is the SQL-standard spelling, `!=` a widely supported alias$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`ILIKE` is PostgreSQL-specific (not standard SQL) and is the case-insensitive equivalent of `LIKE`$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, SELECT ve filtreleme hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (!= ve <>'nin ikisinin de 'eşit değil' anlamına gelmesi, <>'nin SQL standardı yazımı, !='in yaygın desteklenen bir takma ad olması -- bu projenin aralarında güçlü bir tercihi yok; ILIKE'ın PostgreSQL'e özgü olması, standart SQL'in parçası olmaması, ve LIKE'ın büyük/küçük harfe duyarsız eşdeğeri olması); ders, LIKE '%text%' ile gerçek full-text search'ün AYNI ŞEY OLMADIĞINI açıkça belirtir (LIKE'ın kelime sınırları, alaka sıralaması ya da kök bulma kavramı yoktur), ve IN (...)'in tek bir = karşılaştırmasının zaten yapacağının ötesinde hiçbir otomatik yineleme giderme ya da tip zorlaması sunmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'select-and-filtering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`!=` ve `<>`'nin ikisi de 'eşit değil' anlamına gelir -- `<>` SQL standardı yazımdır, `!=` yaygın desteklenen bir takma addır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`ILIKE`, PostgreSQL'e özgüdür (standart SQL değildir) ve `LIKE`'ın büyük/küçük harfe duyarsız eşdeğeridir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$`LIKE '%text%'` ile PostgreSQL'in gerçek full-text search özelliği bu derste aynı şey olarak tanımlanır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`IN (...)`, tek bir `=` karşılaştırmasının zaten yapacağının ötesinde, değer listesini otomatik olarak yinelemesizleştirir ve tip zorlaması yapar$$, FALSE, 3 FROM new_question_tr7;

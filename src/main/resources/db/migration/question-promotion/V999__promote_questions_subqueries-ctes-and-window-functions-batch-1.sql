-- Promotion batch
-- Topic: subqueries-ctes-and-window-functions (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/subqueries-ctes-and-window-functions.md and content/tr/subqueries-ctes-and-window-functions.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker/PostgreSQL
-- Foundations batches.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
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
           $$What must a scalar subquery return in order to be used in a comparison like `WHERE estimated_minutes > (SELECT ...)`?$$,
           NULL, NULL,
           $$The lesson defines a scalar subquery as one that must return exactly one row and one column, since it's being compared to a single column value with > the same way a literal number would be.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Exactly one row and one column$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Any number of rows, as long as there's exactly one column$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Exactly one row, but any number of columns$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Nothing -- a subquery can never appear on the right-hand side of a comparison operator$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir skaler subquery'nin, `WHERE ortalama_sure > (SELECT ...)` gibi bir karşılaştırmada kullanılabilmesi için ne döndürmesi gerekir?$$,
           NULL, NULL,
           $$Ders, bir skaler subquery'yi, tam olarak bir satır ve bir sütun döndürmesi gereken olarak tanımlar, çünkü tek bir sütun değeriyle, tıpkı bir literal sayıyla olacağı gibi > ile karşılaştırılır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak bir satır, ama herhangi bir sayıda sütun$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir şey -- bir subquery bir karşılaştırma operatörünün sağ tarafında hiçbir zaman görünemez$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Tam olarak bir satır ve bir sütun$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Tam olarak bir sütun olduğu sürece, herhangi bir sayıda satır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this sample `topic` data and correlated subquery, which `estimated_minutes` values does the query return?$$,
           $$-- topic (category_id, estimated_minutes) sample rows:
-- (1, 10), (1, 20), (1, 30), (2, 5), (2, 15)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$, $$sql$$,
           $$The lesson explains a correlated subquery re-evaluates once per outer row, using t.category_id: category 1's average is (10+20+30)/3=20, so only 30 exceeds it; category 2's average is (5+15)/2=10, so only 15 exceeds it -- the subquery is NOT one platform-wide average, it's recomputed per category.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$None -- correlated subqueries cannot be compared with `>`$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$30 and 15 -- each compared against its own category's average, not a single platform-wide average$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$30 only -- since 30 is the single highest value in the entire table$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$All five values -- since every row is at least as large as some category's average$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu örnek `topic` verisi ve correlated subquery göz önüne alındığında, sorgu hangi `estimated_minutes` değerlerini döndürür?$$,
           $$-- topic (category_id, estimated_minutes) ornek satirlar:
-- (3, 8), (3, 16), (3, 24), (4, 6), (4, 18)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$, $$sql$$,
           $$Ders, correlated bir subquery'nin t.category_id kullanarak dış sorgunun her satırı için bir kez yeniden değerlendirildiğini açıklar: kategori 3'ün ortalaması (8+16+24)/3=16'dır, bu yüzden yalnızca 24 onu aşar; kategori 4'ün ortalaması (6+18)/2=12'dir, bu yüzden yalnızca 18 onu aşar -- subquery tek bir platform geneli ortalama DEĞİLDİR, kategori başına yeniden hesaplanır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca 24 -- çünkü 24, tüm tabloda tek en yüksek değerdir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Beş değerin tümü -- çünkü her satır en azından bir kategorinin ortalaması kadar büyüktür$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbiri -- correlated subquery'ler `>` ile karşılaştırılamaz$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$24 ve 18 -- her biri, tek bir platform geneli ortalama değil, kendi kategorisinin ortalamasıyla karşılaştırılarak$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does a `WITH <name> AS (...)` clause (a CTE) let the rest of the query do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a CTE names a subquery up front, letting the main query reference it like a real table for the rest of that one statement -- it isn't a real table anywhere in the schema, it exists only for the duration of that query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Run the subquery once per row of the outer query, the same way a correlated subquery does$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Replace the need for a `FROM` clause anywhere else in the same statement$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Reference the named subquery like a real table, for the remainder of that same statement$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Permanently create a new table in the database schema that persists after the query finishes$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `WITH <ad> AS (...)` ifadesi (bir CTE), sorgunun geri kalanının ne yapmasına izin verir?$$,
           NULL, NULL,
           $$Ders, bir CTE'nin bir subquery'yi önceden adlandırdığını, ana sorgunun ona o tek ifadenin geri kalanı için gerçek bir tablo gibi başvurmasına izin verdiğini belirtir -- şemada hiçbir yerde gerçek bir tablo değildir, yalnızca o sorgu süresince var olur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Adlandırılmış subquery'ye, aynı ifadenin geri kalanı için gerçek bir tablo gibi başvurmak$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Sorgu bittikten sonra da kalıcı olan, veritabanı şemasında yeni bir tablo kalıcı olarak oluşturmak$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tıpkı bir correlated subquery'nin yaptığı gibi, subquery'yi dış sorgunun her satırı için bir kez çalıştırmak$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Aynı ifadenin başka herhangi bir yerindeki bir `FROM` ifadesine olan ihtiyacı ortadan kaldırmak$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Without `RECURSIVE`, can a CTE in a `WITH` clause reference another CTE defined later in the same clause, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly lists this as a common mistake: CTEs (without RECURSIVE) can only reference the ones defined before them in the same WITH clause, in order -- the same top-to-bottom dependency direction as reading the query itself.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- CTEs in the same `WITH` clause can reference each other in any order, regardless of position$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, but only if both CTEs are explicitly aliased with `AS`$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, but only when the later CTE is a window function rather than a plain aggregate$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- a CTE can only reference ones defined before it in the same `WITH` clause, top to bottom$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `RECURSIVE` olmadan, bir `WITH` ifadesindeki bir CTE, aynı ifadede daha sonra tanımlanan başka bir CTE'ye başvurabilir mi?$$,
           NULL, NULL,
           $$Ders bunu açıkça yaygın bir hata olarak listeler: CTE'ler (RECURSIVE olmadan) yalnızca aynı WITH ifadesinde kendilerinden önce tanımlanmış olanlara başvurabilir, sırayla -- sorgunun kendisini okumakla aynı yukarıdan aşağıya bağımlılık yönü.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca sonraki CTE sade bir aggregate değil bir window function olduğunda$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- bir CTE, aynı `WITH` ifadesinde yalnızca kendisinden önce tanımlanmış olanlara, yukarıdan aşağıya, başvurabilir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- aynı `WITH` ifadesindeki CTE'ler, konumdan bağımsız olarak herhangi bir sırada birbirine başvurabilir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ama yalnızca her iki CTE de açıkça `AS` ile takma adlandırılmışsa$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this sample data and window function query, how many rows are returned, and what is `category_avg` for the row with `estimated_minutes = 10`?$$,
           $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 10), ('b', 1, 20), ('c', 2, 5)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS category_avg
FROM topic;$$, $$sql$$,
           $$The lesson states a window function never collapses rows the way GROUP BY does -- all 3 original rows survive, each carrying its own category's average alongside it. Category 1's average is (10+20)/2=15, so slug 'a' (in category 1) shows category_avg=15, not a platform-wide average.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$3 rows, all preserved; `category_avg` for slug 'a' (category 1) is 15$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$2 rows, one per category; `category_avg` for slug 'a' is 10$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$1 row total, since a window function always collapses to a single summary row$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$3 rows preserved, but `category_avg` for slug 'a' is 11.67, the platform-wide average across all rows$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu örnek veri ve window function sorgusu göz önüne alındığında, kaç satır döndürülür, ve `estimated_minutes = 8` olan satır için `kategori_ort` nedir?$$,
           $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('x', 5, 8), ('y', 5, 12), ('z', 6, 4)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS kategori_ort
FROM topic;$$, $$sql$$,
           $$Ders, bir window function'ın GROUP BY'ın yaptığı gibi satırları asla çökertmediğini belirtir -- orijinal 3 satırın tamamı hayatta kalır, her biri kendi kategorisinin ortalamasını yanında taşır. Kategori 5'in ortalaması (8+12)/2=10'dur, bu yüzden 'x' slug'ı (kategori 5'te) kategori_ort=10 gösterir, platform geneli bir ortalama değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir window function her zaman tek bir özet satırına çöktüğü için toplamda 1 satır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$3 satır korunur, ama 'x' slug'ı için `kategori_ort`, tüm satırlar arasındaki platform geneli ortalama olan 8'dir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$3 satır, tümü korunur; 'x' slug'ı (kategori 5) için `kategori_ort` 10'dur$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Kategori başına bir tane olmak üzere 2 satır; 'x' slug'ı için `kategori_ort` 8'dir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given this sample data with a tie, what `rn` (ROW_NUMBER) and `rk` (RANK) values do rows 'a' and 'b' get, and what `rk` does 'c' get?$$,
           $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 20), ('b', 1, 20), ('c', 1, 10)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rk
FROM topic;$$, $$sql$$,
           $$The lesson explains ROW_NUMBER() never ties, producing a strict 1,2,3 sequence even for equal values (so 'a' and 'b' get rn 1 and 2, in some order), while RANK() gives tied rows the same rank and skips the next number accordingly -- 'a' and 'b' both get rk=1, and 'c' (the only row with 10) gets rk=3, not 2.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`a`/`b` get the same `rk` (1), and `c` also gets `rk` = 1, since `RANK()` ignores the `ORDER BY` value entirely$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`a`/`b` get distinct `rn` values (1 and 2, in some order) but the same `rk` (1); `c` gets `rk` = 3, skipping 2$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$`a`/`b` get the same `rn` (1) and the same `rk` (1); `c` gets `rk` = 2$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`a`/`b` get distinct `rn` and distinct `rk` values, since ties are impossible in PostgreSQL window functions$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir eşitlik içeren bu örnek veri göz önüne alındığında, 'p' ve 'r' satırları hangi `sn` (ROW_NUMBER) ve `sira` (RANK) değerlerini alır, ve 's' hangi `sira` değerini alır?$$,
           $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('p', 2, 30), ('r', 2, 30), ('s', 2, 15)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sira
FROM topic;$$, $$sql$$,
           $$Ders, ROW_NUMBER()'ın hiçbir zaman eşitlik vermediğini, eşit değerler için bile kesin bir 1,2,3 sırası ürettiğini ('p' ve 'r' bir sırayla sn 1 ve 2 alır) açıklarken, RANK()'ın eşit satırlara aynı sırayı verdiğini ve buna göre bir sonraki sayıyı atladığını belirtir -- 'p' ve 'r' ikisi de sira=1 alır, ve 's' (15'e sahip tek satır) sira=3 alır, 2 değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`p`/`r` aynı `sn`'i (1) ve aynı `sira`yı (1) alır; `s`, `sira` = 2 alır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$PostgreSQL window function'larında eşitlik imkansız olduğu için `p`/`r` farklı `sn` ve farklı `sira` değerleri alır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$`p`/`r` aynı `sira`yı (1) alır, ve `s` de `sira` = 1 alır, çünkü `RANK()` `ORDER BY` değerini tamamen yok sayar$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`p`/`r` farklı `sn` değerleri alır (bir sırayla 1 ve 2) ama aynı `sira`yı (1) alır; `s`, 2'yi atlayarak `sira` = 3 alır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about subqueries, CTEs, and window functions, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a window function never reduces row count, unlike GROUP BY -- this is precisely why the two solve different problems even starting from the same aggregate; PARTITION BY divides rows into independent groups for a window function, the window-function equivalent of GROUP BY's grouping); the lesson explicitly says a CTE is NOT always faster than an equivalent subquery (it's primarily a readability/reusability tool), and RANK()/ROW_NUMBER() are only interchangeable when there are no ties, not always.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A CTE is always faster than the logically equivalent nested subquery$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`RANK()` and `ROW_NUMBER()` are always fully interchangeable, regardless of whether the `ORDER BY` column contains ties$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A window function never reduces the number of output rows, unlike `GROUP BY`$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`PARTITION BY` divides rows into independent groups for a window function, analogous to `GROUP BY`'s grouping for aggregation$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, subquery'ler, CTE'ler ve window function'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir window function'ın GROUP BY'ın aksine hiçbir zaman çıktı satır sayısını azaltmaması -- aynı aggregate'ten başlasalar bile ikisinin farklı problemleri çözmesinin tam nedeni budur; PARTITION BY'ın bir window function için satırları bağımsız gruplara bölmesi, GROUP BY'ın aggregation için gruplamasının window function eşdeğeri olması); ders, bir CTE'nin eşdeğer bir subquery'den HER ZAMAN daha hızlı olmadığını açıkça belirtir (öncelikle bir okunabilirlik/yeniden kullanılabilirlik aracıdır), ve RANK()/ROW_NUMBER()'ın yalnızca eşitlik olmadığında birbirinin yerine geçebildiğini, her zaman değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'subqueries-ctes-and-window-functions'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir window function, `GROUP BY`'ın aksine, çıktı satır sayısını asla azaltmaz$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`PARTITION BY`, bir window function için satırları bağımsız gruplara böler, bu da GROUP BY'ın aggregation için gruplamasının window function eşdeğeridir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir CTE, mantıksal olarak eşdeğer, iç içe geçmiş bir subquery'den her zaman daha hızlıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`RANK()` ve `ROW_NUMBER()`, `ORDER BY` sütununda eşitlik olup olmadığından bağımsız olarak, her zaman tamamen birbirinin yerine geçebilir$$, FALSE, 3 FROM new_question_tr7;

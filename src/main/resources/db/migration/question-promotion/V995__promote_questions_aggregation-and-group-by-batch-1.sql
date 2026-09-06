-- Promotion batch
-- Topic: aggregation-and-group-by (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/aggregation-and-group-by.md and content/tr/aggregation-and-group-by.md -- NOT produced by n8n,
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
           $$On this project's nullable `estimated_minutes` column, could `COUNT(*)` and `COUNT(estimated_minutes)` return different numbers, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states COUNT(*) counts rows regardless of any column's value, while COUNT(column) counts only rows where that column is not NULL -- a real distinction on this project's own nullable estimated_minutes column, where the two could genuinely differ if any row had it unset.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- `COUNT(*)` counts every row, while `COUNT(estimated_minutes)` counts only rows where it's not `NULL`$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$No -- `COUNT(*)` and `COUNT(column)` always return identical results for any column, nullable or not$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$No, but only because `estimated_minutes` happens to be a `BIGSERIAL` column, not because of how `COUNT` works$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, but only because `COUNT(*)` is always exactly double `COUNT(column)`$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu projenin nullable `estimated_minutes` sütununda, bu derse göre `COUNT(*)` ile `COUNT(estimated_minutes)` farklı sayılar döndürebilir mi?$$,
           NULL, NULL,
           $$Ders, COUNT(*)'ın herhangi bir sütunun değerinden bağımsız olarak her satırı saydığını, COUNT(sutun)'un ise yalnızca o sütunun NULL olmadığı satırları saydığını belirtir -- bu, herhangi bir satırda ayarlanmamışsa ikisinin gerçekten farklı olabileceği, bu projenin kendi nullable estimated_minutes sütununda gerçek bir ayrımdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır, ama yalnızca `estimated_minutes` bir `BIGSERIAL` sütunu olduğu için, COUNT'un çalışma şeklinden dolayı değil$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet, ama yalnızca `COUNT(*)` her zaman tam olarak `COUNT(sutun)`'un iki katı olduğu için$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- `COUNT(*)` her satırı sayar, `COUNT(estimated_minutes)` ise yalnızca NULL olmadığı satırları sayar$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- `COUNT(*)` ve `COUNT(sutun)`, nullable olsun olmasın herhangi bir sütun için her zaman birebir aynı sonucu döndürür$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`SELECT COUNT(*) FROM topic;` (no `GROUP BY`) returns exactly one row, no matter how many rows `topic` has. Why, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains an aggregate function with no GROUP BY treats the entire result of the FROM/WHERE clauses as a single group -- the whole filtered table is one group, so the aggregate computes one summary value across all of it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The `topic` table is described as having exactly one row for the purposes of this specific example$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$An aggregate function with no `GROUP BY` treats the entire filtered result as a single group, producing one summary row$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL silently applies `LIMIT 1` to every query that uses an aggregate function$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$`COUNT(*)` is a special case that always returns exactly one row regardless of `GROUP BY`, unlike every other aggregate function$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`SELECT COUNT(*) FROM topic;` (GROUP BY yok), `topic`'in kaç satırı olursa olsun tam olarak bir satır döndürür. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, GROUP BY olmayan bir aggregate fonksiyonun, FROM/WHERE ifadelerinin tüm sonucunu tek bir grup olarak ele aldığını açıklar -- tüm filtrelenmiş tablo tek bir gruptur, bu yüzden aggregate onun tamamı üzerinde bir özet değer hesaplar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL, bir aggregate fonksiyon kullanan her sorguya sessizce `LIMIT 1` uygular$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$`COUNT(*)`, diğer her aggregate fonksiyonun aksine, GROUP BY'dan bağımsız olarak her zaman tam olarak bir satır döndüren özel bir durumdur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`topic` tablosunun, bu spesifik örnek amacıyla tam olarak bir satıra sahip olduğu tanımlanır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$GROUP BY olmayan bir aggregate fonksiyon, tüm filtrelenmiş sonucu tek bir grup olarak ele alır, bir özet satır üretir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` get rejected by PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states every column in the SELECT list must be either an aggregate function or one of the columns named in GROUP BY -- for a given difficulty group, PostgreSQL has no single slug to report, since there could be many, so it rejects the query rather than picking one arbitrarily.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`GROUP BY` only supports grouping by exactly one column total, and this query attempts to group by two$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$`COUNT(*)` cannot be combined with any other column in the same `SELECT` list under any circumstances$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$`slug` is neither an aggregate function nor a `GROUP BY` column -- for a given `difficulty` group, there could be many different `slug` values, with no single one to report$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$PostgreSQL doesn't actually reject this query -- it silently picks one arbitrary `slug` per group without any error$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` neden PostgreSQL tarafından reddedilir?$$,
           NULL, NULL,
           $$Ders, SELECT listesindeki her sütunun ya bir aggregate fonksiyon ya da GROUP BY'da adı geçen sütunlardan biri olması gerektiğini belirtir -- belirli bir difficulty grubu için, PostgreSQL'in raporlayacak tek bir slug'ı yoktur, çünkü birçok olabilir, bu yüzden rastgele birini seçmek yerine sorguyu reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`slug`, ne bir aggregate fonksiyon ne de bir `GROUP BY` sütunudur -- belirli bir `difficulty` grubu için birçok farklı `slug` değeri olabilir, raporlanacak tek biri yoktur$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL bu sorguyu aslında reddetmez -- hiçbir hata olmadan grup başına rastgele bir `slug` seçer$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`GROUP BY`, toplamda yalnızca tam olarak bir sütuna göre gruplamayı destekler, ve bu sorgu iki sütuna göre gruplamaya çalışır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$`COUNT(*)`, hiçbir koşulda aynı `SELECT` listesindeki başka herhangi bir sütunla birleştirilemez$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`HAVING` filters groups after aggregation; `WHERE` filters rows before grouping. Why can't `WHERE COUNT(*) >= 5` be used instead of `HAVING COUNT(*) >= 5`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains WHERE runs before aggregation exists at all -- COUNT(*) doesn't exist yet for any single row being filtered, it only exists once the grouping has already happened; this is exactly why HAVING is a separate clause rather than an extra condition tacked onto WHERE.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`WHERE COUNT(*) >= 5` is valid and equivalent -- `HAVING` is purely a stylistic alternative with no functional difference$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$`WHERE` can reference aggregates, but only for `COUNT`, never for `SUM`, `AVG`, `MIN`, or `MAX`$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$`HAVING` is only required when the query has no `GROUP BY` clause at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$`WHERE` runs before aggregation exists -- `COUNT(*)` has no value yet at the point `WHERE` would need to evaluate it$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`HAVING`, gruplamadan sonraki grupları filtreler; `WHERE`, gruplamadan önceki satırları filtreler. Bu derse göre, `HAVING COUNT(*) >= 5` yerine neden `WHERE COUNT(*) >= 5` kullanılamaz?$$,
           NULL, NULL,
           $$Ders, WHERE'in aggregation hiç var olmadan önce çalıştığını açıklar -- filtrelenen herhangi bir tek satır için COUNT(*)'ın henüz bir değeri yoktur, yalnızca gruplama zaten gerçekleştikten sonra var olur; HAVING'in WHERE'e eklenen ekstra bir koşul değil ayrı bir ifade olmasının tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`HAVING`, yalnızca sorgunun hiç `GROUP BY` ifadesi olmadığında gereklidir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$`WHERE`, aggregation var olmadan önce çalışır -- `WHERE`'in onu değerlendirmesi gereken noktada `COUNT(*)`'ın henüz bir değeri yoktur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$`WHERE COUNT(*) >= 5` geçerlidir ve eşdeğerdir -- `HAVING`, hiçbir işlevsel farkı olmayan tamamen biçimsel bir alternatiftir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$`WHERE`, aggregate'lere atıfta bulunabilir, ama yalnızca `COUNT` için, `SUM`, `AVG`, `MIN` ya da `MAX` için asla$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real query, why is `COUNT(t.id)` used instead of `COUNT(*)` to correctly report `0` for a category with no topics?$$,
           $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$, $$sql$$,
           $$The lesson explains that with the LEFT JOIN, a category with no matching topics still produces one output row where every t.* column is NULL -- COUNT(*) would count that all-NULL row as 1, while COUNT(t.id) correctly counts it as 0, since t.id itself is NULL for it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because a category with no matching topics still produces one all-`NULL` row via the `LEFT JOIN`; `COUNT(t.id)` correctly sees `t.id` as `NULL` and doesn't count it, while `COUNT(*)` would count it as 1$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because `COUNT(*)` is invalid syntax when used alongside a `LEFT JOIN`$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$There's no real difference here -- `COUNT(t.id)` and `COUNT(*)` always produce identical results after any `LEFT JOIN`$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Because `COUNT(t.id)` runs faster than `COUNT(*)`, which is the only reason for the choice$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, hiç topic'i olmayan bir kategori için doğru şekilde `0` raporlamak için neden `COUNT(*)` yerine `COUNT(t.id)` kullanılır?$$,
           $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$, $$sql$$,
           $$Ders, LEFT JOIN ile, eşleşen topic'i olmayan bir kategorinin hâlâ her t.* sütununun NULL olduğu bir çıktı satırı ürettiğini açıklar -- COUNT(*) bu tamamen-NULL satırı 1 olarak sayardı, COUNT(t.id) ise t.id'nin kendisi onun için NULL olduğundan bunu doğru şekilde 0 olarak sayar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Burada gerçek bir fark yoktur -- `COUNT(t.id)` ve `COUNT(*)`, herhangi bir `LEFT JOIN`'den sonra her zaman birebir aynı sonuçları üretir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü `COUNT(t.id)`, `COUNT(*)`'tan daha hızlı çalışır, seçimin tek nedeni budur$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü hiç eşleşen topic'i olmayan bir kategori, LEFT JOIN aracılığıyla hâlâ tamamen-NULL bir satır üretir; `COUNT(t.id)`, `t.id`'yi doğru şekilde `NULL` olarak görüp saymaz, `COUNT(*)` ise onu 1 olarak sayardı$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü `COUNT(*)`, bir `LEFT JOIN` ile birlikte kullanıldığında geçersiz sözdizimidir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given this real query, in what order do `WHERE`, `GROUP BY`, and `HAVING` actually run?$$,
           $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$, $$sql$$,
           $$The lesson lays out the exact sequence: WHERE difficulty = 'ADVANCED' runs first, discarding non-ADVANCED rows entirely before any grouping happens; GROUP BY category_id then groups whatever rows survived; HAVING COUNT(*) >= 2 runs last, keeping only the resulting groups whose count (of already-filtered rows) meets the threshold.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$All three run simultaneously, in a single, unordered pass over the table$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`WHERE` first (discarding non-`ADVANCED` rows), then `GROUP BY` (grouping the survivors), then `HAVING` last (filtering the resulting groups)$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$`HAVING` first, then `GROUP BY`, then `WHERE` last$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`GROUP BY` first, then `HAVING`, then `WHERE` last$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, `WHERE`, `GROUP BY` ve `HAVING` gerçekte hangi sırayla çalışır?$$,
           $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$, $$sql$$,
           $$Ders tam sırayı ortaya koyar: WHERE difficulty = 'ADVANCED' önce çalışır, hiçbir gruplama gerçekleşmeden önce ADVANCED olmayan satırları tamamen atar; GROUP BY category_id daha sonra hayatta kalan satırları gruplar; HAVING COUNT(*) >= 2 son çalışır, yalnızca (zaten filtrelenmiş satırların) sayısı eşiği karşılayan ortaya çıkan grupları tutar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önce `HAVING`, sonra `GROUP BY`, sonra son olarak `WHERE`$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Önce `GROUP BY`, sonra `HAVING`, sonra son olarak `WHERE`$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Üçü de tabloda tek, sırasız bir geçişte aynı anda çalışır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Önce `WHERE` (ADVANCED olmayan satırları atarak), sonra `GROUP BY` (hayatta kalanları gruplayarak), sonra son olarak `HAVING` (ortaya çıkan grupları filtreleyerek)$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about aggregation and GROUP BY, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (AVG/SUM/MIN/MAX all ignore NULLs automatically rather than letting one NULL poison the whole calculation; GROUP BY and DISTINCT are explicitly called out as NOT the same job -- DISTINCT only removes exact row duplicates, it can't compute a count/sum/average per group the way GROUP BY genuinely can); the lesson does not say a non-aggregated, non-grouped SELECT column is merely a style warning (PostgreSQL actively rejects the query outright), and multiple aggregate functions ARE explicitly shown appearing together in one query, each computed per group.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Selecting a non-aggregated, non-grouped column alongside `GROUP BY` is merely a style warning in PostgreSQL, not something that causes the query to be rejected$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$This lesson states that only one aggregate function may appear in a single `SELECT` list -- multiple aggregates together in one query are not possible$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`AVG`/`SUM`/`MIN`/`MAX` all ignore `NULL`s automatically, rather than letting a single `NULL` poison the whole calculation$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`GROUP BY` and `DISTINCT` do not do the same job -- `DISTINCT` only removes exact row duplicates, it cannot compute a count, sum, or average per group$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, aggregation ve GROUP BY hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (AVG/SUM/MIN/MAX'ın hepsinin, tek bir NULL'un tüm hesaplamayı zehirlemesine izin vermek yerine NULL'ları otomatik olarak yok sayması; GROUP BY ile DISTINCT'in AYNI İŞİ YAPMADIĞININ açıkça belirtilmesi -- DISTINCT yalnızca birebir aynı satır yinelemelerini kaldırır, GROUP BY'ın gerçekten yapabildiği gibi grup başına sayım/toplam/ortalama hesaplayamaz); ders, aggregate olmayan, gruplanmamış bir SELECT sütununun yalnızca bir stil uyarısı olduğunu söylemez (PostgreSQL sorguyu doğrudan reddeder), ve birden fazla aggregate fonksiyonunun tek bir sorguda birlikte görünmesi, her biri grup başına hesaplanarak açıkça gösterilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'aggregation-and-group-by'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`AVG`/`SUM`/`MIN`/`MAX`'ın hepsi, tek bir `NULL`'un tüm hesaplamayı zehirlemesine izin vermek yerine `NULL`ları otomatik olarak yok sayar$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`GROUP BY` ile `DISTINCT` aynı işi yapmaz -- `DISTINCT` yalnızca birebir aynı satır yinelemelerini kaldırır, `GROUP BY`'ın gerçekten yapabildiği gibi grup başına sayım, toplam ya da ortalama hesaplayamaz$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$GROUP BY yanında aggregate olmayan, gruplanmamış bir sütun seçmek, PostgreSQL'de yalnızca bir stil uyarısıdır, sorgunun reddedilmesine neden olan bir şey değildir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu ders, tek bir SELECT listesinde yalnızca bir aggregate fonksiyonun görünebileceğini belirtir -- tek bir sorguda birden fazla aggregate birlikte mümkün değildir$$, FALSE, 3 FROM new_question_tr7;

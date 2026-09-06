-- Promotion batch
-- Topic: indexes-and-query-performance-with-explain (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/indexes-and-query-performance-with-explain.md and content/tr/indexes-and-query-performance-with-explain.md -- NOT produced by n8n,
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
           $$What does plain `EXPLAIN` (without `ANALYZE`) actually do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states EXPLAIN shows how PostgreSQL intends to execute a query, without actually running it -- it's an estimate (cost, estimated rows, estimated width), not real execution data.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Shows PostgreSQL's intended query plan and cost estimate, without actually running the query$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Runs the query for real and reports the actual elapsed time it took$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Only works on `SELECT` statements -- it cannot be used on `UPDATE` or `DELETE` at all$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Permanently rewrites the query internally to make it faster the next time it runs$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sade `EXPLAIN` (ANALYZE olmadan) gerçekte ne yapar?$$,
           NULL, NULL,
           $$Ders, EXPLAIN'in, sorguyu gerçekten çalıştırmadan, PostgreSQL'in onu nasıl çalıştırmayı amaçladığını gösterdiğini belirtir -- bu bir tahmindir (maliyet, tahmini satır, tahmini genişlik), gerçek çalıştırma verisi değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca `SELECT` ifadelerinde çalışır -- `UPDATE` ya da `DELETE` üzerinde hiç kullanılamaz$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Sorguyu, bir sonraki çalıştırmada daha hızlı olması için içsel olarak kalıcı şekilde yeniden yazar$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Sorguyu gerçekten çalıştırmadan, PostgreSQL'in amaçlanan sorgu planını ve maliyet tahminini gösterir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Sorguyu gerçekten çalıştırır ve aldığı gerçek geçen süreyi raporlar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Is a `Seq Scan` always a sign that something is wrong with a query, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states a Seq Scan isn't inherently bad -- on a small table, scanning every row is often genuinely the cheapest option, cheaper than the overhead of consulting an index at all.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No, but only because indexes are described as not working on foreign key columns$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$No -- on a small table, a `Seq Scan` is often genuinely the cheapest option, cheaper than consulting an index at all$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- a `Seq Scan` always means a necessary index is missing from the table$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Yes, but only when the query uses `SELECT *` specifically instead of naming columns$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `Seq Scan` her zaman bir sorguda bir sorun olduğunun işareti midir?$$,
           NULL, NULL,
           $$Ders, bir Seq Scan'in doğası gereği kötü olmadığını açıkça belirtir -- küçük bir tabloda, her satırı taramak genellikle gerçekten en ucuz seçenektir, bir index'e başvurmanın ek yükünden bile daha ucuzdur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- bir `Seq Scan` her zaman tabloda gerekli bir index'in eksik olduğu anlamına gelir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet, ama yalnızca sorgu sütunları adlandırmak yerine özellikle `SELECT *` kullandığında$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır, ama yalnızca index'lerin foreign key sütunlarında çalışmadığı tanımlandığı için$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- küçük bir tabloda, bir `Seq Scan` genellikle gerçekten en ucuz seçenektir, bir index'e başvurmaktan bile daha ucuzdur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Without specifying `USING <method>`, what index type does `CREATE INDEX` default to, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states CREATE INDEX defaults to a B-tree -- a balanced tree structure keeping values in sorted order, the right default for equality and range conditions (=, <, >, BETWEEN), and by far the most common index type in practice, including every index this project's own schema defines.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A full-text search index, designed for matching words inside long text columns$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A partial index, covering only a subset of the table's rows by default$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A B-tree -- efficient for equality and range conditions, and the most common index type in practice$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A hash index, optimized specifically for equality comparisons only$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `USING <yontem>` belirtilmeden, `CREATE INDEX` varsayılan olarak hangi index tipini kullanır?$$,
           NULL, NULL,
           $$Ders, CREATE INDEX'in varsayılan olarak bir B-tree kullandığını belirtir -- değerleri sıralı düzende tutan dengeli bir ağaç yapısı, eşitlik ve aralık koşulları (=, <, >, BETWEEN) için doğru varsayılan, ve pratikte açık ara en yaygın index tipi, bu projenin kendi şemasının tanımladığı her index dahil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir B-tree -- eşitlik ve aralık koşulları için verimlidir, ve pratikte en yaygın index tipidir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca eşitlik karşılaştırmaları için optimize edilmiş bir hash index$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Uzun metin sütunları içindeki kelimeleri eşleştirmek için tasarlanmış bir full-text search index$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Varsayılan olarak tablonun yalnızca bir alt kümesini kapsayan bir partial index$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this `EXPLAIN` and `EXPLAIN ANALYZE` output for the same query, what does the gap between estimated `rows=10` and actual `rows=3` suggest, according to this lesson?$$,
           $$EXPLAIN SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)
--                    (actual time=0.012..0.018 rows=3 loops=1)$$, $$text$$,
           $$The lesson states comparing EXPLAIN's estimated rows against EXPLAIN ANALYZE's actual rows is one of the most useful things this pair of tools offers -- a big gap between them means PostgreSQL's own statistics about the table are stale or misleading, which can itself cause it to pick a worse plan than it otherwise would.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The query has a syntax error that only `EXPLAIN ANALYZE` is able to detect$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$`EXPLAIN ANALYZE` always overstates the actual row count compared to plain `EXPLAIN`$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$This gap is meaningless -- small differences like this always occur and carry no diagnostic value$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$PostgreSQL's own statistics about the table are likely stale or misleading, which can cause it to pick a worse plan$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aynı sorgu için bu `EXPLAIN` ve `EXPLAIN ANALYZE` çıktısı göz önüne alındığında, tahmini `rows=10` ile gerçek `rows=3` arasındaki fark bu derse göre neyi gösterir?$$,
           $$EXPLAIN SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)
--                    (actual time=0.010..0.015 rows=2 loops=1)$$, $$text$$,
           $$Ders, EXPLAIN'in tahmini satırlarını EXPLAIN ANALYZE'nin gerçek satırlarıyla karşılaştırmanın bu araç çiftinin sunduğu en yararlı şeylerden biri olduğunu belirtir -- aralarındaki büyük bir fark, PostgreSQL'in tablo hakkındaki kendi istatistiklerinin muhtemelen eski ya da yanıltıcı olduğu anlamına gelir, bu da onun daha kötü bir plan seçmesine neden olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu fark anlamsızdır -- bunun gibi küçük farklar her zaman oluşur ve hiçbir teşhis değeri taşımaz$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$PostgreSQL'in tablo hakkındaki kendi istatistikleri muhtemelen eski ya da yanıltıcıdır, bu da daha kötü bir plan seçmesine neden olabilir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorgunun yalnızca `EXPLAIN ANALYZE`'nin tespit edebildiği bir sözdizimi hatası vardır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$`EXPLAIN ANALYZE`, sade `EXPLAIN`'e kıyasla gerçek satır sayısını her zaman olduğundan fazla gösterir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A partial index is created `WHERE language = 'en' AND published = true`. Does a query filtering `WHERE language = 'tr'` benefit from it, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states a partial index is a genuine trade-off: it only helps queries whose own condition matches (or is implied by) the index's WHERE clause -- a query filtering on language = 'tr' gets no benefit from an index defined WHERE language = 'en'.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- a partial index only helps queries whose own condition matches (or is implied by) the index's own `WHERE` clause$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- a partial index still covers every value of the indexed column, regardless of its own `WHERE` clause$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, but only if the query also explicitly filters on `published = true`$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$No, because partial indexes never provide any benefit to any query under any circumstances$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir partial index `WHERE language = 'en' AND published = true` ile oluşturuluyor. Bu derse göre, `WHERE language = 'tr'` filtreleyen bir sorgu bundan fayda sağlar mı?$$,
           NULL, NULL,
           $$Ders, bir partial index'in gerçek bir ödünleşim olduğunu açıkça belirtir: yalnızca kendi koşulu index'in WHERE ifadesiyle eşleşen (ya da onun tarafından ima edilen) sorgulara yardımcı olur -- language = 'tr' üzerinde filtreleyen bir sorgu, WHERE language = 'en' ile tanımlanmış bir index'ten hiçbir fayda görmez.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca sorgu da açıkça `published = true` üzerinde filtreliyorsa$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır, çünkü partial index'ler hiçbir koşulda hiçbir sorguya hiçbir fayda sağlamaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- bir partial index, yalnızca kendi koşulu index'in kendi `WHERE` ifadesiyle eşleşen (ya da onun tarafından ima edilen) sorgulara yardımcı olur$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- bir partial index, kendi `WHERE` ifadesinden bağımsız olarak indexlenmiş sütunun her değerini hâlâ kapsar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$With an index on `sort_order`, which of these two approaches gets measurably more expensive the deeper a page sits in the results, according to this lesson?$$,
           $$-- Approach A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 300;

-- Approach B:
SELECT slug FROM topic WHERE sort_order > 300 ORDER BY sort_order LIMIT 20;$$, $$sql$$,
           $$The lesson explains OFFSET's cost keeps growing the deeper into results a page sits, since PostgreSQL must scan and discard every skipped row -- Approach B's WHERE condition, with an index on sort_order, becomes an Index Scan that jumps directly to the right starting point regardless of depth.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Neither grows in cost -- both are capped by the same `LIMIT 20`, which is described as the only relevant cost factor$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Approach A (`OFFSET`) -- it must scan and discard every skipped row, unlike Approach B's `WHERE`-based keyset pagination$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Approach B (`WHERE sort_order > 300`) -- keyset pagination is described as always more expensive than `OFFSET`$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Both approaches grow in cost identically as the page number increases$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$sort_order üzerinde bir index varken, bu derse göre, bu iki yaklaşımdan hangisi sonuçlarda bir sayfa ne kadar derinde olursa olsun ölçülebilir şekilde daha pahalı hale gelir?$$,
           $$-- Yaklasim A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 500;

-- Yaklasim B:
SELECT slug FROM topic WHERE sort_order > 500 ORDER BY sort_order LIMIT 20;$$, $$sql$$,
           $$Ders, sonuçlarda bir sayfa ne kadar derindeyse OFFSET'in maliyetinin o kadar arttığını açıklar, çünkü PostgreSQL atlanan her satırı taramak ve atmak zorundadır -- sort_order üzerinde bir index varken, Yaklaşım B'nin WHERE koşulu, derinlikten bağımsız olarak doğrudan doğru başlangıç noktasına atlayan bir Index Scan haline gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yaklaşım B (`WHERE sort_order > 500`) -- keyset pagination'ın her zaman OFFSET'ten daha pahalı olduğu tanımlanır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Her iki yaklaşım da sayfa numarası arttıkça birebir aynı şekilde maliyeti artar$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbiri maliyeti artırmaz -- ikisi de aynı `LIMIT 20` ile sınırlıdır, bu da tek ilgili maliyet faktörü olarak tanımlanır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Yaklaşım A (`OFFSET`) -- atlanan her satırı taramak ve atmak zorundadır, Yaklaşım B'nin WHERE tabanlı keyset pagination'ının aksine$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about indexes and query performance, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (every index costs something on every INSERT/UPDATE/DELETE to that table, a cost EXPLAIN on a SELECT never shows; an index built on a raw column doesn't help a query filtering on a transformed version of it, like LOWER(column) -- the index has to be built on the same expression the query actually filters on); the lesson explicitly warns "more indexes are always better" is a misconception (an unused index is pure cost with no benefit, not something the planner ignores for free), and EXPLAIN and EXPLAIN ANALYZE do NOT show the same thing -- one estimates, the other genuinely executes the query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$More indexes are always better, since the query planner simply ignores any index it doesn't need at zero cost$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`EXPLAIN` and `EXPLAIN ANALYZE` always produce identical output, differing only in formatting$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$An index adds overhead to every `INSERT`/`UPDATE`/`DELETE` on the indexed table, not just to reads$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$An index built on a raw column doesn't help a query filtering on a transformed version of that column, like `LOWER(column)`$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, index'ler ve sorgu performansı hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (her index'in o tabloya yapılan her INSERT/UPDATE/DELETE'te bir şeye mal olması, bir SELECT üzerindeki EXPLAIN'in hiç göstermediği bir maliyet; ham bir sütun üzerine inşa edilmiş bir index'in, LOWER(sutun) gibi onun dönüştürülmüş bir versiyonu üzerinde filtreleyen bir sorguya yardımcı olmaması -- index'in sorgunun gerçekte filtrelediği aynı ifade üzerine inşa edilmesi gerekir); ders, 'daha fazla index her zaman daha iyidir'in bir yanılgı olduğunu açıkça uyarır (kullanılmayan bir index, planlayıcının bedavaya yok saydığı bir şey değil, hiçbir faydası olmayan saf bir maliyettir), ve EXPLAIN ile EXPLAIN ANALYZE AYNI ŞEYİ göstermez -- biri tahmin eder, diğeri sorguyu gerçekten çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'indexes-and-query-performance-with-explain'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir index, yalnızca okumalara değil, indexlenmiş tabloya yapılan her `INSERT`/`UPDATE`/`DELETE`'e de ek yük ekler$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Ham bir sütun üzerine inşa edilmiş bir index, `LOWER(sutun)` gibi o sütunun dönüştürülmüş bir versiyonu üzerinde filtreleyen bir sorguya yardımcı olmaz$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Daha fazla index her zaman daha iyidir, çünkü query planner ihtiyaç duymadığı herhangi bir index'i bedavaya yok sayar$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`EXPLAIN` ve `EXPLAIN ANALYZE`, yalnızca biçimlendirmede farklılık göstererek, her zaman birebir aynı çıktıyı üretir$$, FALSE, 3 FROM new_question_tr7;

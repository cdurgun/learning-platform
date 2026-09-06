-- Promotion batch
-- Topic: sorting-limiting-and-pagination (language: en x6, tr x6)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/sorting-limiting-and-pagination.md and content/tr/sorting-limiting-and-pagination.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker course batch.
--
-- Strict 50/50 EN/TR split (6+6) organized as 6 CONCEPT PAIRS -- each EN
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
           $$Without an `ORDER BY`, what does PostgreSQL guarantee about the order of returned rows, according to this lesson?$$,
           NULL, NULL,
           $$The lesson is explicit: without ORDER BY, PostgreSQL makes no promise about row order at all -- not insertion order, not primary key order, genuinely unspecified, and it can change between runs of the identical query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing -- row order is genuinely unspecified and can change between runs of the identical query$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Rows are always returned in the order they were originally inserted$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Rows are always returned in ascending order of their primary key$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Rows are always returned in the order columns were listed in the SELECT clause$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `ORDER BY` olmadan, PostgreSQL döndürülen satırların sırası hakkında ne garanti eder?$$,
           NULL, NULL,
           $$Ders açıktır: ORDER BY olmadan, PostgreSQL satır sırası hakkında hiçbir söz vermez -- ne ekleme sırası, ne primary key sırası, gerçekten belirsizdir, ve birebir aynı sorgunun çalıştırmaları arasında değişebilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Satırlar her zaman primary key'lerinin artan sırasında döndürülür$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Satırlar her zaman SELECT ifadesinde listelendikleri sütun sırasında döndürülür$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiçbir şey -- satır sırası gerçekten belirsizdir ve birebir aynı sorgunun çalıştırmaları arasında değişebilir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Satırlar her zaman orijinal olarak eklendikleri sırada döndürülür$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In `ORDER BY difficulty ASC, sort_order DESC`, how does the second sort key actually apply, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states sorting is applied left to right: rows are grouped by difficulty first, and only WITHIN each identical difficulty value are they then ordered by sort_order -- the second column only breaks ties left by the first, it doesn't independently re-sort the whole result.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`sort_order` is applied first, and `difficulty` only breaks any remaining ties$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$`sort_order` only breaks ties within rows that already share the same `difficulty` value -- it doesn't independently re-sort everything$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Both columns are applied completely independently, each re-sorting the entire result set separately$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only `difficulty` actually has any effect -- listing a second `ORDER BY` column after it is silently ignored$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`ORDER BY difficulty ASC, sort_order DESC` içinde, ikinci sıralama anahtarı bu derse göre gerçekte nasıl uygulanır?$$,
           NULL, NULL,
           $$Ders, sıralamanın soldan sağa uygulandığını belirtir: satırlar önce difficulty'ye göre gruplanır, ve yalnızca aynı difficulty değerini paylaşan satırlar İÇİNDE sort_order'a göre sıralanır -- ikinci sütun yalnızca ilkinin bıraktığı beraberlikleri bozar, tüm sonucu bağımsız olarak yeniden sıralamaz.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her iki sütun da tamamen bağımsız olarak uygulanır, her biri tüm sonuç kümesini ayrı ayrı yeniden sıralar$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca `difficulty`'nin gerçek bir etkisi vardır -- ondan sonra ikinci bir ORDER BY sütunu listelemek sessizce yok sayılır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`sort_order` önce uygulanır, ve `difficulty` yalnızca kalan beraberlikleri bozar$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$`sort_order`, yalnızca zaten aynı `difficulty` değerini paylaşan satırlar içindeki beraberlikleri bozar -- her şeyi bağımsız olarak yeniden sıralamaz$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given a page size of 3, what does this query return, according to this lesson's paging pattern?$$,
           $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$, $$sql$$,
           $$The lesson explains OFFSET for page n (zero-indexed) with page size s is n * s -- OFFSET 3 with LIMIT 3 is page 2 (the second group of 3 rows), skipping the first 3 rows (page 1) and returning the next 3.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Page 4 -- the 10th, 11th, and 12th rows in `sort_order`$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$All rows starting from row 3 to the end of the table, with no upper limit$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Page 2 -- the 4th, 5th, and 6th rows in `sort_order`, skipping the first 3$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Page 1 -- the very first 3 rows in `sort_order`$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$3'lük bir sayfa boyutu göz önüne alındığında, bu dersin sayfalama kalıbına göre bu sorgu ne döndürür?$$,
           $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$, $$sql$$,
           $$Ders, s sayfa boyutuyla n (sıfır indeksli) sayfası için OFFSET'in n * s olduğunu açıklar -- LIMIT 3 ile OFFSET 3, sayfa 2'dir (3'lük satırların ikinci grubu), ilk 3 satırı (sayfa 1) atlar ve sonraki 3'ü döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sayfa 2 -- `sort_order`'daki 4., 5. ve 6. satırlar, ilk 3'ü atlayarak$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Sayfa 1 -- `sort_order`'daki en ilk 3 satır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Sayfa 4 -- `sort_order`'daki 10., 11. ve 12. satırlar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Satır 3'ten tablonun sonuna kadar, üst sınır olmadan tüm satırlar$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$By PostgreSQL's default sort behavior, where do `NULL` values in `estimated_minutes` end up with this query?$$,
           $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$, $$sql$$,
           $$The lesson states PostgreSQL sorts NULL values as larger than any real value by default, which means a plain ORDER BY in ascending order places every NULL at the END -- the opposite would be true in descending order, where NULLs would sort first.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$At the beginning of the result -- `NULL` always sorts first regardless of `ASC` or `DESC`$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$`NULL` rows are silently excluded from the result entirely when sorting ascending$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$PostgreSQL raises an error when trying to `ORDER BY` a nullable column without `NULLS LAST` specified explicitly$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$At the end of the result -- PostgreSQL sorts `NULL` as larger than any real value by default in ascending order$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$PostgreSQL'in varsayılan sıralama davranışına göre, bu sorguda `estimated_minutes`'taki `NULL` değerleri nerede sona erer?$$,
           $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$, $$sql$$,
           $$Ders, PostgreSQL'in varsayılan olarak NULL değerlerini herhangi bir gerçek değerden daha büyük sıraladığını belirtir, bu da sade bir ORDER BY'ın artan sırada her NULL'u SONA yerleştirdiği anlamına gelir -- azalan sırada tam tersi doğru olurdu, NULL'lar önce sıralanırdı.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL, açıkça NULLS LAST belirtilmeden nullable bir sütunu ORDER BY yapmaya çalışırken bir hata verir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Sonuçun sonunda -- PostgreSQL, artan sırada NULL'u varsayılan olarak herhangi bir gerçek değerden daha büyük sıralar$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Sonuçun başında -- NULL, ASC ya da DESC'ten bağımsız olarak her zaman önce sıralanır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Artan sırada sıralarken NULL satırları sonuçtan tamamen sessizce hariç tutulur$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "The Cost of OFFSET on Large Tables," does `OFFSET 100000` skip those rows for free?$$,
           NULL, NULL,
           $$The lesson explicitly states OFFSET doesn't skip rows for free -- PostgreSQL still has to scan and discard every one of them before it can start returning the rows actually wanted, so OFFSET 100000 does meaningfully more work than OFFSET 10, even though both return the same number of rows.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- PostgreSQL must scan and discard every skipped row first, so a larger offset does meaningfully more work$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- PostgreSQL has an internal index that lets it jump directly to any offset with zero extra cost$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, but only for tables smaller than a certain fixed row-count threshold$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$This lesson doesn't address whether OFFSET has any performance cost at all$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'The Cost of OFFSET on Large Tables'a göre, `OFFSET 100000` o satırları bedavaya mı atlar?$$,
           NULL, NULL,
           $$Ders, OFFSET'in satırları bedavaya atlamadığını açıkça belirtir -- PostgreSQL, gerçekten istenen satırları döndürmeye başlamadan önce hâlâ her birini taramak ve atmak zorundadır, bu yüzden OFFSET 100000, ikisi de aynı sayıda satır döndürse bile, OFFSET 10'dan anlamlı derecede daha fazla iş yapar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca belirli sabit bir satır-sayısı eşiğinden küçük tablolar için$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu ders, OFFSET'in herhangi bir performans maliyeti olup olmadığını hiç ele almaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- PostgreSQL önce atlanan her satırı taramak ve atmak zorundadır, bu yüzden daha büyük bir offset anlamlı derecede daha fazla iş yapar$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- PostgreSQL'in, sıfır ekstra maliyetle herhangi bir offset'e doğrudan atlamasını sağlayan içsel bir indexi vardır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about pagination, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Pageable was never a separate mechanism from LIMIT/OFFSET -- PageRequest.of(page, size, sort) directly computes LIMIT size OFFSET page*size plus an ORDER BY, and Spring Data JPA also runs a second SELECT count(*) behind the scenes for Page<T>'s totals; LIMIT/OFFSET only make sense paired with an explicit ORDER BY, since without one, "the first N" and "the next N" aren't well-defined concepts); the lesson explicitly calls a plain LIMIT without ORDER BY non-deterministic across repeated runs (not reliably "the first N" rows), and it names keyset pagination -- not something covered in depth in this lesson -- as the faster alternative covered properly later, in "Indexes and Query Performance with EXPLAIN."$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This lesson covers keyset pagination in full depth as the primary pagination technique, rather than `OFFSET`-based paging$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`Pageable`'s `PageRequest.of(page, size, sort)` directly computes `LIMIT size OFFSET page * size` plus an `ORDER BY` -- not a separate mechanism from raw SQL pagination$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$`LIMIT`/`OFFSET` only make sense paired with an explicit `ORDER BY`, since without one, row order (and therefore "the first N") is undefined$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A plain `LIMIT` without `ORDER BY` is described as reliably deterministic, always returning the same "first N" rows across repeated runs$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, pagination hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Pageable'ın LIMIT/OFFSET'ten hiçbir zaman ayrı bir mekanizma olmaması -- PageRequest.of(page, size, sort)'un doğrudan LIMIT size OFFSET page*size artı bir ORDER BY hesaplaması, ve Spring Data JPA'nın Page<T>'nin toplamları için arka planda ikinci bir SELECT count(*) de çalıştırması; LIMIT/OFFSET'in yalnızca açık bir ORDER BY ile eşleştirildiğinde anlamlı olması, çünkü biri olmadan 'ilk N' ve 'sonraki N' iyi tanımlanmış kavramlar değildir); ders, ORDER BY olmadan sade bir LIMIT'i tekrarlanan çalıştırmalar arasında deterministik olmayan olarak açıkça adlandırır (güvenilir şekilde 'ilk N' satır değil), ve keyset pagination'ı -- bu derste derinlemesine ele alınmayan bir şey -- daha sonra 'Indexes and Query Performance with EXPLAIN'de düzgünce ele alınan daha hızlı alternatif olarak adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sorting-limiting-and-pagination'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`LIMIT`/`OFFSET` yalnızca açık bir `ORDER BY` ile eşleştirildiğinde anlamlıdır, çünkü biri olmadan satır sırası (ve dolayısıyla 'ilk N') tanımsızdır$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$ORDER BY olmadan sade bir `LIMIT`, tekrarlanan çalıştırmalar arasında güvenilir şekilde deterministik olarak, her zaman aynı 'ilk N' satırları döndürerek tanımlanır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu ders, `OFFSET` tabanlı sayfalama yerine, birincil pagination tekniği olarak keyset pagination'ı tam derinlikte ele alır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`Pageable`'ın `PageRequest.of(page, size, sort)`'u doğrudan `LIMIT size OFFSET page * size` artı bir `ORDER BY` hesaplar -- ham SQL pagination'dan ayrı bir mekanizma değildir$$, TRUE, 3 FROM new_question_tr6;

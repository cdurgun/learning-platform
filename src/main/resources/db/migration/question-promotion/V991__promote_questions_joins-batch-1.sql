-- Promotion batch
-- Topic: joins (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/joins.md and content/tr/joins.md -- NOT produced by n8n,
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
           $$Why does getting a `category`'s name alongside its `course`'s name require a JOIN, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains a category row only stores a course_id -- it doesn't repeat the course's name; getting both names in one result therefore means combining two tables, row by row, wherever their foreign key relationship connects them.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A `category` row only stores `course_id`, not the course's name -- combining both requires matching rows across the two tables$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$PostgreSQL requires a `JOIN` any time more than one column is selected, even from a single table$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because `category` and `course` are stored on physically separate database servers$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because `category.name` and `course.name` have genuinely different data types that need converting$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `category`'nin adını `course`'unun adıyla birlikte almak neden bir JOIN gerektirir?$$,
           NULL, NULL,
           $$Ders, bir category satırının yalnızca course_id'yi depoladığını, kursun adını tekrarlamadığını açıklar; her iki adı da tek bir sonuçta almak, bu yüzden foreign key ilişkilerinin bağlandığı her yerde iki tabloyu satır satır birleştirmek anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü `category` ve `course` fiziksel olarak ayrı veritabanı sunucularında depolanır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü `category.name` ve `course.name`'in dönüştürülmesi gereken gerçekten farklı veri tipleri vardır$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir `category` satırı yalnızca `course_id`'yi depolar, kursun adını değil -- her ikisini de birleştirmek iki tablo arasında satırları eşleştirmeyi gerektirir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$PostgreSQL, tek bir tablodan bile olsa, birden fazla sütun seçildiğinde her zaman bir `JOIN` gerektirir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What rows does an `INNER JOIN` return, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states INNER JOIN (often just written JOIN, with INNER implied) returns only rows that have a match on both sides -- a category row with no matching course simply wouldn't appear.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only rows that have NO match on either side of the join$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Only rows that have a match on both sides of the join$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Every row from the left-hand table, regardless of whether a match exists on the right$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Every row from both tables, combined, whether or not a match exists on either side$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `INNER JOIN` hangi satırları döndürür?$$,
           NULL, NULL,
           $$Ders, INNER JOIN'in (genellikle sadece JOIN olarak yazılır, INNER ima edilir) yalnızca her iki tarafta da eşleşmesi olan satırları döndürdüğünü belirtir -- eşleşen bir course'u olmayan bir category satırı basitçe görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sağ tarafta bir eşleşme olup olmadığından bağımsız olarak, sol tablonun her satırı$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her iki tarafta da bir eşleşme olsun ya da olmasın, her iki tablonun her satırı, birleştirilmiş olarak$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca join'in her iki tarafında da HİÇBİR eşleşmesi olmayan satırlar$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca join'in her iki tarafında da eşleşmesi olan satırlar$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real three-table chain, how many rows does this query return against this project's own data?$$,
           $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$, $$sql$$,
           $$The lesson states this returns exactly one row: 'joins', 'PostgreSQL Foundations', 'PostgreSQL' -- since t.slug = 'joins' matches exactly one topic row, and each INNER JOIN step matches it to exactly one category and one course, per this project's real content hierarchy.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ten rows, one for every topic in the `postgresql-foundations` category$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Exactly one row, but with `category_name` and `course_name` both `NULL`$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Exactly one row: `joins`, `PostgreSQL Foundations`, `PostgreSQL`$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Zero rows, since three-table `INNER JOIN` chains are not valid SQL syntax$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek üç tablolu zincir göz önüne alındığında, bu sorgu bu projenin kendi verisine karşı kaç satır döndürür?$$,
           $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$, $$sql$$,
           $$Ders, bunun tam olarak bir satır döndürdüğünü belirtir: `joins`, `PostgreSQL Foundations`, `PostgreSQL` -- çünkü t.slug = 'joins' tam olarak bir topic satırıyla eşleşir, ve her INNER JOIN adımı onu bu projenin gerçek içerik hiyerarşisine göre tam olarak bir category ve bir course ile eşleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak bir satır: `joins`, `PostgreSQL Foundations`, `PostgreSQL`$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Sıfır satır, çünkü üç tablolu `INNER JOIN` zincirleri geçerli SQL sözdizimi değildir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`postgresql-foundations` kategorisindeki her topic için bir tane olmak üzere on satır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Tam olarak bir satır, ama `category_name` ve `course_name` ikisi de `NULL` ile$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "From JPQL join fetch to a Real SQL JOIN," what does this project's `TopicRepository.findBySlugWithCategoryAndCourse`'s JPQL `join fetch` compile to?$$,
           NULL, NULL,
           $$The lesson states join fetch isn't a different kind of join from SQL's JOIN -- it's Hibernate choosing to express a Java-level "also load this related entity" instruction as a real SQL JOIN, compiling to essentially the same three-table INNER JOIN chain written by hand.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A completely different mechanism from a SQL `JOIN`, using a proprietary Hibernate-only query protocol$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Two or more separate, follow-up `SELECT` queries, one per related entity, run one after another$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A `LEFT JOIN` specifically, regardless of what the JPQL itself says$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Essentially the same three-table `INNER JOIN` chain -- `join fetch` is the same relational operation, expressed from the JPQL side$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'From JPQL join fetch to a Real SQL JOIN'a göre, bu projenin `TopicRepository.findBySlugWithCategoryAndCourse`'unun JPQL `join fetch`'i neye derlenir?$$,
           NULL, NULL,
           $$Ders, join fetch'in SQL'in JOIN'inden farklı bir join türü olmadığını -- Hibernate'in, Java seviyesindeki 'bu ilişkili entity'yi de yükle' talimatını gerçek bir SQL JOIN olarak ifade etmeyi seçmesi olduğunu, elle yazılan aynı üç tablolu INNER JOIN zincirine esasen derlendiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JPQL'in kendisinin ne söylediğinden bağımsız olarak, özellikle bir `LEFT JOIN`$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Esasen aynı üç tablolu `INNER JOIN` zinciri -- `join fetch`, JPQL tarafından ifade edilen aynı ilişkisel işlemdir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Özel bir Hibernate-only sorgu protokolü kullanan, bir SQL `JOIN`'den tamamen farklı bir mekanizma$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$İlişkili entity başına bir tane olmak üzere, birbiri ardına çalışan iki veya daha fazla ayrı, takip eden `SELECT` sorgusu$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real query, what does `tt.title` show for a `topic` row that has no English `topic_translation` row at all?$$,
           $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$, $$sql$$,
           $$The lesson explains LEFT JOIN keeps every row from the left-hand table (topic) whether or not it finds a match on the right -- when there's no match, the right side's columns simply come back as NULL, rather than that topic row silently disappearing the way an INNER JOIN would make it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`NULL` -- the `topic` row still appears, but `tt.title` comes back `NULL` since there's no matching row$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The `topic` row disappears from the result entirely, the same as an `INNER JOIN` would produce$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$An empty string `''`, rather than `NULL`, since `LEFT JOIN` never produces `NULL` values$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The query fails with an error, since `LEFT JOIN` requires a match on every row$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, hiç İngilizce `topic_translation` satırı olmayan bir `topic` satırı için `tt.title` ne gösterir?$$,
           $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$, $$sql$$,
           $$Ders, LEFT JOIN'in sağda bir eşleşme bulup bulmadığından bağımsız olarak sol taraftaki tablonun (topic) her satırını tuttuğunu açıklar -- eşleşme olmadığında, sağ tarafın sütunları basitçe NULL olarak geri gelir, o topic satırının bir INNER JOIN'in yapacağı gibi sessizce kaybolması yerine.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`LEFT JOIN` hiçbir zaman `NULL` değeri üretmediği için, `NULL` yerine boş bir dizge `''`$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$`LEFT JOIN`, her satırda bir eşleşme gerektirdiği için sorgu bir hatayla başarısız olur$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$`NULL` -- `topic` satırı hâlâ görünür, ama eşleşen bir satır olmadığı için `tt.title` `NULL` olarak geri gelir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$`topic` satırı, bir `INNER JOIN`'in üreteceğiyle aynı şekilde sonuçtan tamamen kaybolur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A developer writes `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true`, intending to find topics with no published English translation. According to this lesson's "Common Mistakes," what actually happens?$$,
           NULL, NULL,
           $$The lesson explicitly warns that filtering an outer-joined table's column in WHERE instead of ON silently turns a LEFT JOIN back into the equivalent of an INNER JOIN -- WHERE runs after the join and drops any row where the condition isn't true, including exactly the NULL rows the LEFT JOIN was meant to preserve.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL automatically rewrites the `WHERE` clause into the `ON` clause to preserve the intended `LEFT JOIN` behavior$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`WHERE en.published = true` silently turns this back into the equivalent of an `INNER JOIN`, dropping exactly the unmatched rows meant to be found$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$This works exactly as intended -- `WHERE` and `ON` are fully interchangeable for any condition on an outer-joined table$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The query fails outright with a syntax error, since `WHERE` cannot reference a `LEFT JOIN`ed table's columns$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, yayınlanmış İngilizce çevirisi olmayan topic'leri bulmayı amaçlayarak `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true` yazıyor. Bu dersin 'Common Mistakes' bölümüne göre, gerçekte ne olur?$$,
           NULL, NULL,
           $$Ders, dış birleştirilmiş bir tablonun sütununu ON yerine WHERE'de filtrelemenin, bir LEFT JOIN'i sessizce bir INNER JOIN'in eşdeğerine geri döndürdüğünü açıkça uyarır -- WHERE join'den sonra çalışır ve koşulun true olmadığı her satırı düşürür, LEFT JOIN'in korumayı amaçladığı tam olarak NULL satırlar dahil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu tam olarak amaçlandığı gibi çalışır -- dış birleştirilmiş bir tablo üzerindeki herhangi bir koşul için `WHERE` ve `ON` tamamen birbirinin yerine geçebilir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`WHERE`, bir `LEFT JOIN` yapılmış bir tablonun sütunlarına atıfta bulunamayacağı için sorgu doğrudan bir sözdizimi hatasıyla başarısız olur$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$PostgreSQL, amaçlanan `LEFT JOIN` davranışını korumak için `WHERE` ifadesini otomatik olarak `ON` ifadesine yeniden yazar$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`WHERE en.published = true`, bunu sessizce bir `INNER JOIN`'in eşdeğerine geri döndürür, bulunması amaçlanan tam olarak eşleşmeyen satırları düşürür$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about `RIGHT JOIN` and `FULL JOIN`, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (A LEFT JOIN B and B RIGHT JOIN A return the same rows, just with columns in a different order -- which is why RIGHT JOIN is rarely needed in practice; FULL JOIN keeps every row from both sides regardless of match, filling in NULL on whichever side has no counterpart); the lesson explicitly says this project's own code never uses RIGHT JOIN, and it says LEFT JOIN is not inherently slower than INNER JOIN -- any performance difference comes down to indexes and row counts, not the join type itself.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This project's own real code is described in this lesson as using `RIGHT JOIN` extensively throughout its queries$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`LEFT JOIN` is described in this lesson as inherently, always slower than `INNER JOIN`, regardless of indexes or row counts$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`A LEFT JOIN B` and `B RIGHT JOIN A` return the same rows, just with columns in a different order$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`FULL JOIN` keeps every row from both sides regardless of match, filling in `NULL` on whichever side has no counterpart$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, `RIGHT JOIN` ve `FULL JOIN` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (A LEFT JOIN B ile B RIGHT JOIN A'nın aynı satırları, yalnızca farklı sütun sırasıyla döndürmesi -- bu, RIGHT JOIN'in pratikte nadiren gerekli olmasının nedenidir; FULL JOIN'in eşleşme olsun olmasın her iki taraftan da her satırı tutması, eşleniği olmayan tarafa NULL doldurması); ders, bu projenin kendi kodunun RIGHT JOIN'i hiç kullanmadığını açıkça belirtir, ve LEFT JOIN'in INNER JOIN'den doğası gereği daha yavaş olmadığını -- herhangi bir performans farkının indeksler ve satır sayılarına bağlı olduğunu, join türünün kendisine değil, belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'joins'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`A LEFT JOIN B` ile `B RIGHT JOIN A`, aynı satırları, yalnızca farklı bir sütun sırasıyla döndürür$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`FULL JOIN`, eşleşme olsun olmasın her iki taraftan da her satırı tutar, eşleniği olmayan tarafa `NULL` doldurur$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu projenin kendi gerçek kodu, bu derste sorgularında `RIGHT JOIN`'i yaygın olarak kullandığı şeklinde tanımlanır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`LEFT JOIN`, bu derste, indekslerden ya da satır sayılarından bağımsız olarak, doğası gereği her zaman `INNER JOIN`'den daha yavaş olarak tanımlanır$$, FALSE, 3 FROM new_question_tr7;

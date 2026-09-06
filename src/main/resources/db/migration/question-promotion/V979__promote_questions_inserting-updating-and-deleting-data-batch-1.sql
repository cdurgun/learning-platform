-- Promotion batch
-- Topic: inserting-updating-and-deleting-data (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/inserting-updating-and-deleting-data.md and content/tr/inserting-updating-and-deleting-data.md -- NOT produced by n8n,
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
           $$In `INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);`, what determines which value is assigned to which column?$$,
           NULL, NULL,
           $$The lesson states column order in the parentheses must match the value order that follows -- the first named column gets the first value, and so on; any column left out entirely (like id) takes its default.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Position -- the order of columns in the parentheses must match the order of values that follows$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Alphabetical order of the column names, regardless of how they're listed in the statement$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The order columns were originally defined in the table's `CREATE TABLE` statement, ignoring the INSERT's own column list$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$PostgreSQL matches values to columns automatically by data type, not by position$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);` içinde, hangi değerin hangi sütuna atanacağını ne belirler?$$,
           NULL, NULL,
           $$Ders, parantezlerdeki sütun sırasının, onu izleyen değer sırasıyla eşleşmesi gerektiğini belirtir -- ilk adlandırılan sütun ilk değeri alır, ve böyle devam eder; tamamen atlanan herhangi bir sütun (id gibi) varsayılanını alır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sütunların, INSERT'in kendi sütun listesini yok sayarak, tablonun `CREATE TABLE` ifadesinde orijinal olarak tanımlandığı sıra$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$PostgreSQL, değerleri sütunlara konuma göre değil, otomatik olarak veri tipine göre eşler$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Konum -- parantezlerdeki sütunların sırası, onu izleyen değerlerin sırasıyla eşleşmelidir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İfadede nasıl listelendiklerinden bağımsız olarak, sütun adlarının alfabetik sırası$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does `UPDATE`/`DELETE` need a `WHERE` clause, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states there's no such concept as affecting only "the current row" in SQL -- omitting WHERE targets every row in the table, immediately, with no confirmation prompt; a WHERE clause is what narrows which specific rows are affected.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`WHERE` is required only for `DELETE`, not for `UPDATE`$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Without it, every row in the table is affected immediately, with no confirmation prompt$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It's optional and purely stylistic -- omitting it only affects a single, unspecified "current" row$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL requires `WHERE` syntactically -- a statement without one simply fails to parse$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `UPDATE`/`DELETE` neden bir `WHERE` ifadesine ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, SQL'de yalnızca 'mevcut satırı' etkilemek diye bir kavram olmadığını belirtir -- WHERE'i atlamak, hiçbir onay istemi olmadan, tablodaki her satırı hemen hedefler; bir WHERE ifadesi, hangi spesifik satırların etkilendiğini daraltan şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Opsiyoneldir ve tamamen biçimseldir -- atlamak yalnızca tek, belirsiz bir 'mevcut' satırı etkiler$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$PostgreSQL sözdizimsel olarak `WHERE` gerektirir -- onsuz bir ifade basitçe ayrıştırılamaz$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`WHERE` yalnızca `DELETE` için gereklidir, `UPDATE` için değil$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu olmadan, hiçbir onay istemi olmadan tablodaki her satır hemen etkilenir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real migration pattern, what happens to the `INSERT` if no `category` row has `slug = 'postgresql-foundations'`?$$,
           $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'connecting-to-postgresql', 'BEGINNER', 15, 2
FROM category
WHERE slug = 'postgresql-foundations';$$, $$sql$$,
           $$The lesson explicitly warns that INSERT ... SELECT's SELECT can return zero rows (a slug that doesn't match anything) -- the INSERT then silently inserts zero rows too, with no error, a much quieter failure than a typo in a VALUES literal would produce.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The `INSERT` inserts one row anyway, with `category_id` set to `NULL`$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$PostgreSQL automatically creates a new `category` row with that slug before completing the `INSERT`$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The `INSERT` silently inserts zero rows, with no error at all$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The `INSERT` fails with a specific "no matching category" error$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu gerçek migration kalıbı göz önüne alındığında, `slug = 'postgresql-foundations'` olan hiçbir `category` satırı yoksa `INSERT`'e ne olur?$$,
           $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'aggregation-and-group-by', 'INTERMEDIATE', 20, 10
FROM category
WHERE slug = 'olmayan-kategori';$$, $$sql$$,
           $$Ders, INSERT ... SELECT'in SELECT'inin sıfır satır döndürebileceğini (hiçbir şeyle eşleşmeyen bir slug) açıkça uyarır -- INSERT o zaman hiçbir hata olmadan sessizce sıfır satır ekler, bu bir VALUES literalindeki bir yazım hatasından çok daha sessiz bir başarısızlıktır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`INSERT`, hiçbir hata olmadan sessizce sıfır satır ekler$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$`INSERT`, spesifik bir 'eşleşen kategori yok' hatasıyla başarısız olur$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`INSERT` yine de bir satır ekler, `category_id`'yi `NULL` olarak ayarlar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL, `INSERT`'i tamamlamadan önce o slug'a sahip yeni bir `category` satırı otomatik olarak oluşturur$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this statement, does PostgreSQL need a separate, follow-up `SELECT` to obtain the new row's generated `id`?$$,
           $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$, $$sql$$,
           $$The lesson explicitly states RETURNING doesn't run a second query -- it's the same single statement, returning data it already computed while performing the write, immediately handing back the id PostgreSQL just generated via BIGSERIAL, without a round trip to query for it separately.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- `RETURNING` triggers PostgreSQL to automatically run a hidden `SELECT` immediately afterward$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Yes -- `RETURNING` only works if a separate `SELECT id FROM course WHERE ...` is issued right after it$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$`RETURNING id` is invalid syntax on an `INSERT` statement -- it only works on `UPDATE`/`DELETE`$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- `RETURNING id` hands back the generated id as part of the same single statement, with no extra round trip$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ifade göz önüne alındığında, PostgreSQL'in yeni satırın üretilen `id`'sini elde etmek için ayrı, takip eden bir `SELECT`'e ihtiyacı var mı?$$,
           $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$, $$sql$$,
           $$Ders, RETURNING'in ikinci bir sorgu çalıştırmadığını açıkça belirtir -- aynı tek ifadedir, yazmayı gerçekleştirirken zaten hesapladığı veriyi döndürür, PostgreSQL'in BIGSERIAL aracılığıyla az önce ürettiği id'yi, onu ayrı sorgulamak için bir gidiş-dönüş olmadan hemen geri verir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`RETURNING id`, bir `INSERT` ifadesinde geçersiz sözdizimidir -- yalnızca `UPDATE`/`DELETE` üzerinde çalışır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- `RETURNING id`, üretilen id'yi aynı tek ifadenin parçası olarak, ekstra bir gidiş-dönüş olmadan geri verir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- `RETURNING`, PostgreSQL'in hemen ardından otomatik olarak gizli bir `SELECT` çalıştırmasını tetikler$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- `RETURNING`, yalnızca hemen ardından ayrı bir `SELECT id FROM course WHERE ...` verilirse çalışır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why doesn't this project's own Flyway migrations ever use `ON CONFLICT`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains Flyway guarantees each numbered migration runs exactly once per database, in order, and is checksummed against modification -- so a migration inserting a row can safely assume it doesn't exist yet; there's no conflict to handle because Flyway itself is the mechanism preventing one.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Flyway guarantees each migration runs exactly once per database, so there's no conflict to handle in the first place$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$`ON CONFLICT` is a feature this specific PostgreSQL version doesn't support$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$This project's migrations are described as containing a real bug that happens to avoid needing `ON CONFLICT`$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$`ON CONFLICT` only works with `UPDATE` statements, never with `INSERT`$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin kendi Flyway migration'ları neden hiçbir zaman `ON CONFLICT` kullanmaz?$$,
           NULL, NULL,
           $$Ders, Flyway'in her numaralı migration'ın veritabanı başına tam olarak bir kez, sırayla çalışmasını garanti ettiğini, ve değişikliğe karşı checksum'landığını açıklar -- bu yüzden bir satır ekleyen bir migration, onun henüz var olmadığını güvenle varsayabilir; ele alınacak bir çakışma yoktur çünkü Flyway'in kendisi bunu önleyen mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu projenin migration'larının, `ON CONFLICT`e ihtiyaç duymamayı tesadüfen sağlayan gerçek bir hata içerdiği tanımlanır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$`ON CONFLICT` yalnızca `UPDATE` ifadeleriyle çalışır, `INSERT` ile asla çalışmaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Flyway, her migration'ın veritabanı başına tam olarak bir kez çalışmasını garanti eder, bu yüzden zaten ele alınacak bir çakışma yoktur$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$`ON CONFLICT`, bu spesifik PostgreSQL sürümünün desteklemediği bir özelliktir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this statement, what does `EXCLUDED.name` refer to, if a `category` row with `(course_id=5, slug='postgresql-foundations')` already exists with `name = 'Old Name'`?$$,
           $$INSERT INTO category (course_id, name, slug, sort_order)
VALUES (5, 'PostgreSQL Foundations', 'postgresql-foundations', 1)
ON CONFLICT (course_id, slug)
DO UPDATE SET name = EXCLUDED.name;$$, $$sql$$,
           $$The lesson explains EXCLUDED refers to the row that was about to be inserted, not the existing row -- so EXCLUDED.name is the new 'PostgreSQL Foundations' value from the VALUES clause, and after this statement runs, the existing row's name is updated from 'Old Name' to 'PostgreSQL Foundations'.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both values combined into a single concatenated string$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The new value from the `VALUES` clause, `'PostgreSQL Foundations'` -- `EXCLUDED` refers to the row that was about to be inserted$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The existing row's current value, `'Old Name'` -- `EXCLUDED` refers to the row already in the table$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Nothing -- `EXCLUDED` is only valid inside a `DO NOTHING` clause, not `DO UPDATE`$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ifade göz önüne alındığında, `(kurs_id=5, slug='pg-temelleri')` olan bir `category` satırı zaten `ad = 'Eski Ad'` ile mevcutsa, `EXCLUDED.ad` neye atıfta bulunur?$$,
           $$INSERT INTO category (kurs_id, ad, slug, sira)
VALUES (5, 'PostgreSQL Temelleri', 'pg-temelleri', 1)
ON CONFLICT (kurs_id, slug)
DO UPDATE SET ad = EXCLUDED.ad;$$, $$sql$$,
           $$Ders, EXCLUDED'in mevcut satıra değil, eklenmek üzere olan satıra atıfta bulunduğunu açıklar -- bu yüzden EXCLUDED.ad, VALUES ifadesinden gelen yeni 'PostgreSQL Temelleri' değeridir, ve bu ifade çalıştıktan sonra, mevcut satırın adı 'Eski Ad'dan 'PostgreSQL Temelleri'ne güncellenir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Mevcut satırın şu anki değeri, `'Eski Ad'` -- `EXCLUDED`, tabloda zaten var olan satıra atıfta bulunur$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir şey -- `EXCLUDED` yalnızca bir `DO NOTHING` ifadesi içinde geçerlidir, `DO UPDATE` içinde değil$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her iki değerin tek bir birleştirilmiş dizgede birleşimi$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$VALUES ifadesinden gelen yeni değer, `'PostgreSQL Temelleri'` -- `EXCLUDED`, eklenmek üzere olan satıra atıfta bulunur$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about INSERT/UPDATE/DELETE, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (ON CONFLICT only catches a UNIQUE/PRIMARY KEY/EXCLUDE constraint violation on the specific column(s) named -- a NOT NULL or foreign key violation still fails the statement outright; DELETE FROM table with no WHERE removes rows one by one, slower than TRUNCATE on a large table and firing any triggers, unlike TRUNCATE's faster structural operation); the lesson explicitly recommends INSERT...SELECT over hardcoding a foreign key's numeric id (not the reverse), and it states RETURNING works identically on UPDATE and DELETE too, not only on INSERT.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This lesson recommends hardcoding a foreign key's numeric id directly, rather than using the `INSERT ... SELECT` pattern$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`RETURNING` only works on `INSERT` statements, not on `UPDATE` or `DELETE`$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`ON CONFLICT` only catches a `UNIQUE`/`PRIMARY KEY`/`EXCLUDE` violation on the specific column(s) named -- a `NOT NULL` violation still fails the statement outright$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`DELETE FROM table` (no `WHERE`) removes rows one by one and fires triggers, unlike the faster, purely structural `TRUNCATE TABLE`$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, INSERT/UPDATE/DELETE hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`ON CONFLICT`'in yalnızca adı geçen spesifik sütun(lar) üzerindeki bir UNIQUE/PRIMARY KEY/EXCLUDE ihlalini yakalaması -- bir NOT NULL ya da foreign key ihlalinin ifadeyi hâlâ doğrudan başarısız kılması; WHERE'siz `DELETE FROM table`'ın satırları teker teker kaldırması ve trigger'ları tetiklemesi, TRUNCATE TABLE'ın daha hızlı, tamamen yapısal işleminin aksine); ders açıkça bir foreign key'in sayısal id'sini sabit kodlamak yerine INSERT...SELECT'i önerir (tersini değil), ve RETURNING'in yalnızca INSERT'te değil, UPDATE ve DELETE'te de birebir aynı şekilde çalıştığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'inserting-updating-and-deleting-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`ON CONFLICT`, yalnızca adı geçen spesifik sütun(lar) üzerindeki bir `UNIQUE`/`PRIMARY KEY`/`EXCLUDE` ihlalini yakalar -- bir `NOT NULL` ihlali ifadeyi hâlâ doğrudan başarısız kılar$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$WHERE'siz `DELETE FROM table`, satırları teker teker kaldırır ve trigger'ları tetikler, daha hızlı, tamamen yapısal `TRUNCATE TABLE`'ın aksine$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu ders, `INSERT ... SELECT` kalıbını kullanmak yerine, bir foreign key'in sayısal id'sini doğrudan sabit kodlamayı önerir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`RETURNING` yalnızca `INSERT` ifadelerinde çalışır, `UPDATE` ya da `DELETE`'te çalışmaz$$, FALSE, 3 FROM new_question_tr7;

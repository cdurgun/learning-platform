-- Promotion batch
-- Topic: databases-schemas-tables-and-basic-sql (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/databases-schemas-tables-and-basic-sql.md and content/tr/databases-schemas-tables-and-basic-sql.md -- NOT produced by n8n,
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
           $$According to this lesson, what is the full hierarchy from a PostgreSQL server down to a table?$$,
           NULL, NULL,
           $$The lesson states the full hierarchy is server -> database -> schema -> table: a server can host many databases, a database can have several schemas, and a schema can have many tables.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$server -> database -> schema -> table$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$server -> schema -> database -> table$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$database -> server -> table -> schema$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$table -> schema -> database -> server$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir PostgreSQL sunucusundan bir tabloya kadar olan tam hiyerarşi nedir?$$,
           NULL, NULL,
           $$Ders, tam hiyerarşinin sunucu -> veritabanı -> şema -> tablo olduğunu belirtir: bir sunucu birçok veritabanını barındırabilir, bir veritabanının birden fazla şeması olabilir, ve bir şemanın birçok tablosu olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$veritabanı -> sunucu -> tablo -> şema$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$tablo -> şema -> veritabanı -> sunucu$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$sunucu -> veritabanı -> şema -> tablo$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$sunucu -> şema -> veritabanı -> tablo$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`CREATE TABLE` belongs to which category of SQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson classifies CREATE TABLE (along with ALTER TABLE and DROP TABLE) as DDL (Data Definition Language) -- statements that define or change the structure of a database, distinct from DML (INSERT/UPDATE/DELETE/SELECT), which reads and writes rows within a structure DDL already created.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It belongs to both DDL and DML equally, depending on which columns are defined$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$DDL (Data Definition Language) -- it defines or changes structure, not rows$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$DML (Data Manipulation Language) -- it reads and writes rows within an existing structure$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It doesn't belong to either category -- CREATE TABLE is considered a purely administrative command$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `CREATE TABLE` SQL'in hangi kategorisine aittir?$$,
           NULL, NULL,
           $$Ders, CREATE TABLE'ı (ALTER TABLE ve DROP TABLE ile birlikte) DDL (Data Definition Language) olarak sınıflandırır -- bir veritabanının yapısını tanımlayan ya da değiştiren ifadeler, DDL'nin zaten oluşturduğu bir yapı içindeki satırları okuyan ve yazan DML'den (INSERT/UPDATE/DELETE/SELECT) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DML (Data Manipulation Language) -- var olan bir yapı içindeki satırları okur ve yazar$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$İkisine de ait değildir -- CREATE TABLE tamamen idari bir komut olarak kabul edilir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hangi sütunların tanımlandığına bağlı olarak hem DDL'ye hem DML'ye eşit şekilde aittir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$DDL (Data Definition Language) -- yapıyı tanımlar ya da değiştirir, satırları değil$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Statement Terminators, Case Sensitivity, and Identifiers," what happens to an unquoted table name like `Course` when PostgreSQL processes it?$$,
           NULL, NULL,
           $$The lesson states unquoted identifiers (table and column names) are automatically lowercased by PostgreSQL regardless of how they're typed -- so `Course`, `COURSE`, and `course` all refer to the identical table, unless one of them was created with double quotes.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL rejects it outright, since unquoted identifiers must always be entirely lowercase to begin with$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It's automatically converted to uppercase, the opposite of PostgreSQL's actual behavior$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It is automatically folded to lowercase (`course`), so `Course`, `COURSE`, and `course` all refer to the identical table$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It stays exactly as typed, case-sensitive, the same way an unquoted Java identifier would$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Statement Terminators, Case Sensitivity, and Identifiers'a göre, `Kurs` gibi tırnaksız bir tablo adına PostgreSQL onu işlerken ne olur?$$,
           NULL, NULL,
           $$Ders, tırnaksız tanımlayıcıların (tablo ve sütun adlarının), nasıl yazıldığından bağımsız olarak PostgreSQL tarafından otomatik olarak küçük harfe çevrildiğini belirtir -- bu yüzden `Kurs`, `KURS` ve `kurs`, biri çift tırnakla oluşturulmadığı sürece hepsi birebir aynı tabloya atıfta bulunur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Otomatik olarak küçük harfe çevrilir (`kurs`), bu yüzden `Kurs`, `KURS` ve `kurs` hepsi birebir aynı tabloya atıfta bulunur$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Tırnaksız bir Java tanımlayıcısında olduğu gibi, tam olarak yazıldığı gibi, büyük/küçük harfe duyarlı kalır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL bunu doğrudan reddeder, çünkü tırnaksız tanımlayıcılar baştan tamamen küçük harf olmak zorundadır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Otomatik olarak büyük harfe çevrilir, PostgreSQL'in gerçek davranışının tam tersi$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "Common Misconceptions," is a database and a schema the same thing?$$,
           NULL, NULL,
           $$The lesson explicitly says they're not the same -- a database is the top-level container psql's \l lists and \c switches between; a schema is a namespace INSIDE one database, which \dn lists. A single database can hold many schemas, even though this project happens to have exactly one (public) per database.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- "database" and "schema" are simply two different names PostgreSQL uses interchangeably for the identical concept$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$No, but only because this specific project defines multiple schemas per database$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, and \dn and \l are described as producing identical output for that reason$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- a database is the top-level container (\l/\c); a schema is a namespace inside one database (\dn), and a database can hold many schemas$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Common Misconceptions' bölümüne göre, bir veritabanı ile bir şema aynı şey midir?$$,
           NULL, NULL,
           $$Ders, bunların aynı olmadığını açıkça belirtir -- bir veritabanı, psql'in \l'sinin listelediği ve \c'sinin arasında geçiş yaptığı en üst seviye kaptır; bir şema ise, \dn'nin listelediği, bir veritabanının İÇİNDEKİ bir isim alanıdır. Bu proje veritabanı başına tam olarak bir şemaya (public) sahip olsa da, tek bir veritabanı birçok şemayı barındırabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ve \dn ile \l'nin bu nedenle birebir aynı çıktıyı ürettiği tanımlanır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- bir veritabanı en üst seviye kaptır (\l/\c); bir şema bir veritabanının içindeki bir isim alanıdır (\dn), ve bir veritabanı birçok şemayı barındırabilir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- 'veritabanı' ve 'şema', PostgreSQL'in birebir aynı kavram için birbirinin yerine kullandığı iki farklı isimdir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır, ama yalnızca bu spesifik proje veritabanı başına birden fazla şema tanımladığı için$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What starts a single-line SQL comment in this project's migrations, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `--` starts a single-line SQL comment, running to the end of that line -- unrelated to Java's `//` in origin, but serving the identical purpose; SQL also supports block comments (/* ... */), though this project's migrations only ever use `--`.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`--` -- it starts a single-line comment running to the end of that line$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$`//`, the exact same syntax Java uses for a single-line comment$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$`#`, the same character used for comments in some scripting languages$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$SQL has no concept of comments at all -- every line must be executable$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin migration'larında tek satırlık bir SQL yorumunu ne başlatır?$$,
           NULL, NULL,
           $$Ders, `--`'nin, o satırın sonuna kadar süren tek satırlık bir yorumu başlattığını belirtir -- kökeni itibarıyla Java'nın `//`'siyle ilgisiz olsa da, birebir aynı amaca hizmet eder; SQL ayrıca blok yorumlarını da (/* ... */) destekler, ama bu projenin migration'ları yalnızca `--` kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`#`, bazı betik dillerinde yorumlar için kullanılan aynı karakter$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$SQL'in yorum kavramı hiç yoktur -- her satır çalıştırılabilir olmalıdır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$`--` -- o satırın sonuna kadar süren tek satırlık bir yorum başlatır$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$`//`, Java'nın tek satırlık yorum için kullandığı birebir aynı söz dizimi$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real column definition from V1__init_schema.sql, which of the following does it guarantee, according to this lesson's reading of the syntax?$$,
           $$slug VARCHAR(255) NOT NULL UNIQUE$$, $$sql$$,
           $$The lesson reads this left to right: a VARCHAR(255) column that can never be NULL, plus a UNIQUE constraint meaning no two rows in this table may share the same value -- reading the syntax fluently, as this lesson's job is, rather than the full constraint mechanics (deferred to "Constraints and Keys").$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The column's value must be unique only when combined with another column also marked UNIQUE elsewhere$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The column can never be NULL, and no two rows in the table may share the same `slug` value$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The column can be NULL for at most one row, since UNIQUE permits exactly one NULL$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The column enforces a maximum of 255 rows in the entire table$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$V1__init_schema.sql'den alınan bu gerçek sütun tanımı göz önüne alındığında, bu dersin söz dizimini okuma şekline göre bu ne garanti eder?$$,
           $$slug VARCHAR(255) NOT NULL UNIQUE$$, $$sql$$,
           $$Ders bunu soldan sağa okur: asla NULL olamayan bir VARCHAR(255) sütunu, artı bu tablodaki hiçbir iki satırın aynı değeri paylaşamayacağı anlamına gelen bir UNIQUE kısıtı -- bu dersin işi olduğu gibi söz dizimini akıcı okumak, tam kısıt mekaniğini değil (bu 'Constraints and Keys'e bırakılmıştır).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sütun en fazla bir satır için NULL olabilir, çünkü UNIQUE tam olarak bir NULL'a izin verir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Sütun, tüm tabloda maksimum 255 satır sınırı uygular$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Sütunun değeri, yalnızca başka bir yerde UNIQUE olarak işaretlenmiş başka bir sütunla birleştirildiğinde benzersiz olmalıdır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Sütun asla NULL olamaz, ve tablodaki hiçbir iki satır aynı `slug` değerini paylaşamaz$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about SQL syntax, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (SQL keywords are case-insensitive -- uppercase is a readability convention this project follows, not a requirement; a UNIQUE column can still hold multiple NULLs, since PostgreSQL never treats one NULL as equal to another, including for uniqueness); the lesson does not claim NOT NULL prevents duplicate values (NOT NULL and UNIQUE are independent constraints), and it explicitly says PostgreSQL supports transactional DDL, meaning a CREATE TABLE inside a transaction CAN be rolled back, not that it can never be.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A `NOT NULL` constraint on a column also automatically prevents that column from holding duplicate values across rows$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$PostgreSQL does not support transactional DDL -- a `CREATE TABLE` inside a transaction can never be rolled back$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$SQL keywords like `CREATE TABLE` and `NOT NULL` are case-insensitive in PostgreSQL -- uppercase is a readability convention, not a requirement$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A `UNIQUE` column can still hold multiple `NULL` rows, since PostgreSQL never considers one `NULL` equal to another, even for uniqueness checks$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, SQL söz dizimi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (SQL anahtar kelimelerinin büyük/küçük harfe duyarsız olması -- büyük harfin bu projenin izlediği bir okunabilirlik kuralı olması, bir zorunluluk değil; bir UNIQUE sütunun, PostgreSQL bir NULL'u başka bir NULL'a hiçbir zaman eşit saymadığı için, benzersizlik kontrolleri dahil, hâlâ birden fazla NULL tutabilmesi); ders, NOT NULL'un yinelenen değerleri de otomatik olarak engellediğini iddia etmez (NOT NULL ve UNIQUE bağımsız kısıtlardır), ve PostgreSQL'in transactional DDL desteklediğini, yani bir transaction içindeki CREATE TABLE'ın geri alınamayacağını değil geri alınABİLECEĞİNİ açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`CREATE TABLE` ve `NOT NULL` gibi SQL anahtar kelimeleri PostgreSQL'de büyük/küçük harfe duyarsızdır -- büyük harf bir okunabilirlik kuralıdır, bir zorunluluk değil$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir `UNIQUE` sütun hâlâ birden fazla `NULL` satırı tutabilir, çünkü PostgreSQL bir `NULL`'u, benzersizlik kontrolleri dahil, başka bir `NULL`'a hiçbir zaman eşit saymaz$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir sütundaki `NOT NULL` kısıtı, o sütunun satırlar arasında yinelenen değerler tutmasını da otomatik olarak engeller$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$PostgreSQL transactional DDL desteklemez -- bir transaction içindeki `CREATE TABLE` hiçbir zaman geri alınamaz$$, FALSE, 3 FROM new_question_tr7;

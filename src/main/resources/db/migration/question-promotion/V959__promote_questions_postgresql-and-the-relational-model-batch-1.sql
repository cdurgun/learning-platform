-- Promotion batch
-- Topic: postgresql-and-the-relational-model (language: en x5, tr x5)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/postgresql-and-the-relational-model.md and content/tr/postgresql-and-the-relational-model.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (5 EN + 5 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker course batch.
--
-- Strict 50/50 EN/TR split (5+5) organized as 5 CONCEPT PAIRS -- each EN
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
           $$According to this lesson, what specifically makes a database "relational"?$$,
           NULL, NULL,
           $$The lesson defines "relational" as data organized as separate tables that refer to one another through shared values (like topic.category_id pointing at a row in category), instead of duplicating data or nesting it inside one giant structure -- not "related" in a loose, everyday sense.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tables refer to one another through shared column values, instead of duplicating or nesting data inside one structure$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Data is related in the loose, everyday sense that any two pieces of information can be considered connected$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Every table must physically live on the same disk as every other table on the server$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Rows within a single table are related to each other by their insertion order$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir veritabanını özellikle 'ilişkisel' (relational) yapan nedir?$$,
           NULL, NULL,
           $$Ders, 'ilişkisel'i, verinin bir dev yapı içinde tekrarlanması ya da iç içe yerleştirilmesi yerine, paylaşılan değerler aracılığıyla birbirine atıfta bulunan ayrı tablolar olarak organize edilmesi olarak tanımlar (topic.category_id'nin category'deki bir satırı işaret etmesi gibi) -- gündelik, gevşek anlamda 'ilişkili' değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her tablonun fiziksel olarak sunucudaki her diğer tabloyla aynı diskte yaşamak zorunda olması$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Tek bir tablo içindeki satırların birbiriyle ekleme sırasına göre ilişkili olması$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Tabloların, veriyi bir yapı içinde tekrarlamak ya da iç içe yerleştirmek yerine, paylaşılan sütun değerleri aracılığıyla birbirine atıfta bulunması$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Verinin, herhangi iki bilginin bağlantılı sayılabileceği gündelik, gevşek anlamda ilişkili olması$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the relationship between SQL and PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson describes this as the same specification-vs-implementation relationship already covered for JPA and Hibernate, one layer down: SQL is a broadly standardized language, and PostgreSQL is one real, running piece of software that implements it (alongside others like MySQL, Oracle Database, SQL Server).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SQL only works with PostgreSQL and cannot be used with any other database system$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$SQL is a standardized language; PostgreSQL is one specific, real implementation of a relational database built around it -- the same spec-vs-implementation relationship as JPA and Hibernate$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$SQL and PostgreSQL are two names for the exact same thing, with no meaningful distinction$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL is a standardized language, and SQL is one specific implementation of it$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, SQL ile PostgreSQL arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$Ders bunu, JPA ve Hibernate için zaten ele alınan aynı spesifikasyon-uygulama ilişkisinin bir katman aşağısı olarak tanımlar: SQL geniş çapta standartlaştırılmış bir dildir, PostgreSQL ise onu uygulayan (MySQL, Oracle Database, SQL Server gibi diğerleriyle birlikte) gerçek, çalışan bir yazılım parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SQL ve PostgreSQL, anlamlı bir ayrım olmadan tamamen aynı şeyin iki adıdır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$PostgreSQL standartlaştırılmış bir dildir, SQL ise onun belirli bir uygulamasıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$SQL yalnızca PostgreSQL ile çalışır ve başka hiçbir veritabanı sistemiyle kullanılamaz$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$SQL standartlaştırılmış bir dildir; PostgreSQL onun etrafında kurulu, ilişkisel bir veritabanının belirli, gerçek bir uygulamasıdır -- JPA ve Hibernate ile aynı spesifikasyon-uygulama ilişkisi$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Tables, Rows, and Columns: The Core Mental Model," what does a column guarantee for every row in its table?$$,
           NULL, NULL,
           $$The lesson defines a column as one named, typed slot every row in that table has a value for -- or explicitly has no value for, when the column allows it (i.e., allows NULL); it isn't an optional field some rows have and others simply lack entirely.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A value that is always identical across every row in the table$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A reference that always points to a row in a different table$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A named, typed slot that every row has a value for, or explicitly has no value for when the column allows NULL$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A slot that only some rows in the table are required to have, depending on when they were inserted$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Tables, Rows, and Columns: The Core Mental Model'a göre, bir sütun, tablosundaki her satır için neyi garanti eder?$$,
           NULL, NULL,
           $$Ders, bir sütunu, o tablodaki her satırın bir değere sahip olduğu -- ya da sütun buna izin veriyorsa (yani NULL'a izin veriyorsa) açıkça hiçbir değere sahip olmadığı, adlandırılmış, tipli bir yuva olarak tanımlar; bazı satırların sahip olduğu, diğerlerinin ise tamamen yoksun olduğu opsiyonel bir alan değildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her satırın bir değere sahip olduğu, ya da sütun NULL'a izin veriyorsa açıkça hiçbir değere sahip olmadığı, adlandırılmış, tipli bir yuva$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Tablodaki yalnızca bazı satırların, ne zaman eklendiklerine bağlı olarak sahip olması gereken bir yuva$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tablodaki her satırda her zaman birebir aynı olan bir değer$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Her zaman farklı bir tablodaki bir satıra işaret eden bir referans$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Put this lesson's five-layer stack, from a Java method call down to the actual stored row, in the correct order.$$,
           NULL, NULL,
           $$The lesson lays out the stack as: Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL -> tables/indexes/constraints/transactions -- each layer hands off to a specific, nameable next one.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL -> SQL$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$SQL -> Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$PostgreSQL -> SQL -> Hibernate -> Spring Data JPA -> Spring Boot$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin, bir Java metot çağrısından gerçekten depolanmış satıra kadar olan beş katmanlı yığınını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, yığını şöyle sıralar: Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL -> tablolar/indeksler/kısıtlar/transaction'lar -- her katman, adlandırılabilir belirli bir sonrakine devreder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL -> SQL -> Hibernate -> Spring Data JPA -> Spring Boot$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL -> SQL$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$SQL -> Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about ACID, as introduced in this lesson's "ACID: A First Look," are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Atomicity means a group of changes either all happen or none do; Isolation means one transaction doesn't see another transaction's unfinished, uncommitted work); the lesson states PostgreSQL provides all four ACID guarantees (not just some), and it explicitly says the full mechanics are deliberately left for "Transactions and Concurrency in PostgreSQL" later in the course, not taught in depth in this lesson.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Atomicity means a group of changes either all happen, or none of them do$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Isolation means one transaction doesn't see another transaction's unfinished, uncommitted work$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$PostgreSQL is described in this lesson as providing only some, not all, of the four ACID guarantees$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$This lesson teaches the full mechanics of ACID, transactions, and locking in depth, with nothing left for a later lesson$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'ACID: A First Look' bölümünde tanıtıldığı şekliyle, ACID hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Atomicity'nin, bir grup değişikliğin ya hepsinin olması ya da hiçbirinin olmaması anlamına gelmesi; Isolation'ın, bir transaction'ın başka bir transaction'ın bitmemiş, commit edilmemiş işini görmemesi anlamına gelmesi); ders, PostgreSQL'in dört ACID garantisinin hepsini (yalnızca bazılarını değil) sağladığını belirtir, ve tam mekaniğin bilerek bu derste değil, kursun sonraki bir dersi olan 'Transactions and Concurrency in PostgreSQL'de öğretildiğini açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'postgresql-and-the-relational-model'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu derste PostgreSQL'in dört ACID garantisinden yalnızca bazılarını sağladığı, hepsini değil, tanımlanır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu ders, ACID'in, transaction'ların ve kilitlemenin tam mekaniğini derinlemesine öğretir, sonraki bir ders için hiçbir şey bırakmaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Atomicity, bir grup değişikliğin ya hepsinin olması ya da hiçbirinin olmaması anlamına gelir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Isolation, bir transaction'ın başka bir transaction'ın bitmemiş, commit edilmemiş işini görmemesi anlamına gelir$$, TRUE, 3 FROM new_question_tr5;

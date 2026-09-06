-- Promotion batch
-- Topic: constraints-and-keys (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/constraints-and-keys.md and content/tr/constraints-and-keys.md -- NOT produced by n8n,
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
           $$What two constraints does `PRIMARY KEY` bundle together, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states PRIMARY KEY is really two constraints bundled together: NOT NULL (a primary key column can never be empty) plus UNIQUE (no two rows can share the same value) -- and PostgreSQL automatically builds an index on it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`NOT NULL` plus `UNIQUE`$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$`CHECK` plus `FOREIGN KEY`$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$`UNIQUE` plus `FOREIGN KEY`$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$`NOT NULL` plus `CHECK`$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `PRIMARY KEY` hangi iki kısıtı birlikte paketler?$$,
           NULL, NULL,
           $$Ders, PRIMARY KEY'in gerçekte birlikte paketlenmiş iki kısıt olduğunu belirtir: NOT NULL (bir primary key sütunu asla boş olamaz) artı UNIQUE (hiçbir iki satır aynı değeri paylaşamaz) -- ve PostgreSQL onun üzerine otomatik olarak bir index inşa eder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`UNIQUE` artı `FOREIGN KEY`$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$`NOT NULL` artı `CHECK`$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$`NOT NULL` artı `UNIQUE`$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$`CHECK` artı `FOREIGN KEY`$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What actually happens if application code tries to `INSERT` a `category` row with a `course_id` of `9999` when no course with that id exists, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states the FOREIGN KEY constraint enforces referential integrity: PostgreSQL itself rejects the INSERT outright with a real, specific error ("violates foreign key constraint"), regardless of what Java code did or didn't validate beforehand.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The row is inserted successfully, but a warning is logged rather than the operation failing$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL rejects the INSERT outright with a specific "violates foreign key constraint" error, regardless of Java-level validation$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The row is inserted successfully, with `course_id` silently set to `NULL` instead of `9999`$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The row is inserted successfully, and PostgreSQL automatically creates a new `course` row with id `9999`$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, uygulama kodu, öyle bir id'ye sahip bir kurs olmadığında `course_id`'si `9999` olan bir `category` satırını `INSERT` etmeye çalışırsa gerçekte ne olur?$$,
           NULL, NULL,
           $$Ders, FOREIGN KEY kısıtının referential integrity'yi zorunlu kıldığını belirtir: PostgreSQL'in kendisi, Java kodunun önceden neyi doğrulayıp doğrulamadığından bağımsız olarak, gerçek, spesifik bir hatayla ('violates foreign key constraint') INSERT'i doğrudan reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Satır başarıyla eklenir, `course_id` sessizce `9999` yerine `NULL` olarak ayarlanır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Satır başarıyla eklenir, ve PostgreSQL otomatik olarak `9999` id'sine sahip yeni bir `course` satırı oluşturur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Satır başarıyla eklenir, ama işlem başarısız olmak yerine bir uyarı loglanır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$PostgreSQL, Java seviyesinde doğrulamadan bağımsız olarak, spesifik bir 'violates foreign key constraint' hatasıyla INSERT'i doğrudan reddeder$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real foreign key from V1__init_schema.sql, if a `course` row is deleted, what happens to the `category` rows that reference it?$$,
           $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$, $$sql$$,
           $$The lesson explains ON DELETE CASCADE means deleting a course row automatically deletes every category row that references it -- which cascades further into every topic and topic_translation that depends on those categories, since deleting one row intentionally deletes an entire dependent subtree.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The `category` rows survive unchanged, but their `course_id` column is set to `NULL`$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing happens to `category` rows -- `ON DELETE CASCADE` only affects the `course` table's own rows$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Every `category` row referencing that `course` is automatically deleted too, cascading further into dependent `topic` rows$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The `DELETE` on `course` fails outright, since a foreign key always blocks deleting a referenced row$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$V1__init_schema.sql'den alınan bu gerçek foreign key göz önüne alındığında, bir `course` satırı silinirse, ona referans veren `category` satırlarına ne olur?$$,
           $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$, $$sql$$,
           $$Ders, ON DELETE CASCADE'in, bir course satırını silmenin ona referans veren her category satırını da otomatik olarak sildiği anlamına geldiğini açıklar -- bu, o kategorilere bağımlı her topic ve topic_translation'a daha da yayılır, çünkü bir satırı silmek bilerek tüm bağımlı alt ağacı siler.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$O course'a referans veren her `category` satırı da otomatik olarak silinir, bu da bağımlı `topic` satırlarına daha da yayılır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$`course` üzerindeki `DELETE` doğrudan başarısız olur, çünkü bir foreign key her zaman referans verilen bir satırı silmeyi engeller$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`category` satırları değişmeden kalır, ama `course_id` sütunları `NULL` olarak ayarlanır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$`category` satırlarına hiçbir şey olmaz -- `ON DELETE CASCADE` yalnızca `course` tablosunun kendi satırlarını etkiler$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this real constraint from `quiz_question_link`, what happens when `DELETE FROM question WHERE id = ...` is attempted for a question still linked into a published quiz?$$,
           $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$, $$sql$$,
           $$The lesson explains ON DELETE RESTRICT blocks the delete outright: as long as a question is linked into any published quiz, DELETE FROM question fails with an error instead of silently removing the link along with it -- the opposite of CASCADE's behavior.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The `question` row is deleted, and its `quiz_question_link` row is automatically deleted along with it$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The `question` row is deleted, and its `quiz_question_link.question_id` is automatically set to `NULL`$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing happens -- `RESTRICT` is purely documentation and has no actual enforcement effect$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The `DELETE` fails with an error -- `ON DELETE RESTRICT` blocks it outright while the link still exists$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`quiz_question_link`'ten alınan bu gerçek kısıt göz önüne alındığında, hâlâ yayınlanmış bir quiz'e bağlı bir soru için `DELETE FROM question WHERE id = ...` denendiğinde ne olur?$$,
           $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$, $$sql$$,
           $$Ders, ON DELETE RESTRICT'in silmeyi doğrudan engellediğini açıklar: bir soru herhangi bir yayınlanmış quiz'e bağlı olduğu sürece, DELETE FROM question, bağlantıyı onunla birlikte sessizce kaldırmak yerine bir hatayla başarısız olur -- CASCADE'in davranışının tam tersi.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey olmaz -- `RESTRICT` tamamen dokümantasyondur ve gerçek bir zorlama etkisi yoktur$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$`DELETE` bir hatayla başarısız olur -- `ON DELETE RESTRICT`, bağlantı hâlâ var olduğu sürece bunu doğrudan engeller$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$`question` satırı silinir, ve `quiz_question_link` satırı onunla birlikte otomatik olarak silinir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$`question` satırı silinir, ve `quiz_question_link.question_id` otomatik olarak `NULL` olarak ayarlanır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This project's real `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)` allows two different courses to each have a category with the slug `fundamentals`. Why, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains a composite (table-level) UNIQUE only forbids duplicates across the combination of both columns -- two different courses are free to each have a category with the slug `fundamentals`, but the same course can't have two; this is genuinely different from two separate single-column UNIQUE constraints, which would each reject duplicates of that column alone.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A composite UNIQUE only rejects duplicates of the combination of both columns -- the same `slug` under two different `course_id`s is not a duplicate$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It's a bug in this project's schema -- a composite UNIQUE was supposed to behave exactly like two separate single-column UNIQUE constraints$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$`UNIQUE` constraints in PostgreSQL only apply to the first column listed, silently ignoring any additional columns$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The composite constraint only applies to rows inserted after the constraint was added, not to any table-level guarantee$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)`'ı, iki farklı kursun her birinin `fundamentals` slug'ına sahip bir kategoriye sahip olmasına izin verir. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, kompozit (tablo seviyesi) bir UNIQUE'in yalnızca her iki sütunun kombinasyonundaki yinelemeleri reddettiğini açıklar -- iki farklı kurs, her biri `fundamentals` slug'ına sahip bir kategoriye sahip olmakta serbesttir, ama aynı kursun iki tanesi olamaz; bu, her biri tek başına o sütunun yinelemelerini reddedecek iki ayrı tek-sütunlu UNIQUE kısıtından gerçekten farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL'de `UNIQUE` kısıtları yalnızca listelenen ilk sütuna uygulanır, ek sütunları sessizce yok sayar$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Kompozit kısıt yalnızca kısıt eklendikten sonra eklenen satırlara uygulanır, tablo seviyesi bir garantiye değil$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Kompozit bir UNIQUE, yalnızca her iki sütunun kombinasyonundaki yinelemeleri reddeder -- iki farklı `course_id` altında aynı `slug` bir yineleme değildir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu projenin şemasında bir hatadır -- kompozit bir UNIQUE'in iki ayrı tek-sütunlu UNIQUE kısıtı gibi davranması gerekiyordu$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This project's real `topic.estimated_minutes` column has no `CHECK` constraint today. According to this lesson, what does this mean in practice?$$,
           NULL, NULL,
           $$The lesson states this is a real, honest gap: nothing at the database level currently stops a migration from inserting a negative value into estimated_minutes -- only application-level care (and, so far, correct migrations) has kept every row valid; a CHECK constraint would turn that assumption into one PostgreSQL itself refuses to let a row violate.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This column is described as being impossible to ever set to a negative value, by design of the BIGSERIAL type$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Nothing at the database level currently prevents a migration from inserting a negative `estimated_minutes` value -- only application-level care has kept rows valid so far$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$PostgreSQL automatically infers a reasonable positive-only range for any INTEGER column, even without an explicit CHECK$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Hibernate enforces a positive-value rule on this column automatically, making a database-level CHECK unnecessary$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `topic.estimated_minutes` sütununun bugün hiçbir `CHECK` kısıtı yok. Bu derse göre, bu pratikte ne anlama gelir?$$,
           NULL, NULL,
           $$Ders, bunun gerçek, dürüst bir boşluk olduğunu belirtir: şu anda veritabanı seviyesinde hiçbir şey bir migration'ın estimated_minutes'a negatif bir değer eklemesini engellemiyor -- şimdiye kadar yalnızca uygulama seviyesi özen (ve doğru migration'lar) her satırı geçerli tutmuştur; bir CHECK kısıtı bu varsayımı PostgreSQL'in kendisinin bir satırın ihlal etmesine izin vermediği bir şeye dönüştürürdü.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL, açık bir CHECK olmasa bile, herhangi bir INTEGER sütunu için makul, yalnızca pozitif bir aralığı otomatik olarak çıkarır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Hibernate bu sütun üzerinde otomatik olarak pozitif-değer kuralını zorunlu kılar, bu yüzden veritabanı seviyesinde bir CHECK gereksizdir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu sütunun, BIGSERIAL tipinin tasarımı gereği hiçbir zaman negatif bir değere ayarlanamayacağı tanımlanır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Şu anda veritabanı seviyesinde hiçbir şey bir migration'ın negatif bir `estimated_minutes` değeri eklemesini engellemiyor -- şimdiye kadar yalnızca uygulama seviyesi özen satırları geçerli tuttu$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about constraints and keys, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the default behavior with no ON DELETE clause at all is effectively RESTRICT, blocking the delete; table-level constraints spanning more than one column, like uq_category_course_slug, are always named explicitly in this project because an auto-generated name is harder to recognize in an error message or a later DROP CONSTRAINT); the lesson explicitly says UNIQUE does NOT imply NOT NULL (a UNIQUE column can hold multiple NULLs), and a CHECK constraint can only see the current row's own values, not another table's data -- cross-table validation needs a trigger or application-level check instead.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A `UNIQUE` constraint on a column automatically implies that column is also `NOT NULL`$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A `CHECK` constraint can reference and validate against another table's data, not just the current row's own values$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$With no `ON DELETE` clause specified at all, the default behavior is effectively `RESTRICT` -- the delete is blocked$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$This project always names table-level constraints spanning more than one column explicitly, rather than relying on an auto-generated name$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, kısıtlar ve anahtarlar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (hiç ON DELETE ifadesi belirtilmediğinde varsayılan davranışın etkili bir şekilde RESTRICT olması, silmeyi engellemesi; uq_category_course_slug gibi birden fazla sütuna yayılan tablo seviyesi kısıtların, otomatik oluşturulan bir ada güvenmek yerine bu projede her zaman açıkça adlandırılması); ders, UNIQUE'in NOT NULL anlamına GELMEDİĞİNİ (bir UNIQUE sütunun birden fazla NULL tutabileceğini) açıkça belirtir, ve bir CHECK kısıtının yalnızca mevcut satırın kendi değerlerini görebileceğini, başka bir tablonun verisini değil -- çapraz tablo doğrulamasının bunun yerine bir trigger ya da uygulama seviyesi kontrol gerektirdiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'constraints-and-keys'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiç `ON DELETE` ifadesi belirtilmediğinde, varsayılan davranış etkili bir şekilde `RESTRICT`tir -- silme engellenir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu proje, birden fazla sütuna yayılan tablo seviyesi kısıtları, otomatik oluşturulan bir ada güvenmek yerine her zaman açıkça adlandırır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir sütundaki `UNIQUE` kısıtı, o sütunun aynı zamanda `NOT NULL` olduğu anlamına otomatik olarak gelir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir `CHECK` kısıtı, yalnızca mevcut satırın kendi değerlerini değil, başka bir tablonun verisini referans alıp doğrulayabilir$$, FALSE, 3 FROM new_question_tr7;

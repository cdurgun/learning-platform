-- Promotion batch
-- Topic: dynamic-queries-with-specifications (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/dynamic-queries-with-specifications.md and
-- content/tr/dynamic-queries-with-specifications.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is a Specification<T>, precisely?$$,
           NULL, NULL,
           $$A description of how to build one WHERE condition -- nothing runs until it's handed to a repository that extends JpaSpecificationExecutor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A description of how to build one WHERE condition -- nothing runs until it's handed to a repository$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A complete, already-executed query that returns results the moment it's created$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A native SQL string written directly against the schema$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A replacement for the entire JpaRepository interface$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir Specification<T> tam olarak nedir?$$,
           NULL, NULL,
           $$Bir WHERE koşulunun nasıl oluşturulacağının bir tanımı -- bir repository'ye teslim edilene kadar hiçbir şey çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tüm JpaRepository interface'inin yerini alan bir şey$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir WHERE koşulunun nasıl oluşturulacağının bir tanımı -- bir repository'ye teslim edilene kadar hiçbir şey çalışmaz$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Oluşturulduğu anda sonuç döndüren, tamamlanmış, zaten çalıştırılmış bir sorgu$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Doğrudan şemaya karşı yazılmış bir native SQL string'i$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the relationship between Specification and JPA's Criteria API (Root, CriteriaBuilder, Predicate)?$$,
           NULL, NULL,
           $$Specification is a thin, convenient wrapper around the Criteria API -- it doesn't replace it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Specification replaced the Criteria API entirely in modern Spring Data JPA$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Specification is a thin, convenient wrapper around the Criteria API -- it doesn't replace it$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Specification is a completely separate mechanism unrelated to the Criteria API$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The Criteria API is built on top of Specification, not the other way around$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Specification ile JPA'nın Criteria API'si (Root, CriteriaBuilder, Predicate) arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$Specification, Criteria API'nin etrafındaki ince, kullanışlı bir sarmalayıcıdır -- onun yerini almaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Criteria API, Specification'ın üzerine kuruludur, tersi değil$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Specification, modern Spring Data JPA'da Criteria API'nin yerini tamamen almıştır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Specification, Criteria API'nin etrafındaki ince, kullanışlı bir sarmalayıcıdır -- onun yerini almaz$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Specification, Criteria API ile hiç ilgisi olmayan tamamen ayrı bir mekanizmadır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What must a repository interface do to be able to accept a Specification at all?$$,
           NULL, NULL,
           $$It must extend JpaSpecificationExecutor<T> alongside JpaRepository<T, ID> -- without it, findAll(Specification) simply doesn't exist on the interface.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It must be annotated with @EnableSpecifications at the class level$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It must implement a custom findAll(Specification) method by hand$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing -- every JpaRepository accepts a Specification automatically by default$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It must extend JpaSpecificationExecutor<T> alongside JpaRepository<T, ID>$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir repository interface'inin bir Specification'ı kabul edebilmesi için ne yapması gerekir?$$,
           NULL, NULL,
           $$JpaRepository<T, ID> ile birlikte JpaSpecificationExecutor<T>'yi de extend etmelidir -- bu olmadan, interface'te findAll(Specification) hiç mevcut değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey -- her JpaRepository varsayılan olarak otomatik olarak bir Specification kabul eder$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Sınıf seviyesinde @EnableSpecifications ile işaretlenmelidir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Elle özel bir findAll(Specification) metodu implemente etmelidir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$JpaRepository<T, ID> ile birlikte JpaSpecificationExecutor<T>'yi de extend etmelidir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this Specification chain produce?$$,
           $$Specification<Topic> spec = Specification
        .where(hasCategory("spring-mvc"))
        .and(hasDifficulty("ADVANCED"));

repository.findAll(spec);$$, $$java$$,
           $$A single combined WHERE condition requiring BOTH category = 'spring-mvc' AND difficulty = 'ADVANCED' at once, executed as one real SQL query.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A single WHERE clause requiring BOTH category = 'spring-mvc' AND difficulty = 'ADVANCED' at once$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A WHERE clause matching EITHER condition, since .and(...) behaves like OR here$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing runs at all until .or(...) is also called on the chain$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Two separate queries, one per condition, with results merged in Java afterward$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu Specification zinciri ne üretir?$$,
           $$Specification<Konu> spec = Specification
        .where(kategoriyeSahip("spring-mvc"))
        .and(zorluguSahip("ILERI"));

repository.findAll(spec);$$, $$java$$,
           $$Aynı anda hem kategori = 'spring-mvc' HEM DE zorluk = 'ILERI' gerektiren, tek bir gerçek SQL sorgusu olarak çalıştırılan birleşik bir WHERE koşulu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı anda hem kategori = 'spring-mvc' HEM DE zorluk = 'ILERI' gerektiren tek bir WHERE koşulu$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Her koşul için bir tane olmak üzere iki ayrı sorgu, sonuçlar daha sonra Java'da birleştirilir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Burada .and(...) OR gibi davrandığı için, İKİ koşuldan birine uyan bir WHERE koşulu$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$.or(...) zincire de eklenmeden hiçbir şey çalışmaz$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A request arrives with neither category nor difficulty supplied. What query does this code end up running?$$,
           $$Specification<Topic> spec = Specification.where(null);
if (category != null)   spec = spec.and(hasCategory(category));
if (difficulty != null) spec = spec.and(hasDifficulty(difficulty));

Page<Topic> page = repository.findAll(spec, pageable);$$, $$java$$,
           $$Since both category and difficulty are null, no .and(...) is ever added -- the query filters on nothing at all, returning every row (paged).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A query that filters nothing at all, returning every row (paged)$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A query that throws a NullPointerException, since Specification.where(null) is invalid$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A query that matches nothing, returning an empty page$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A query filtered on category = null AND difficulty = null as literal SQL conditions$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Ne kategori ne de zorluk sağlanmadan bir istek geliyor. Bu kod hangi sorguyu çalıştırır?$$,
           $$Specification<Konu> spec = Specification.where(null);
if (kategori != null) spec = spec.and(kategoriyeSahip(kategori));
if (zorluk != null)   spec = spec.and(zorluguSahip(zorluk));

Page<Konu> sayfa = repository.findAll(spec, pageable);$$, $$java$$,
           $$Hem kategori hem zorluk null olduğu için, hiç .and(...) eklenmez -- sorgu hiçbir şey filtrelemez, her satırı döndürür (sayfalanmış).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$kategori = null VE zorluk = null'ı literal SQL koşulları olarak filtreleyen bir sorgu$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey filtrelemeyen, her satırı döndüren bir sorgu (sayfalanmış)$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Specification.where(null) geçersiz olduğu için bir NullPointerException fırlatan bir sorgu$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şeyle eşleşmeyen, boş bir sayfa döndüren bir sorgu$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about repository.findAll(spec, pageable)? (Select all that apply)$$,
           NULL, NULL,
           $$It generates a filtered, paged query PLUS a filtered count query -- the same two-query shape as Page<T>, now with a dynamic WHERE clause.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It requires a completely separate repository method for every possible combination of filters$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It generates a filtered, paged query plus a separate filtered count query$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Dynamic filtering and real pagination combine into a single repository call, not two separate steps$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It ignores the Specification entirely when a Pageable is also supplied$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$repository.findAll(spec, pageable) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Filtrelenmiş, sayfalanmış bir sorgu artı ayrı bir filtrelenmiş sayım sorgusu üretir -- Page<T> ile aynı iki-sorgu şekli, şimdi dinamik bir WHERE koşuluyla.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Dinamik filtreleme ve gerçek sayfalama, iki ayrı adım yerine tek bir repository çağrısında birleşir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir Pageable de sağlandığında Specification'ı tamamen yok sayar$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her olası filtre kombinasyonu için tamamen ayrı bir repository metodu gerektirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Filtrelenmiş, sayfalanmış bir sorgu artı ayrı bir filtrelenmiş sayım sorgusu üretir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe when to reach for a Specification versus a derived query method or @Query? (Select all that apply)$$,
           NULL, NULL,
           $$Derived methods and @Query are fixed at compile time; Specification earns its place once the set of active conditions genuinely isn't known until a request arrives. A small, fixed set of optional conditions can sometimes be expressed with a single JPQL :param IS NULL OR ... query instead.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Dynamic filtering always needs a Specification -- there's no other way to express an optional condition$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A Specification should be the default choice for every repository query, regardless of whether filtering is dynamic$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A derived query method's conditions are fixed at compile time -- it can't express "filter by category, but only if supplied"$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Specification earns its place once the SET of active filter conditions genuinely isn't known until a request arrives$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir Specification'a mı yoksa türetilmiş bir sorgu metoduna/@Query'ye mi başvurulacağını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Türetilmiş metotlar ve @Query derleme zamanında sabittir; Specification, aktif koşullar kümesi bir istek gelene kadar gerçekten bilinmediğinde yerini kazanır. Küçük, sabit bir opsiyonel koşul kümesi bazen tek bir JPQL :param IS NULL OR ... sorgusuyla ifade edilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dynamic-queries-with-specifications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Türetilmiş bir sorgu metodunun koşulları derleme zamanında sabittir -- "yalnızca sağlanmışsa kategoriye göre filtrele"yi ifade edemez$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Specification, aktif filtre koşulları KÜMESİ bir istek gelene kadar gerçekten bilinmediğinde yerini kazanır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Dinamik filtreleme her zaman bir Specification gerektirir -- opsiyonel bir koşulu ifade etmenin başka bir yolu yoktur$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Filtrelemenin dinamik olup olmadığından bağımsız olarak, bir Specification her repository sorgusu için varsayılan seçim olmalıdır$$, FALSE, 3 FROM new_question_tr7;

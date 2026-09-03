-- Promotion batch
-- Topic: entities-and-repositories (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/entities-and-repositories.md and
-- content/tr/entities-and-repositories.md.
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
           $$What does @GeneratedValue(strategy = GenerationType.IDENTITY) actually do?$$,
           NULL, NULL,
           $$It delegates id generation to the database's own auto-increment mechanism.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It delegates id generation to the database's own auto-increment mechanism$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It generates the id randomly in application memory before saving$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It requires the caller to supply the id manually before every save$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It disables id generation entirely, leaving the column null$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@GeneratedValue(strategy = GenerationType.IDENTITY) gerçekte ne yapar?$$,
           NULL, NULL,
           $$Id üretimini veritabanının kendi auto-increment mekanizmasına devreder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Id üretimini tamamen devre dışı bırakır, kolonu null bırakır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Id üretimini veritabanının kendi auto-increment mekanizmasına devreder$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Id'yi kaydetmeden önce uygulama belleğinde rastgele üretir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Her save öncesinde çağıranın id'yi elle sağlamasını gerektirir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does @Column(nullable = false, unique = true) actually produce?$$,
           NULL, NULL,
           $$A real NOT NULL UNIQUE constraint enforced by the database itself, not just checked somewhere in Java.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A runtime exception thrown by Hibernate before any SQL is generated at all$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A real NOT NULL UNIQUE constraint enforced by the database itself$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A validation check that only runs inside the Java application, never touching the database schema$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A comment in the generated SQL with no actual enforcement$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@Column(nullable = false, unique = true) gerçekte neyi üretir?$$,
           NULL, NULL,
           $$Veritabanının kendisi tarafından uygulanan gerçek bir NOT NULL UNIQUE kısıtlaması, yalnızca Java'da bir yerde kontrol edilen bir şey değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Üretilen SQL'de hiçbir gerçek uygulaması olmayan bir yorum$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbir SQL üretilmeden önce Hibernate'in fırlattığı bir çalışma zamanı istisnası$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Veritabanının kendisi tarafından uygulanan gerçek bir NOT NULL UNIQUE kısıtlaması$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca Java uygulaması içinde çalışan, veritabanı şemasına hiç dokunmayan bir doğrulama kontrolü$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An entity's difficulty field is mapped without any @Enumerated annotation at all. A new constant DRAFT is later inserted in the MIDDLE of the enum's existing constants. What happens to existing rows?$$,
           $$enum Difficulty { BEGINNER, INTERMEDIATE, ADVANCED }
// later becomes:
enum Difficulty { BEGINNER, DRAFT, INTERMEDIATE, ADVANCED }

@Entity
class Topic {
    private Difficulty difficulty; // no @Enumerated at all
}$$, $$java$$,
           $$Omitting @Enumerated defaults to ORDINAL, storing the constant's numeric position -- inserting a new constant in the middle shifts every subsequent position, silently corrupting existing rows' meaning.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Existing rows' stored ordinal values now silently point at different constants than the ones they were actually saved with$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Hibernate automatically migrates every existing row's stored value to match the new ordinal positions$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing changes -- Hibernate stores the constant's name by default, unaffected by reordering$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The application fails to start with a mapping validation error$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin zorluk alanı hiç @Enumerated annotation'ı olmadan eşleniyor. Daha sonra enum'un mevcut sabitlerinin ORTASINA yeni bir TASLAK sabiti ekleniyor. Mevcut satırlara ne olur?$$,
           $$enum Zorluk { BASLANGIC, ORTA, ILERI }
// daha sonra şu hale gelir:
enum Zorluk { BASLANGIC, TASLAK, ORTA, ILERI }

@Entity
class Konu {
    private Zorluk zorluk; // hiç @Enumerated yok
}$$, $$java$$,
           $$@Enumerated'in atlanması varsayılan olarak ORDINAL'e düşer, sabitin sayısal pozisyonunu saklar -- ortaya yeni bir sabit eklemek sonraki tüm pozisyonları kaydırır, mevcut satırların anlamını sessizce bozar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey değişmez -- Hibernate varsayılan olarak sabitin adını saklar, sıralamadan etkilenmez$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Uygulama bir mapping doğrulama hatasıyla başlayamaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hibernate mevcut her satırın saklı değerini yeni ordinal pozisyonlarla otomatik olarak eşleştirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Mevcut satırların saklı ordinal değerleri artık sessizce, gerçekte kaydedildikleri sabitlerden farklı sabitleri gösterir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Two brand-new, unsaved Topic entities are compared with an equals() implementation based purely on `id != null && id.equals(other.id)`. What is the result of comparing them?$$,
           $$Topic a = new Topic(); // id is null, not yet saved
Topic b = new Topic(); // id is null, not yet saved

System.out.println(a.equals(b));$$, $$java$$,
           $$Since id is null on both, the id != null check fails, so equals() correctly returns false -- two unsaved entities are never considered equal under this convention.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$false -- the id != null check fails for both, so they're never considered equal while unsaved$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws a NullPointerException, since id is null$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It depends on which fields besides id happen to match$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$true -- both have id == null, so they're considered equal$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$İki tane yepyeni, hiç kaydedilmemiş Konu entity'si, tamamen `id != null && id.equals(other.id)`'e dayanan bir equals() implementasyonuyla karşılaştırılıyor. Karşılaştırmanın sonucu nedir?$$,
           $$Konu a = new Konu(); // id null, henüz kaydedilmedi
Konu b = new Konu(); // id null, henüz kaydedilmedi

System.out.println(a.equals(b));$$, $$java$$,
           $$İkisinde de id null olduğu için, id != null kontrolü başarısız olur, bu yüzden equals() doğru şekilde false döndürür -- bu kurala göre iki kaydedilmemiş entity asla eşit sayılmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$false -- id != null kontrolü ikisi için de başarısız olur, bu yüzden kaydedilmemişken asla eşit sayılmazlar$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$true -- ikisinin de id == null'dır, bu yüzden eşit sayılırlar$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$id null olduğu için bir NullPointerException fırlatır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$id dışında hangi alanların eşleştiğine bağlıdır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the specific risk of returning a @Entity directly from a @RestController method?$$,
           NULL, NULL,
           $$It couples the API's public JSON shape to the database mapping itself, and risks serializing a lazy field outside a transaction (LazyInitializationException).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It couples the API's public JSON shape to the database mapping, and risks a LazyInitializationException on a lazy field$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It has no real downside -- entities and DTOs are functionally interchangeable in a REST API$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Jackson is fundamentally unable to serialize any @Entity-annotated class$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It automatically exposes the entity's password field, regardless of whether one exists$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir @RestController metodundan doğrudan bir @Entity döndürmenin özel riski nedir?$$,
           NULL, NULL,
           $$API'nin genel JSON şeklini veritabanı mapping'inin kendisine bağlar ve lazy bir alanı transaction dışında serileştirme riski taşır (LazyInitializationException).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Var olup olmadığına bakılmaksızın entity'nin şifre alanını otomatik olarak açığa çıkarır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$API'nin genel JSON şeklini veritabanı mapping'inin kendisine bağlar ve lazy bir alanda LazyInitializationException riski taşır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Gerçek bir dezavantajı yoktur -- entity'ler ve DTO'lar bir REST API'de işlevsel olarak birbirinin yerine geçebilir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Jackson, @Entity ile işaretlenmiş herhangi bir sınıfı temelde serileştiremez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what each tier of Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository contributes? (Select all that apply)$$,
           NULL, NULL,
           $$Repository is a marker interface with no methods; CrudRepository adds save/findById/findAll/deleteById; PagingAndSortingRepository adds findAll(Sort)/findAll(Pageable); JpaRepository adds JPA-specific extras like flush()/saveAndFlush().$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JpaRepository is the root of the chain, with CrudRepository extending it$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Repository is a marker interface contributing no methods at all, just letting Spring Data recognize it$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$PagingAndSortingRepository adds findAll(Sort) and findAll(Pageable)$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$CrudRepository adds flush() and saveAndFlush(...)$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository zincirinin her katmanının neyi kattığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Repository, hiçbir metot katmayan bir marker interface'tir; CrudRepository save/findById/findAll/deleteById ekler; PagingAndSortingRepository findAll(Sort)/findAll(Pageable) ekler; JpaRepository flush()/saveAndFlush() gibi JPA'ya özgü ekstralar katar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$CrudRepository, flush() ve saveAndFlush(...) ekler$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$JpaRepository zincirin köküdür, CrudRepository onu extend eder$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$PagingAndSortingRepository, findAll(Sort) ve findAll(Pageable) ekler$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Repository, hiçbir metot katmayan, yalnızca Spring Data'nın onu tanımasını sağlayan bir marker interface'tir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does a JPA entity need a no-args constructor?$$,
           NULL, NULL,
           $$Hibernate builds entity instances via reflection, before any field is populated, so it needs a constructor callable with nothing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because JPQL queries can only construct objects using a no-args constructor$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It isn't actually required -- it's only a stylistic convention with no functional purpose$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Because Hibernate builds entity instances via reflection, before any field is populated$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Because Spring Boot requires every class on the classpath to have one, regardless of purpose$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir JPA entity'sinin neden parametresiz bir constructor'a ihtiyacı vardır?$$,
           NULL, NULL,
           $$Hibernate, hiçbir alan doldurulmadan önce entity instance'larını reflection ile oluşturur, bu yüzden hiçbir argümanla çağrılabilecek bir constructor'a ihtiyaç duyar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'entities-and-repositories'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Spring Boot, amacından bağımsız olarak classpath'teki her sınıfın bir tane olmasını gerektirir$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Çünkü JPQL sorguları nesneleri yalnızca parametresiz bir constructor kullanarak oluşturabilir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Aslında gerekli değildir -- yalnızca işlevsel bir amacı olmayan stilistik bir kuraldır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Çünkü Hibernate, hiçbir alan doldurulmadan önce entity instance'larını reflection ile oluşturur$$, TRUE, 3 FROM new_question_tr7;

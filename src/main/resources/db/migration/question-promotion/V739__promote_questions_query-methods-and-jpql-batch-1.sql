-- Promotion batch
-- Topic: query-methods-and-jpql (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/query-methods-and-jpql.md and
-- content/tr/query-methods-and-jpql.md.
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
           $$How does Spring Data JPA determine what SQL a derived query method like findBySlug(String slug) should run?$$,
           NULL, NULL,
           $$It parses the method's name at application startup and builds a query from it, matching pieces against the entity's own properties.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It parses the method's name at application startup and builds a query from it$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It reads a hidden @Query annotation Spring Data JPA generates automatically$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It executes the method once at startup to observe what it returns, then caches that$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It requires a matching SQL file with the same name placed on the classpath$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Spring Data JPA, findBySlug(String slug) gibi türetilmiş bir sorgu metodunun hangi SQL'i çalıştıracağını nasıl belirler?$$,
           NULL, NULL,
           $$Uygulama başlangıcında metodun adını ayrıştırır ve parçaları entity'nin kendi özellikleriyle eşleştirerek ondan bir sorgu oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Classpath'e yerleştirilmiş, aynı adı taşıyan eşleşen bir SQL dosyası gerektirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Uygulama başlangıcında metodun adını ayrıştırır ve ondan bir sorgu oluşturur$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Spring Data JPA'nın otomatik ürettiği gizli bir @Query annotation'ını okur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Ne döndürdüğünü gözlemlemek için metodu başlangıçta bir kez çalıştırır, sonra bunu önbelleğe alır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How many method parameters does this derived query method require?$$,
           $$Optional<Quiz> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(
        Long topicId, String language);$$, $$java$$,
           $$Three conditions (TopicId, Language, ActiveTrue) but only two parameters -- ActiveTrue supplies its own literal boolean value and consumes no parameter.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Four -- OrderByIdAsc also requires a parameter specifying the sort direction$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Three -- one per condition in the method name$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Two -- ActiveTrue supplies its own literal value and consumes no parameter, unlike TopicId and Language$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$One -- only TopicId actually becomes a WHERE condition$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu türetilmiş sorgu metodu kaç metot parametresi gerektirir?$$,
           $$Optional<Quiz> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(
        Long topicId, String language);$$, $$java$$,
           $$Üç koşul var (TopicId, Language, ActiveTrue) ama yalnızca iki parametre var -- ActiveTrue kendi literal boolean değerini sağlar ve TopicId ile Language'dan farklı olarak hiçbir parametre tüketmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir -- yalnızca TopicId gerçekten bir WHERE koşuluna dönüşür$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Dört -- OrderByIdAsc de sıralama yönünü belirten bir parametre gerektirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$İki -- ActiveTrue kendi literal değerini sağlar ve TopicId ile Language'ın aksine hiçbir parametre tüketmez$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Üç -- metot adındaki her koşul için bir tane$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why is existsByTopicIdAndLanguage(...) preferred over findByTopicIdAndLanguage(...).isPresent() when only a presence check is needed?$$,
           NULL, NULL,
           $$existsBy returns a plain boolean from a single SELECT EXISTS(...) query, checking presence without loading a whole entity just to find out.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$existsBy is deprecated in favor of findBy in modern Spring Data JPA$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$existsBy only works on primary-key fields, never on other columns$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It returns a plain boolean from a single SELECT EXISTS(...) query, without loading a whole entity$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$There is no actual difference -- both run the exact same query$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Yalnızca varlık kontrolüne ihtiyaç duyulduğunda, existsByTopicIdAndLanguage(...) neden findByTopicIdAndLanguage(...).isPresent()'e tercih edilir?$$,
           NULL, NULL,
           $$existsBy, bütün bir entity'yi yüklemeden, tek bir SELECT EXISTS(...) sorgusundan sade bir boolean döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek bir fark yoktur -- ikisi de tam olarak aynı sorguyu çalıştırır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Modern Spring Data JPA'da existsBy, findBy lehine kullanımdan kaldırılmıştır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$existsBy yalnızca primary-key alanlarında çalışır, diğer kolonlarda asla çalışmaz$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bütün bir entity'yi yüklemeden, tek bir SELECT EXISTS(...) sorgusundan sade bir boolean döndürür$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe @Query and JPQL by default? (Select all that apply)$$,
           NULL, NULL,
           $$JPQL queries entities and their fields, not tables and columns; a method parameter's own name can bind to a :placeholder by name, without a separate annotation, when the project retains parameter names.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A method parameter's own name can bind to a :placeholder by matching name, with no separate annotation required$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$@Query always means writing real SQL against the actual schema$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$JPQL is executed directly against the database with no translation step involved$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$JPQL queries entities and their fields, like Quiz and q.topic, not tables and columns directly$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Query ve varsayılan JPQL'i doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$JPQL, tabloları ve kolonları değil, entity'leri ve alanlarını sorgular; proje parametre adlarını koruyorsa, bir metot parametresinin kendi adı, ayrı bir annotation olmadan bir :placeholder ile isimle eşleşebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir metot parametresinin kendi adı, ayrı bir annotation gerekmeden isim eşleşmesiyle bir :placeholder'a bağlanabilir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$JPQL, doğrudan tabloları ve kolonları değil, Quiz ve q.topic gibi entity'leri ve alanlarını sorgular$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$@Query her zaman gerçek şemaya karşı gerçek SQL yazmak anlamına gelir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$JPQL, hiçbir dönüştürme adımı olmadan doğrudan veritabanına karşı çalıştırılır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What problem does join fetch in JPQL specifically help avoid?$$,
           NULL, NULL,
           $$It pulls related data back in the SAME query, sidestepping a LazyInitializationException that could occur if the relationship were accessed outside a transaction.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A LazyInitializationException from accessing a relationship outside a transaction$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A compile-time error from an unmapped entity field$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$An OptimisticLockingFailureException from two concurrent updates$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A duplicate-key constraint violation when saving a new entity$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$JPQL'deki join fetch, özellikle hangi sorunun önüne geçmeye yardımcı olur?$$,
           NULL, NULL,
           $$İlişkili veriyi AYNI sorguda geri getirir, bir ilişkiye transaction dışında erişilirse oluşabilecek bir LazyInitializationException'ı önler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yeni bir entity kaydedilirken oluşan bir duplicate-key kısıtlama ihlali$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir ilişkiye transaction dışında erişmekten kaynaklanan bir LazyInitializationException$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Eşlenmemiş bir entity alanından kaynaklanan bir derleme zamanı hatası$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$İki eşzamanlı güncellemeden kaynaklanan bir OptimisticLockingFailureException$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this repository method is called?$$,
           $$@Query("update Question q set q.status = 'REJECTED' where q.status = 'PENDING_REVIEW'")
int rejectAllPendingReview();
// @Modifying is missing entirely$$, $$java$$,
           $$Without @Modifying, Spring Data JPA doesn't know to treat this as a bulk update -- it tries to map the result onto entities and fails.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Data JPA automatically infers @Modifying from the UPDATE keyword in the query text$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It runs successfully, updating every matching row exactly as intended$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Spring Data JPA tries to map the result onto entities and fails, since it doesn't know this is a bulk update$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It silently does nothing, returning 0 with no error at all$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu repository metodu çağrıldığında ne olur?$$,
           $$@Query("update Soru s set s.durum = 'REDDEDILDI' where s.durum = 'INCELEME_BEKLIYOR'")
int tumBekleyenleriReddet();
// @Modifying tamamen eksik$$, $$java$$,
           $$@Modifying olmadan, Spring Data JPA bunu bir bulk update olarak ele alması gerektiğini bilmez -- sonucu entity'lere eşlemeye çalışır ve başarısız olur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sessizce hiçbir şey yapmaz, hiç hata vermeden 0 döndürür$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Spring Data JPA, sorgu metnindeki UPDATE anahtar kelimesinden @Modifying'i otomatik olarak çıkarır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Spring Data JPA, bunun bir bulk update olduğunu bilmediği için sonucu entity'lere eşlemeye çalışır ve başarısız olur$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Başarıyla çalışır, tam olarak amaçlandığı gibi her eşleşen satırı günceller$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe native queries (nativeQuery = true)? (Select all that apply)$$,
           NULL, NULL,
           $$A native query is written against actual tables/columns rather than entities, and ties the code to the actual schema and the specific database's SQL dialect -- it should be reached for only when JPQL genuinely can't express something.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It should be the default choice for every @Query, since it's always faster than JPQL$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It is portable across different database vendors in exactly the same way JPQL is$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It's queried against the actual table and its actual columns, rather than the entity model$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It ties the code to the actual schema and to the specific database's own SQL dialect$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri native query'leri (nativeQuery = true) doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir native query, entity modeli yerine gerçek tablolara/kolonlara karşı yazılır ve kodu gerçek şemaya ve belirli veritabanının SQL dialect'ine bağlar -- yalnızca JPQL'in gerçekten bir şeyi ifade edemediği durumlarda tercih edilmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'query-methods-and-jpql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Entity modeli yerine, gerçek tabloya ve onun gerçek kolonlarına karşı sorgulanır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Kodu gerçek şemaya ve belirli veritabanının kendi SQL dialect'ine bağlar$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Her zaman JPQL'den daha hızlı olduğu için her @Query için varsayılan seçim olmalıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$JPQL ile tamamen aynı şekilde farklı veritabanı sağlayıcıları arasında taşınabilirdir$$, FALSE, 3 FROM new_question_tr7;

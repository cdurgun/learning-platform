-- Promotion batch
-- Topic: service-discovery-eureka (language: en x6, tr x6)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/service-discovery-eureka.md and content/tr/service-discovery-eureka.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 6 CONCEPT PAIRS -- each EN question
-- has a TR counterpart testing the exact same concept, but independently
-- authored (different framing/distractors), not a translation. Every
-- question whose answer depends on shown code/config output is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached).
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
           $$What core problem does Service Discovery solve, per this lesson?$$,
           NULL, NULL,
           $$The lesson defines Service Discovery as letting services find each other by name through a central registry, instead of a fixed, hardcoded address.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It replaces REST with a faster binary protocol$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It lets services find each other by name through a central registry, instead of a fixed, hardcoded address$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It automatically writes unit tests for every microservice$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It merges multiple databases into a single shared one$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Service Discovery hangi temel problemi çözer?$$,
           NULL, NULL,
           $$Ders, Service Discovery'i, servislerin sabit kodlanmış bir adres yerine merkezi bir registry aracılığıyla birbirini isimle bulmasını sağlayan bir desen olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$REST'i daha hızlı bir ikili protokolle değiştirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Servislerin, sabit kodlanmış bir adres yerine merkezi bir registry aracılığıyla birbirini isimle bulmasını sağlar$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her mikroservis için otomatik olarak unit test yazar$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Birden fazla veritabanını tek, paylaşılan bir veritabanında birleştirir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Once order-service becomes a Eureka client, what new role does its spring.application.name value take on?$$,
           NULL, NULL,
           $$The lesson states spring.application.name is no longer just a log label -- it's now the actual key other services use to find it.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$None -- it remains purely a cosmetic log label$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It becomes the actual key other services use to find it in the registry$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It is used only to name the service's database schema$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It determines the service's HTTP port automatically$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$order-service bir Eureka client olduğunda, spring.application.name değeri hangi yeni rolü üstlenir?$$,
           NULL, NULL,
           $$Ders, spring.application.name'in artık yalnızca bir log etiketi olmadığını -- diğer servislerin onu bulmak için kullandığı asıl anahtar hâline geldiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbiri -- tamamen kozmetik bir log etiketi olarak kalır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Diğer servislerin onu registry'de bulmak için kullandığı asıl anahtar hâline gelir$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca servisin veritabanı şemasını adlandırmak için kullanılır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Servisin HTTP portunu otomatik olarak belirler$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Discovering Services with DiscoveryClient," what is DiscoveryClient's actual recommended use case?$$,
           NULL, NULL,
           $$The tip callout states DiscoveryClient is not the right tool for everyday inter-service calls -- its real use case is diagnostics and understanding what the registry currently sees.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Making every routine inter-service business call$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Diagnostics and understanding what the registry currently sees, not everyday calls$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Replacing @LoadBalanced RestClient entirely$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Registering a new service with the Eureka Server$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Discovering Services with DiscoveryClient" bölümüne göre, DiscoveryClient'ın gerçek önerilen kullanım senaryosu nedir?$$,
           NULL, NULL,
           $$İpucu kutusu, DiscoveryClient'ın günlük servisler arası çağrılar için doğru araç olmadığını -- gerçek kullanım senaryosunun teşhis ve registry'nin şu anda ne gördüğünü anlamak olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her rutin servisler arası iş çağrısını yapmak$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Teşhis ve registry'nin şu anda ne gördüğünü anlamak, günlük çağrılar değil$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$@LoadBalanced RestClient'ın yerini tamamen almak$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yeni bir servisi Eureka Server'a kaydetmek$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this call from order-service, with a @LoadBalanced RestClient.Builder bean already configured, what does inventory-service get resolved to at runtime?$$,
           $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$, $$java$$,
           $$The lesson explains @LoadBalanced makes an address like this interpreted as a service name, resolved by Spring Cloud LoadBalancer to a real host:port among registered instances.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A literal DNS hostname called inventory-service, resolved by the OS$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A real host:port picked from the currently registered instances in the Eureka registry$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing -- this URI format is invalid and throws immediately$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$localhost:8080, the default fallback for unresolved names$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$order-service'ten gelen bu çağrı göz önüne alındığında, zaten yapılandırılmış bir @LoadBalanced RestClient.Builder bean'i varken, inventory-service, çalışma zamanında neye çözümlenir?$$,
           $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$, $$java$$,
           $$Ders, @LoadBalanced'ın böyle bir adresi bir servis adı olarak yorumlattığını, Spring Cloud LoadBalancer tarafından kayıtlı instance'lar arasından gerçek bir host:port'a çözümlendiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İşletim sistemi tarafından çözümlenen, inventory-service adlı gerçek bir DNS hostname'i$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Eureka registry'sinde şu anda kayıtlı instance'lardan seçilen gerçek bir host:port$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir şey -- bu URI formatı geçersizdir ve hemen exception fırlatır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$localhost:8080, çözümlenemeyen isimler için varsayılan fallback$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A developer shuts down inventory-service locally, but a few minutes later the Eureka dashboard still shows it as "registered." Per "Heartbeats, Eviction, and Self-Preservation Mode," what's the most likely explanation?$$,
           NULL, NULL,
           $$The warning callout explains this is not a bug -- the Eureka Server has likely entered self-preservation mode, deliberately delaying eviction.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This is always a bug in the Eureka client library$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The Eureka Server has likely entered self-preservation mode, deliberately delaying eviction$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The dashboard is cached and requires a full server restart to refresh$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Eureka evicts instances instantly, so this can never actually happen$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici inventory-service'i yerel olarak kapatıyor, ama birkaç dakika sonra Eureka dashboard'u onu hâlâ "kayıtlı" olarak gösteriyor. "Heartbeats, Eviction, and Self-Preservation Mode" bölümüne göre, en olası açıklama nedir?$$,
           NULL, NULL,
           $$Uyarı kutusu, bunun bir hata olmadığını -- Eureka Server'ın muhtemelen self-preservation mode'a girip eviction'ı kasıtlı olarak geciktirdiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu her zaman Eureka client kütüphanesindeki bir hatadır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Eureka Server muhtemelen self-preservation mode'a girmiştir, eviction'ı kasıtlı olarak geciktirmektedir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Dashboard cache'lenmiştir ve yenilenmesi için tam bir sunucu yeniden başlatması gerekir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Eureka instance'ları anında evict eder, bu yüzden bu gerçekte hiç yaşanamaz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Eureka's position in the CAP theorem, per this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson states Eureka deliberately picks the AP side, and self-preservation mode is a direct consequence of that philosophy.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Eureka deliberately picks the AP side -- it prefers always answering, even from a partially stale registry$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Eureka guarantees the registry is always perfectly up to date, with zero staleness$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Self-preservation mode is a direct consequence of Eureka's AP-leaning philosophy$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Eureka refuses to answer any query during a network partition$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki ifadelerden hangileri, bu derse göre, Eureka'nın CAP teoremindeki konumu hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, Eureka'nın bilinçli olarak AP tarafını seçtiğini, self-preservation mode'un bu felsefenin doğrudan bir sonucu olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$service-discovery-eureka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Eureka bilinçli olarak AP tarafını seçer -- kısmen bayat bir registry'den bile olsa her zaman cevap vermeyi tercih eder$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Eureka, registry'nin her zaman mükemmel şekilde güncel olduğunu, sıfır bayatlık ile garanti eder$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Self-preservation mode, Eureka'nın AP-eğilimli felsefesinin doğrudan bir sonucudur$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Eureka, bir ağ bölünmesi sırasında hiçbir sorguyu yanıtlamayı reddeder$$, FALSE, 3 FROM new_question_tr6;

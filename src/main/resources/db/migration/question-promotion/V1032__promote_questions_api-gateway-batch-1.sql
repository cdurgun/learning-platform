-- Promotion batch
-- Topic: api-gateway (language: en x5, tr x5)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/api-gateway.md and content/tr/api-gateway.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (5 EN + 5 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 5 CONCEPT PAIRS -- each EN question
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
           $$What is the API Gateway's core role, per this lesson?$$,
           NULL, NULL,
           $$The lesson defines an API Gateway as a single entry point that routes external client requests to the correct internal microservice.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Storing the business data for every microservice in one place$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A single entry point that routes external client requests to the correct internal microservice$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Replacing Eureka as the service registry$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Running the actual business logic for order-service and inventory-service$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, API Gateway'in temel rolü nedir?$$,
           NULL, NULL,
           $$Ders, bir API Gateway'i, harici client isteklerini doğru dahili mikroservise yönlendiren tek bir giriş noktası olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her mikroservisin iş verisini tek bir yerde saklamak$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Harici client isteklerini doğru dahili mikroservise yönlendiren tek bir giriş noktası$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Eureka'nın yerini servis registry'si olarak almak$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$order-service ve inventory-service için gerçek iş mantığını çalıştırmak$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What are the three components that together make up a Spring Cloud Gateway route, per this lesson?$$,
           NULL, NULL,
           $$The lesson defines a route as a predicate, a destination URI, and optionally one or more filters.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A controller, a service, and a repository$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A predicate, a destination URI, and optional filters$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A producer, a consumer, and a broker$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$An entity, a DTO, and a mapper$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Spring Cloud Gateway route'unu birlikte oluşturan üç bileşen nedir?$$,
           NULL, NULL,
           $$Ders, bir route'u bir predicate, bir hedef URI, ve isteğe bağlı bir veya daha fazla filtre olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir controller, bir servis, ve bir repository$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir predicate, bir hedef URI, ve isteğe bağlı filtreler$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir producer, bir consumer, ve bir broker$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir entity, bir DTO, ve bir mapper$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this route configuration, what does lb://order-service actually resolve to when a request arrives?$$,
           $$- id: orders-route
  uri: lb://order-service
  predicates:
    - Path=/orders/**
  filters:
    - StripPrefix=0$$, $$yaml$$,
           $$The lesson explains lb:// tells Spring Cloud Gateway to resolve the service name through Eureka and load-balance across registered instances.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A literal, hardcoded hostname called order-service looked up via DNS$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A real host:port, chosen among order-service's currently registered Eureka instances$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A local file path on the gateway's own filesystem$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$An error, since lb:// is not a valid URI scheme in any context$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki route yapılandırması göz önüne alındığında, bir istek geldiğinde lb://order-service gerçekte neye çözümlenir?$$,
           $$- id: orders-route
  uri: lb://order-service
  predicates:
    - Path=/orders/**
  filters:
    - StripPrefix=0$$, $$yaml$$,
           $$Ders, lb://'nin Spring Cloud Gateway'e servis adını Eureka üzerinden çözümlemesini ve kayıtlı instance'lar arasında yük dengelemesini söylediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DNS ile aranan, order-service adlı sabit, gerçek bir hostname$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$order-service'in şu anda kayıtlı Eureka instance'ları arasından seçilen gerçek bir host:port$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Gateway'in kendi dosya sistemindeki yerel bir dosya yolu$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir hata, çünkü lb:// hiçbir bağlamda geçerli bir URI şeması değildir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per the warning under "Writing a Custom Filter," why must a GlobalFilter's filter(...) method never block the calling thread?$$,
           NULL, NULL,
           $$The lesson explains Spring WebFlux runs a small, fixed number of threads shared across every concurrent request -- blocking even one stalls unrelated requests too.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because GlobalFilter methods are limited to a 10-millisecond execution timeout$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Because Spring WebFlux runs a small, fixed number of threads shared across every concurrent request -- blocking one stalls unrelated requests too$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Because blocking calls automatically restart the whole gateway application$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Because Spring MVC (not WebFlux) requires all filters to be asynchronous$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Writing a Custom Filter" bölümündeki uyarıya göre, bir GlobalFilter'ın filter(...) metodu çağıran thread'i neden asla bloke etmemelidir?$$,
           NULL, NULL,
           $$Ders, Spring WebFlux'ın her eşzamanlı istek arasında paylaşılan küçük, sabit sayıda thread çalıştırdığını -- birini bloke etmenin ilgisiz istekleri de durdurduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü GlobalFilter metotları 10 milisaniyelik bir çalışma zaman aşımıyla sınırlıdır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü Spring WebFlux, her eşzamanlı istek arasında paylaşılan küçük, sabit sayıda thread çalıştırır -- birini bloke etmek ilgisiz istekleri de durdurur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü bloklayan çağrılar tüm gateway uygulamasını otomatik olarak yeniden başlatır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü Spring MVC (WebFlux değil) tüm filtrelerin asenkron olmasını gerektirir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as things an API Gateway should NOT do? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson explicitly lists business decisions and response aggregation as out of scope for a plain gateway; routing by name and assigning a correlation id are legitimate gateway responsibilities.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Deciding whether an order is valid (a business decision)$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Routing a request by service name resolved through Eureka$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Aggregating responses from multiple services into a single combined response$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Assigning a correlation id to an incoming request$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste bir API Gateway'in YAPMAMASI gereken şeyler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, iş kararlarını ve yanıt birleştirmeyi açıkça sıradan bir gateway'in kapsamı dışında sayar; adına göre yönlendirme ve correlation id atama ise meşru gateway sorumluluklarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$api-gateway$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir siparişin geçerli olup olmadığına karar vermek (bir iş kararı)$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir isteği, Eureka üzerinden çözümlenen servis adına göre yönlendirmek$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Birden fazla servisten gelen yanıtları tek, birleşik bir yanıtta toplamak$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Gelen bir isteğe bir correlation id atamak$$, FALSE, 3 FROM new_question_tr5;

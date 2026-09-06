-- Promotion batch
-- Topic: inter-service-communication (language: en x7, tr x7)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/inter-service-communication.md and content/tr/inter-service-communication.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 7 CONCEPT PAIRS -- each EN question
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
           $$Why does order-service need to ask inventory-service for stock information instead of reading it from its own database?$$,
           NULL, NULL,
           $$The lesson explains stock data belongs to inventory-service's own bounded context, under the Database per Service principle.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because order-service doesn't have a database of its own at all$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because stock data belongs to inventory-service's own bounded context, under the "Database per Service" principle$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because inventory-service always has faster read performance$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because Spring Boot forbids two services from having the word "service" in their name$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$order-service, envanter bilgisini neden kendi veritabanından okumak yerine inventory-service'e sormak zorundadır?$$,
           NULL, NULL,
           $$Ders, stok verisinin "Database per Service" ilkesi gereği inventory-service'in kendi bounded context'ine ait olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü order-service'in hiç kendi veritabanı yoktur$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü stok verisi, "Database per Service" ilkesi gereği inventory-service'in kendi bounded context'ine aittir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü inventory-service'in okuma performansı her zaman daha hızlıdır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Spring Boot iki servisin adında "service" kelimesinin geçmesini yasaklar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What Spring Framework API does this lesson use for order-service's synchronous call to inventory-service?$$,
           NULL, NULL,
           $$The History section explains RestClient is the modern client already included in spring-boot-starter-web, replacing the older RestTemplate.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$RestTemplate, since it is the only client Spring has ever provided$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$WebClient, requiring an extra spring-webflux dependency$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$RestClient, the modern client already included in spring-boot-starter-web$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A raw java.net.Socket connection, configured manually$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, order-service'in inventory-service'e yaptığı senkron çağrı için hangi Spring Framework API'sini kullanır?$$,
           NULL, NULL,
           $$Tarihçe bölümü, RestClient'ın spring-boot-starter-web içinde zaten bulunan, daha eski RestTemplate'in yerini alan modern istemci olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$RestTemplate, çünkü Spring'in sunduğu tek istemci budur$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$WebClient, ekstra bir spring-webflux bağımlılığı gerektirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$RestClient, spring-boot-starter-web içinde zaten bulunan modern istemci$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Elle yapılandırılan ham bir java.net.Socket bağlantısı$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does StockClient deserialize inventory-service's JSON response into StockCheckResponse, instead of directly into InventoryItem?$$,
           NULL, NULL,
           $$The lesson explains InventoryItem is inventory-service's internal model that can change independently; StockCheckResponse is order-service's own, decoupled contract.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because JSON deserialization technically cannot target a class named InventoryItem$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because InventoryItem is inventory-service's internal model, which could change independently -- StockCheckResponse is order-service's own, decoupled contract$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because InventoryItem doesn't implement Serializable$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because StockCheckResponse and InventoryItem must always share the exact same package$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$StockClient, inventory-service'in JSON yanıtını neden doğrudan InventoryItem'a değil, StockCheckResponse'a deserialize eder?$$,
           NULL, NULL,
           $$Ders, InventoryItem'ın bağımsız olarak değişebilecek inventory-service'in dahili modeli olduğunu, StockCheckResponse'un ise order-service'in kendi, ayrıştırılmış sözleşmesi olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü JSON deserialization teknik olarak InventoryItem adlı bir sınıfı hedefleyemez$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü InventoryItem, bağımsız olarak değişebilecek inventory-service'in dahili modelidir -- StockCheckResponse ise order-service'in kendi, ayrıştırılmış sözleşmesidir$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü InventoryItem, Serializable arayüzünü uygulamaz$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü StockCheckResponse ve InventoryItem her zaman birebir aynı paketi paylaşmak zorundadır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given StockClient.checkStock(...) below, what does order-service receive if inventory-service is UP but has never heard of the requested product (HTTP 404)?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$The lesson explains a 404 is a well-formed "no," not a failure -- a StockCheckResponse with quantityInStock = 0 is returned instead of throwing.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An InventoryServiceUnavailableException is thrown$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A StockCheckResponse with quantityInStock = 0 is returned, no exception propagates$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The method blocks until inventory-service is restarted$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A raw HttpClientErrorException.NotFound propagates to OrderController$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki StockClient.checkStock(...) göz önüne alındığında, inventory-service AYAKTAYSA ama istenen ürünü hiç tanımıyorsa (HTTP 404), order-service ne alır?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$Ders, 404'ün bir başarısızlık değil, iyi biçimlendirilmiş bir "hayır" olduğunu açıklar -- exception fırlatmak yerine quantityInStock = 0 olan bir StockCheckResponse döner.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir InventoryServiceUnavailableException fırlatılır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$quantityInStock = 0 olan bir StockCheckResponse döner, hiçbir exception yayılmaz$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Metot, inventory-service yeniden başlatılana kadar bloke olur$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Ham bir HttpClientErrorException.NotFound, OrderController'a kadar yayılır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Same StockClient.checkStock(...) as below -- this time, inventory-service's process has crashed entirely and the connection times out. What is thrown to OrderService's caller?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$The lesson explains a connection failure raises ResourceAccessException, which StockClient translates into its own InventoryServiceUnavailableException, wrapping the original.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HttpClientErrorException.NotFound$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A StockCheckResponse with quantityInStock = 0, silently$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$InventoryServiceUnavailableException, wrapping the original ResourceAccessException$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Nothing -- the method returns null$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakiyle birebir aynı StockClient.checkStock(...) -- bu kez, inventory-service'in süreci tamamen çökmüş ve bağlantı zaman aşımına uğruyor. OrderService'in çağrısına ne fırlatılır?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$Ders, bir bağlantı hatasının ResourceAccessException fırlattığını, StockClient'ın bunu orijinalini sararak kendi InventoryServiceUnavailableException'ına çevirdiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HttpClientErrorException.NotFound$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$quantityInStock = 0 olan bir StockCheckResponse, sessizce$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Orijinal ResourceAccessException'ı saran bir InventoryServiceUnavailableException$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey -- metot null döner$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Synchronous vs. Asynchronous: What Does This Lesson Cover?", which side of the CAP theorem does this lesson's design choose by making the stock check synchronous and blocking?$$,
           NULL, NULL,
           $$The lesson states order-service never creates an order without being sure about stock, choosing Consistency over Availability.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Partition Tolerance, by refusing to run when the network is down$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Consistency -- order-service never creates an order without being sure about stock, even if that means waiting or failing$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Availability, since the order is always created regardless of the stock check's outcome$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Neither -- CAP theorem only applies to databases, not service calls$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Synchronous vs. Asynchronous: What Does This Lesson Cover?" bölümüne göre, bu dersin stok kontrolünü senkron ve bloklayıcı yapma tasarımı CAP teoreminin hangi tarafını seçer?$$,
           NULL, NULL,
           $$Ders, order-service'in stoktan emin olmadan asla sipariş oluşturmadığını, Consistency'i Availability'e tercih ettiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Partition Tolerance, ağ çöktüğünde çalışmayı reddederek$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Consistency -- order-service, bunun beklemek ya da başarısız olmak anlamına gelse bile, stoktan emin olmadan asla sipariş oluşturmaz$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Availability, çünkü sipariş, stok kontrolünün sonucundan bağımsız olarak her zaman oluşturulur$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbiri -- CAP teoremi yalnızca veritabanlarına uygulanır, servis çağrılarına değil$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when calling another service synchronously? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list hardcoding the address and skipping try/catch as mistakes; hiding the call behind a client class and reading the URL via @Value are the recommended best practices instead.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hardcoding inventory-service's address directly inside order-service's code$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Hiding the call behind a dedicated client class like StockClient$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Leaving a synchronous service call with no try/catch at all$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Reading the target service's base URL from application.yml via @Value$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste başka bir servisi senkron olarak çağırırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi adresi sabit kodlamayı ve try/catch atlamayı hata olarak sayar; çağrıyı bir istemci sınıfının arkasına gizlemek ve URL'i @Value ile okumak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$inter-service-communication$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$inventory-service'in adresini doğrudan order-service'in kodunun içine sabit kodlamak$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Çağrıyı StockClient gibi özel bir istemci sınıfının arkasına gizlemek$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Senkron bir servis çağrısını hiçbir try/catch olmadan bırakmak$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Hedef servisin base URL'ini @Value aracılığıyla application.yml'den okumak$$, FALSE, 3 FROM new_question_tr7;

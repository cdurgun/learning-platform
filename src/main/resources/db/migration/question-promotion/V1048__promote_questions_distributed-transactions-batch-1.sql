-- Promotion batch
-- Topic: distributed-transactions (language: en x6, tr x6)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/distributed-transactions.md and content/tr/distributed-transactions.md -- NOT produced by n8n,
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
           $$Why can't order-service and inventory-service simply share one database transaction when placing an order?$$,
           NULL, NULL,
           $$The lesson explains database per service means each has its own, separate database, with no single transaction spanning both.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Spring Boot technically forbids more than one transaction per application$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because "database per service" means each has its own, separate database, with no single transaction spanning both$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because transactions are only supported on Mondays through Fridays in production$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because order-service doesn't use a relational database at all$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$order-service ve inventory-service, bir sipariş verirken neden basitçe tek bir veritabanı transaction'ını paylaşamaz?$$,
           NULL, NULL,
           $$Ders, "database per service"'in, her birinin ikisini de kapsayan tek bir transaction olmadan kendi, ayrı veritabanına sahip olduğu anlamına geldiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Spring Boot teknik olarak uygulama başına birden fazla transaction'ı yasaklar$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü "database per service", her birinin ikisini de kapsayan tek bir transaction olmadan kendi, ayrı veritabanına sahip olduğu anlamına gelir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü transaction'lar production'da yalnızca Pazartesi'den Cuma'ya desteklenir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü order-service hiç ilişkisel bir veritabanı kullanmaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Two-Phase Commit: Why Microservices Usually Avoid It," what is the real cost that makes 2PC unpopular in microservices, even though it's historically "correct"?$$,
           NULL, NULL,
           $$The lesson explains every participant stays locked from the prepare phase until final commit, and can be left blocked indefinitely if the coordinator crashes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2PC cannot technically be implemented in any programming language released after 2010$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Every participant stays locked from the prepare phase until final commit, and can be left blocked indefinitely if the coordinator crashes$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$2PC requires every service to be written in the exact same programming language$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$2PC is incompatible with the HTTP protocol entirely$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Two-Phase Commit: Why Microservices Usually Avoid It" bölümüne göre, 2PC tarihsel olarak "doğru" olsa bile onu mikroservislerde popüler olmaktan çıkaran gerçek maliyet nedir?$$,
           NULL, NULL,
           $$Ders, her katılımcının prepare aşamasından nihai commit'e kadar kilitli kaldığını, ve koordinatör çökerse süresiz olarak bloke edilmiş kalabileceğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2PC, teknik olarak 2010'dan sonra yayınlanan hiçbir programlama dilinde uygulanamaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her katılımcı, prepare aşamasından nihai commit'e kadar kilitli kalır, ve koordinatör çökerse süresiz olarak bloke edilmiş kalabilir$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$2PC, her servisin birebir aynı programlama dilinde yazılmasını gerektirir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$2PC, HTTP protokolüyle tamamen uyumsuzdur$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Compensating Actions: Undoing What Already Happened," why is a compensating action NOT the same as a database rollback?$$,
           NULL, NULL,
           $$The lesson explains order-service's original transaction already committed successfully -- compensation is a new, separate local transaction that moves to a corrected state.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because compensating actions are always slower than a rollback$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because order-service's original transaction already committed successfully -- compensation is a new, separate local transaction that moves to a corrected state$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because rollbacks are only possible in NoSQL databases$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because compensating actions require restarting the entire service$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Compensating Actions: Undoing What Already Happened" bölümüne göre, bir compensating action neden bir veritabanı rollback'i ile aynı şey DEĞİLDİR?$$,
           NULL, NULL,
           $$Ders, order-service'in orijinal transaction'ının zaten başarıyla commit edildiğini -- compensation'ın düzeltilmiş bir duruma geçen yeni, ayrı bir local transaction olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü compensating action'lar her zaman bir rollback'ten daha yavaştır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü order-service'in orijinal transaction'ı zaten başarıyla commit edilmiştir -- compensation, düzeltilmiş bir duruma geçen yeni, ayrı bir local transaction'dır$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü rollback'ler yalnızca NoSQL veritabanlarında mümkündür$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü compensating action'lar tüm servisin yeniden başlatılmasını gerektirir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given InventoryReservationListener's actual code below (with the real database call commented out), will StockReservationFailedEvent ever actually be published when this exact code runs?$$,
           $$private boolean tryReserveStock(String productName, int quantity) {
    // return stockRepository.tryReserve(productName, quantity);
    return true;
}

void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;
    boolean reserved = tryReserveStock(event.productName(), event.quantity());
    if (!reserved) {
        kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(), ...);
    }
}$$, $$java$$,
           $$The real InventoryReservationListener.java shows tryReserveStock is a stub hardcoded to return true, so reserved is always true and the if (!reserved) branch never executes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes, roughly half the time, at random$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$No -- tryReserveStock is hardcoded to always return true, so reserved is always true and the if (!reserved) branch never executes$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, but only on the very first call for each orderId$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, every single time, since the real database call is commented out$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki InventoryReservationListener'ın gerçek kodu göz önüne alındığında (gerçek veritabanı çağrısı yorum satırına alınmışken), bu birebir kod çalıştığında StockReservationFailedEvent gerçekte hiç yayınlanır mı?$$,
           $$private boolean tryReserveStock(String productName, int quantity) {
    // return stockRepository.tryReserve(productName, quantity);
    return true;
}

void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;
    boolean reserved = tryReserveStock(event.productName(), event.quantity());
    if (!reserved) {
        kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(), ...);
    }
}$$, $$java$$,
           $$Gerçek InventoryReservationListener.java, tryReserveStock'un her zaman true döndürecek şekilde sabit kodlanmış bir stub olduğunu, bu yüzden reserved'ın her zaman true olduğunu ve if (!reserved) dalının hiçbir zaman çalışmadığını gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, kabaca yarı yarıya, rastgele$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- tryReserveStock, her zaman true döndürecek şekilde sabit kodlanmıştır, bu yüzden reserved her zaman true'dur ve if (!reserved) dalı hiçbir zaman çalışmaz$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ama yalnızca her orderId için ilk çağrıda$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, her seferinde, çünkü gerçek veritabanı çağrısı yorum satırına alınmıştır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "The Outbox Pattern: Not Losing an Event to a Crash," what real gap does the Outbox pattern close?$$,
           NULL, NULL,
           $$The lesson explains the gap where order-service crashes between saving an order and publishing the event announcing it, so the event is lost even though the order exists.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The gap between two services using different serialization formats$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The gap where order-service crashes between saving an order and publishing the event announcing it, so the event is lost even though the order exists$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The gap between Kafka and a relational database's SQL syntax$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The gap caused by Eureka's self-preservation mode delaying eviction$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"The Outbox Pattern: Not Losing an Event to a Crash" bölümüne göre, Outbox pattern hangi gerçek boşluğu kapatır?$$,
           NULL, NULL,
           $$Ders, order-service'in bir siparişi kaydetme ile onu duyuran event'i yayınlama arasında çökmesi durumunda, sipariş var olsa bile event'in kaybolması boşluğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki servisin farklı serialization formatları kullanması arasındaki boşluk$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$order-service'in bir siparişi kaydetme ile onu duyuran event'i yayınlama arasında çökmesi durumunda, sipariş var olsa bile event'in kaybolması boşluğu$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Kafka ile ilişkisel bir veritabanının SQL sözdizimi arasındaki boşluk$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Eureka'nın self-preservation mode'unun eviction'ı geciktirmesinin neden olduğu boşluk$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine best practices for sagas? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson recommends choreography for short sagas and checking current state before compensating; reaching for 2PC by default and treating a saga as atomic from the caller's view are explicitly listed mistakes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Prefer choreography for short sagas (two or three steps), orchestration once a saga grows past that$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Reach for Two-Phase Commit as the default solution for any distributed transaction$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Check an entity's current state before applying a compensating action to it$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Treat a saga as a single atomic operation from the caller's perspective$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste saga'lar için gerçek en iyi pratikler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, kısa saga'lar için choreography'i ve compensating action'dan önce mevcut durumu kontrol etmeyi önerir; 2PC'ye varsayılan olarak başvurmak ve bir saga'yı çağıranın bakış açısından atomik saymak ise açıkça hata olarak listelenir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$distributed-transactions$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kısa saga'lar (iki veya üç adım) için choreography'i, saga bunu aştığında orchestration'ı tercih etmek$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Herhangi bir distributed transaction için varsayılan çözüm olarak Two-Phase Commit'e başvurmak$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir entity'ye compensating action uygulamadan önce mevcut durumunu kontrol etmek$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir saga'yı, çağıranın bakış açısından tek, atomik bir işlem olarak ele almak$$, FALSE, 3 FROM new_question_tr6;

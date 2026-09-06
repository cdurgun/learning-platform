-- Promotion batch
-- Topic: event-driven-kafka (language: en x6, tr x6)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/event-driven-kafka.md and content/tr/event-driven-kafka.md -- NOT produced by n8n,
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
           $$What is the core difference between event-driven communication and the synchronous calls covered earlier in this course?$$,
           NULL, NULL,
           $$The lesson explains the publisher never blocks waiting for a reaction, and often doesn't even know which services are listening.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Events always require more code to write than a synchronous REST call$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The publisher never blocks waiting for a reaction, and often doesn't even know which services are listening$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Events can only be used between services written in the same programming language$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Events guarantee an immediate response, exactly like a synchronous call$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Event-driven iletişim ile bu kursta daha önce ele alınan senkron çağrılar arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, yayıncının (publisher), bir tepki için beklerken asla bloke olmadığını, ve genellikle hangi servislerin dinlediğini bile bilmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Olaylar (event'ler), senkron bir REST çağrısından her zaman daha fazla kod yazmayı gerektirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yayıncı (publisher), bir tepki için beklerken asla bloke olmaz, ve genellikle hangi servislerin dinlediğini bile bilmez$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Olaylar yalnızca aynı programlama dilinde yazılmış servisler arasında kullanılabilir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Olaylar, tam olarak senkron bir çağrı gibi anında bir yanıt garanti eder$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Setting Up Kafka (Broker) and Topics," within what scope does Kafka actually guarantee message ordering?$$,
           NULL, NULL,
           $$The lesson states Kafka guarantees ordering only within a single partition, not across the whole topic.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Across the entire topic, regardless of how many partitions it has$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Only within a single partition, not across the whole topic$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Only for messages published in the same calendar day$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Kafka never guarantees ordering under any circumstances$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Setting Up Kafka (Broker) and Topics" bölümüne göre, Kafka mesaj sıralamasını gerçekte hangi kapsamda garanti eder?$$,
           NULL, NULL,
           $$Ders, Kafka'nın sıralamayı yalnızca tek bir partition içinde, tüm topic genelinde değil, garanti ettiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kaç partition'ı olduğundan bağımsız olarak, tüm topic genelinde$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca tek bir partition içinde, tüm topic genelinde değil$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca aynı takvim gününde yayınlanan mesajlar için$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Kafka hiçbir koşulda sıralamayı garanti etmez$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this listener, if Kafka redelivers the exact same OrderPlacedEvent (same orderId) a second time after a restart, what happens on the second delivery?$$,
           $$private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) {
        return;
    }
    // stockRepository.decrease(event.productName(), event.quantity());
}$$, $$java$$,
           $$The real InventoryEventListener.java shows processedOrderIds.add(...) returns false on a duplicate id, so the method returns early and stock is not decreased again.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Stock is decreased a second time, since processedOrderIds is cleared on every new message$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$processedOrderIds.add(...) returns false, the method returns early, and stock is not decreased again$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The application throws a DuplicateEventException and stops consuming$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The event is silently dropped by Kafka itself before reaching this method$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki listener göz önüne alındığında, Kafka bir yeniden başlatmadan sonra birebir aynı OrderPlacedEvent'i (aynı orderId) ikinci kez yeniden gönderirse, ikinci teslimatta ne olur?$$,
           $$private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) {
        return;
    }
    // stockRepository.decrease(event.productName(), event.quantity());
}$$, $$java$$,
           $$Gerçek InventoryEventListener.java, processedOrderIds.add(...)'in bir tekrar id'de false döndürdüğünü, bu yüzden metodun erken döndüğünü ve stoğun tekrar azaltılmadığını gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$processedOrderIds, her yeni mesajda temizlendiği için stok ikinci kez azaltılır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$processedOrderIds.add(...), false döner, metot erken döner, ve stok tekrar azaltılmaz$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Uygulama bir DuplicateEventException fırlatır ve tüketmeyi durdurur$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Olay, bu metoda ulaşmadan önce Kafka'nın kendisi tarafından sessizce düşürülür$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Synchronous vs. Asynchronous: When to Use Which," which of these two questions genuinely needs a synchronous call rather than an event?$$,
           NULL, NULL,
           $$The lesson states a question needing an immediate answer -- like current stock level to show a customer -- needs a synchronous call, unlike a fact that doesn't need an immediate reaction.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"An order was placed, eventually update inventory records"$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$"Is this product in stock right now, so I can show the customer an answer immediately?"$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$"Notify whoever cares that something happened, eventually"$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Neither -- this lesson claims events should always replace synchronous calls entirely$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Synchronous vs. Asynchronous: When to Use Which" bölümüne göre, aşağıdaki iki sorudan hangisi gerçekten bir event yerine senkron bir çağrıya ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, anında bir cevap gerektiren bir sorunun -- müşteriye göstermek için mevcut stok seviyesi gibi -- senkron bir çağrı gerektirdiğini, anında bir tepki gerektirmeyen bir gerçeğin aksine, açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"Bir sipariş verildi, eninde sonunda envanter kayıtlarını güncelle"$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$"Bu ürün şu anda stokta mı, ki müşteriye hemen bir cevap gösterebileyim?"$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$"Bir şey olduğunu önemseyen herkese, eninde sonunda haber ver"$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbiri -- bu ders, event'lerin her zaman senkron çağrıların tamamen yerini alması gerektiğini iddia eder$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per "Serialization: Why JSON Over the Wire," why does this lesson choose JSON for OrderPlacedEvent, rather than a binary format like Avro?$$,
           NULL, NULL,
           $$The lesson explains JSON is human-readable, works across any language a future consumer might use, and needs no extra tooling to inspect.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Kafka technically cannot transmit binary data of any kind$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because it's human-readable, works across any language a future consumer might use, and needs no extra tooling to inspect$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because JSON messages are always smaller than Avro messages$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Because @KafkaListener only supports JSON and no other format whatsoever$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Serialization: Why JSON Over the Wire" bölümüne göre, bu ders OrderPlacedEvent için Avro gibi ikili bir format yerine neden JSON'u seçer?$$,
           NULL, NULL,
           $$Ders, JSON'un insan tarafından okunabilir olduğunu, gelecekteki bir tüketicinin kullanabileceği herhangi bir dilde çalıştığını, ve incelemek için ekstra bir araç gerektirmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Kafka teknik olarak hiçbir türde ikili veri iletemez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü insan tarafından okunabilir, gelecekteki bir tüketicinin kullanabileceği herhangi bir dilde çalışır, ve incelemek için ekstra bir araç gerektirmez$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü JSON mesajları her zaman Avro mesajlarından daha küçüktür$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü @KafkaListener yalnızca JSON'u destekler, başka hiçbir formatı desteklemez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes in event-driven design? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list a non-idempotent consumer and assuming unlimited partition scaling as mistakes; keying by a meaningful id and treating event shape as a contract are the recommended best practices.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Writing a Kafka consumer that isn't idempotent$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Keying events by an id that determines what ordering actually matters for$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Assuming a single Kafka topic and partition scales indefinitely$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Treating an event's shape as a public contract other consumers depend on$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste event-driven tasarımda yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi idempotent olmayan bir tüketiciyi ve sınırsız partition ölçeklenmesini varsaymayı hata olarak sayar; anlamlı bir id'ye göre keylemek ve event şeklini bir sözleşme olarak ele almak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$event-driven-kafka$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İdempotent olmayan bir Kafka tüketicisi (consumer) yazmak$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Olayları, gerçekte hangi sıralamanın önemli olduğunu belirleyen bir id'ye göre keylemek$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tek bir Kafka topic'inin ve partition'ının sonsuza kadar ölçekleneceğini varsaymak$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir event'in şeklini, diğer tüketicilerin bağımlı olduğu genel bir sözleşme olarak ele almak$$, FALSE, 3 FROM new_question_tr6;

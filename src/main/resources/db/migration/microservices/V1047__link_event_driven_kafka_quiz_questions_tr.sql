-- Promotion-style migration linking TR event-driven-kafka quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/6 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Event-driven iletişim ile bu kursta daha önce ele alınan senkron çağrılar arasındaki temel fark nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Event-driven iletişim ile bu kursta daha önce ele alınan senkron çağrılar arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, yayıncının (publisher), bir tepki için beklerken asla bloke olmadığını, ve genellikle hangi servislerin dinlediğini bile bilmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$Olaylar (event'ler), senkron bir REST çağrısından her zaman daha fazla kod yazmayı gerektirir$$, FALSE, 0),
    ($$Yayıncı (publisher), bir tepki için beklerken asla bloke olmaz, ve genellikle hangi servislerin dinlediğini bile bilmez$$, TRUE, 1),
    ($$Olaylar yalnızca aynı programlama dilinde yazılmış servisler arasında kullanılabilir$$, FALSE, 2),
    ($$Olaylar, tam olarak senkron bir çağrı gibi anında bir yanıt garanti eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Setting Up Kafka (Broker) and Topics" bölümüne göre, Kafka mesaj sıralamasını gerçekte hangi kapsamda garanti eder?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Setting Up Kafka (Broker) and Topics" bölümüne göre, Kafka mesaj sıralamasını gerçekte hangi kapsamda garanti eder?$$,
           NULL, NULL,
           $$Ders, Kafka'nın sıralamayı yalnızca tek bir partition içinde, tüm topic genelinde değil, garanti ettiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$Kaç partition'ı olduğundan bağımsız olarak, tüm topic genelinde$$, FALSE, 0),
    ($$Yalnızca tek bir partition içinde, tüm topic genelinde değil$$, TRUE, 1),
    ($$Yalnızca aynı takvim gününde yayınlanan mesajlar için$$, FALSE, 2),
    ($$Kafka hiçbir koşulda sıralamayı garanti etmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki listener göz önüne alındığında, Kafka bir yeniden başlatmadan sonra birebir aynı OrderPlacedEvent'i (aynı orderId) ikinci kez yeniden gönderirse, ikinci teslimatta ne olur?$$
      AND code_snippet = $$private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) {
        return;
    }
    // stockRepository.decrease(event.productName(), event.quantity());
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$processedOrderIds, her yeni mesajda temizlendiği için stok ikinci kez azaltılır$$, FALSE, 0),
    ($$processedOrderIds.add(...), false döner, metot erken döner, ve stok tekrar azaltılmaz$$, TRUE, 1),
    ($$Uygulama bir DuplicateEventException fırlatır ve tüketmeyi durdurur$$, FALSE, 2),
    ($$Olay, bu metoda ulaşmadan önce Kafka'nın kendisi tarafından sessizce düşürülür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Synchronous vs. Asynchronous: When to Use Which" bölümüne göre, aşağıdaki iki sorudan hangisi gerçekten bir event yerine senkron bir çağrıya ihtiyaç duyar?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Synchronous vs. Asynchronous: When to Use Which" bölümüne göre, aşağıdaki iki sorudan hangisi gerçekten bir event yerine senkron bir çağrıya ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, anında bir cevap gerektiren bir sorunun -- müşteriye göstermek için mevcut stok seviyesi gibi -- senkron bir çağrı gerektirdiğini, anında bir tepki gerektirmeyen bir gerçeğin aksine, açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$"Bir sipariş verildi, eninde sonunda envanter kayıtlarını güncelle"$$, FALSE, 0),
    ($$"Bu ürün şu anda stokta mı, ki müşteriye hemen bir cevap gösterebileyim?"$$, TRUE, 1),
    ($$"Bir şey olduğunu önemseyen herkese, eninde sonunda haber ver"$$, FALSE, 2),
    ($$Hiçbiri -- bu ders, event'lerin her zaman senkron çağrıların tamamen yerini alması gerektiğini iddia eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Serialization: Why JSON Over the Wire" bölümüne göre, bu ders OrderPlacedEvent için Avro gibi ikili bir format yerine neden JSON'u seçer?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Serialization: Why JSON Over the Wire" bölümüne göre, bu ders OrderPlacedEvent için Avro gibi ikili bir format yerine neden JSON'u seçer?$$,
           NULL, NULL,
           $$Ders, JSON'un insan tarafından okunabilir olduğunu, gelecekteki bir tüketicinin kullanabileceği herhangi bir dilde çalıştığını, ve incelemek için ekstra bir araç gerektirmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$Çünkü Kafka teknik olarak hiçbir türde ikili veri iletemez$$, FALSE, 0),
    ($$Çünkü insan tarafından okunabilir, gelecekteki bir tüketicinin kullanabileceği herhangi bir dilde çalışır, ve incelemek için ekstra bir araç gerektirmez$$, TRUE, 1),
    ($$Çünkü JSON mesajları her zaman Avro mesajlarından daha küçüktür$$, FALSE, 2),
    ($$Çünkü @KafkaListener yalnızca JSON'u destekler, başka hiçbir formatı desteklemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (TR pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste event-driven tasarımda yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste event-driven tasarımda yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi idempotent olmayan bir tüketiciyi ve sınırsız partition ölçeklenmesini varsaymayı hata olarak sayar; anlamlı bir id'ye göre keylemek ve event şeklini bir sözleşme olarak ele almak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$İdempotent olmayan bir Kafka tüketicisi (consumer) yazmak$$, TRUE, 0),
    ($$Olayları, gerçekte hangi sıralamanın önemli olduğunu belirleyen bir id'ye göre keylemek$$, FALSE, 1),
    ($$Tek bir Kafka topic'inin ve partition'ının sonsuza kadar ölçekleneceğini varsaymak$$, TRUE, 2),
    ($$Bir event'in şeklini, diğer tüketicilerin bağımlı olduğu genel bir sözleşme olarak ele almak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

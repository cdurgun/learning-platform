-- Promotion-style migration linking TR distributed-transactions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/6 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service ve inventory-service, bir sipariş verirken neden basitçe tek bir veritabanı transaction'ını paylaşamaz?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$order-service ve inventory-service, bir sipariş verirken neden basitçe tek bir veritabanı transaction'ını paylaşamaz?$$,
           NULL, NULL,
           $$Ders, "database per service"'in, her birinin ikisini de kapsayan tek bir transaction olmadan kendi, ayrı veritabanına sahip olduğu anlamına geldiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Çünkü Spring Boot teknik olarak uygulama başına birden fazla transaction'ı yasaklar$$, FALSE, 0),
    ($$Çünkü "database per service", her birinin ikisini de kapsayan tek bir transaction olmadan kendi, ayrı veritabanına sahip olduğu anlamına gelir$$, TRUE, 1),
    ($$Çünkü transaction'lar production'da yalnızca Pazartesi'den Cuma'ya desteklenir$$, FALSE, 2),
    ($$Çünkü order-service hiç ilişkisel bir veritabanı kullanmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Two-Phase Commit: Why Microservices Usually Avoid It" bölümüne göre, 2PC tarihsel olarak "doğru" olsa bile onu mikroservislerde popüler olmaktan çıkaran gerçek maliyet nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Two-Phase Commit: Why Microservices Usually Avoid It" bölümüne göre, 2PC tarihsel olarak "doğru" olsa bile onu mikroservislerde popüler olmaktan çıkaran gerçek maliyet nedir?$$,
           NULL, NULL,
           $$Ders, her katılımcının prepare aşamasından nihai commit'e kadar kilitli kaldığını, ve koordinatör çökerse süresiz olarak bloke edilmiş kalabileceğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$2PC, teknik olarak 2010'dan sonra yayınlanan hiçbir programlama dilinde uygulanamaz$$, FALSE, 0),
    ($$Her katılımcı, prepare aşamasından nihai commit'e kadar kilitli kalır, ve koordinatör çökerse süresiz olarak bloke edilmiş kalabilir$$, TRUE, 1),
    ($$2PC, her servisin birebir aynı programlama dilinde yazılmasını gerektirir$$, FALSE, 2),
    ($$2PC, HTTP protokolüyle tamamen uyumsuzdur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Compensating Actions: Undoing What Already Happened" bölümüne göre, bir compensating action neden bir veritabanı rollback'i ile aynı şey DEĞİLDİR?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Compensating Actions: Undoing What Already Happened" bölümüne göre, bir compensating action neden bir veritabanı rollback'i ile aynı şey DEĞİLDİR?$$,
           NULL, NULL,
           $$Ders, order-service'in orijinal transaction'ının zaten başarıyla commit edildiğini -- compensation'ın düzeltilmiş bir duruma geçen yeni, ayrı bir local transaction olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Çünkü compensating action'lar her zaman bir rollback'ten daha yavaştır$$, FALSE, 0),
    ($$Çünkü order-service'in orijinal transaction'ı zaten başarıyla commit edilmiştir -- compensation, düzeltilmiş bir duruma geçen yeni, ayrı bir local transaction'dır$$, TRUE, 1),
    ($$Çünkü rollback'ler yalnızca NoSQL veritabanlarında mümkündür$$, FALSE, 2),
    ($$Çünkü compensating action'lar tüm servisin yeniden başlatılmasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (TR pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki InventoryReservationListener'ın gerçek kodu göz önüne alındığında (gerçek veritabanı çağrısı yorum satırına alınmışken), bu birebir kod çalıştığında StockReservationFailedEvent gerçekte hiç yayınlanır mı?$$
      AND code_snippet = $$private boolean tryReserveStock(String productName, int quantity) {
    // return stockRepository.tryReserve(productName, quantity);
    return true;
}

void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;
    boolean reserved = tryReserveStock(event.productName(), event.quantity());
    if (!reserved) {
        kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(), ...);
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Evet, kabaca yarı yarıya, rastgele$$, FALSE, 0),
    ($$Hayır -- tryReserveStock, her zaman true döndürecek şekilde sabit kodlanmıştır, bu yüzden reserved her zaman true'dur ve if (!reserved) dalı hiçbir zaman çalışmaz$$, TRUE, 1),
    ($$Evet, ama yalnızca her orderId için ilk çağrıda$$, FALSE, 2),
    ($$Evet, her seferinde, çünkü gerçek veritabanı çağrısı yorum satırına alınmıştır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"The Outbox Pattern: Not Losing an Event to a Crash" bölümüne göre, Outbox pattern hangi gerçek boşluğu kapatır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"The Outbox Pattern: Not Losing an Event to a Crash" bölümüne göre, Outbox pattern hangi gerçek boşluğu kapatır?$$,
           NULL, NULL,
           $$Ders, order-service'in bir siparişi kaydetme ile onu duyuran event'i yayınlama arasında çökmesi durumunda, sipariş var olsa bile event'in kaybolması boşluğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$İki servisin farklı serialization formatları kullanması arasındaki boşluk$$, FALSE, 0),
    ($$order-service'in bir siparişi kaydetme ile onu duyuran event'i yayınlama arasında çökmesi durumunda, sipariş var olsa bile event'in kaybolması boşluğu$$, TRUE, 1),
    ($$Kafka ile ilişkisel bir veritabanının SQL sözdizimi arasındaki boşluk$$, FALSE, 2),
    ($$Eureka'nın self-preservation mode'unun eviction'ı geciktirmesinin neden olduğu boşluk$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (TR pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste saga'lar için gerçek en iyi pratikler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste saga'lar için gerçek en iyi pratikler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, kısa saga'lar için choreography'i ve compensating action'dan önce mevcut durumu kontrol etmeyi önerir; 2PC'ye varsayılan olarak başvurmak ve bir saga'yı çağıranın bakış açısından atomik saymak ise açıkça hata olarak listelenir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Kısa saga'lar (iki veya üç adım) için choreography'i, saga bunu aştığında orchestration'ı tercih etmek$$, TRUE, 0),
    ($$Herhangi bir distributed transaction için varsayılan çözüm olarak Two-Phase Commit'e başvurmak$$, FALSE, 1),
    ($$Bir entity'ye compensating action uygulamadan önce mevcut durumunu kontrol etmek$$, TRUE, 2),
    ($$Bir saga'yı, çağıranın bakış açısından tek, atomik bir işlem olarak ele almak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

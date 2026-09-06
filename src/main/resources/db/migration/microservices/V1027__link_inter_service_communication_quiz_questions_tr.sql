-- Promotion-style migration linking TR inter-service-communication quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/7 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service, envanter bilgisini neden kendi veritabanından okumak yerine inventory-service'e sormak zorundadır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$order-service, envanter bilgisini neden kendi veritabanından okumak yerine inventory-service'e sormak zorundadır?$$,
           NULL, NULL,
           $$Ders, stok verisinin "Database per Service" ilkesi gereği inventory-service'in kendi bounded context'ine ait olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Çünkü order-service'in hiç kendi veritabanı yoktur$$, FALSE, 0),
    ($$Çünkü stok verisi, "Database per Service" ilkesi gereği inventory-service'in kendi bounded context'ine aittir$$, TRUE, 1),
    ($$Çünkü inventory-service'in okuma performansı her zaman daha hızlıdır$$, FALSE, 2),
    ($$Çünkü Spring Boot iki servisin adında "service" kelimesinin geçmesini yasaklar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, order-service'in inventory-service'e yaptığı senkron çağrı için hangi Spring Framework API'sini kullanır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, order-service'in inventory-service'e yaptığı senkron çağrı için hangi Spring Framework API'sini kullanır?$$,
           NULL, NULL,
           $$Tarihçe bölümü, RestClient'ın spring-boot-starter-web içinde zaten bulunan, daha eski RestTemplate'in yerini alan modern istemci olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$RestTemplate, çünkü Spring'in sunduğu tek istemci budur$$, FALSE, 0),
    ($$WebClient, ekstra bir spring-webflux bağımlılığı gerektirir$$, FALSE, 1),
    ($$RestClient, spring-boot-starter-web içinde zaten bulunan modern istemci$$, TRUE, 2),
    ($$Elle yapılandırılan ham bir java.net.Socket bağlantısı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$StockClient, inventory-service'in JSON yanıtını neden doğrudan InventoryItem'a değil, StockCheckResponse'a deserialize eder?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$StockClient, inventory-service'in JSON yanıtını neden doğrudan InventoryItem'a değil, StockCheckResponse'a deserialize eder?$$,
           NULL, NULL,
           $$Ders, InventoryItem'ın bağımsız olarak değişebilecek inventory-service'in dahili modeli olduğunu, StockCheckResponse'un ise order-service'in kendi, ayrıştırılmış sözleşmesi olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Çünkü JSON deserialization teknik olarak InventoryItem adlı bir sınıfı hedefleyemez$$, FALSE, 0),
    ($$Çünkü InventoryItem, bağımsız olarak değişebilecek inventory-service'in dahili modelidir -- StockCheckResponse ise order-service'in kendi, ayrıştırılmış sözleşmesidir$$, TRUE, 1),
    ($$Çünkü InventoryItem, Serializable arayüzünü uygulamaz$$, FALSE, 2),
    ($$Çünkü StockCheckResponse ve InventoryItem her zaman birebir aynı paketi paylaşmak zorundadır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (TR pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki StockClient.checkStock(...) göz önüne alındığında, inventory-service AYAKTAYSA ama istenen ürünü hiç tanımıyorsa (HTTP 404), order-service ne alır?$$
      AND code_snippet = $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Bir InventoryServiceUnavailableException fırlatılır$$, FALSE, 0),
    ($$quantityInStock = 0 olan bir StockCheckResponse döner, hiçbir exception yayılmaz$$, TRUE, 1),
    ($$Metot, inventory-service yeniden başlatılana kadar bloke olur$$, FALSE, 2),
    ($$Ham bir HttpClientErrorException.NotFound, OrderController'a kadar yayılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (TR pair 5, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakiyle birebir aynı StockClient.checkStock(...) -- bu kez, inventory-service'in süreci tamamen çökmüş ve bağlantı zaman aşımına uğruyor. OrderService'in çağrısına ne fırlatılır?$$
      AND code_snippet = $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$HttpClientErrorException.NotFound$$, FALSE, 0),
    ($$quantityInStock = 0 olan bir StockCheckResponse, sessizce$$, FALSE, 1),
    ($$Orijinal ResourceAccessException'ı saran bir InventoryServiceUnavailableException$$, TRUE, 2),
    ($$Hiçbir şey -- metot null döner$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (TR pair 6, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Synchronous vs. Asynchronous: What Does This Lesson Cover?" bölümüne göre, bu dersin stok kontrolünü senkron ve bloklayıcı yapma tasarımı CAP teoreminin hangi tarafını seçer?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Synchronous vs. Asynchronous: What Does This Lesson Cover?" bölümüne göre, bu dersin stok kontrolünü senkron ve bloklayıcı yapma tasarımı CAP teoreminin hangi tarafını seçer?$$,
           NULL, NULL,
           $$Ders, order-service'in stoktan emin olmadan asla sipariş oluşturmadığını, Consistency'i Availability'e tercih ettiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Partition Tolerance, ağ çöktüğünde çalışmayı reddederek$$, FALSE, 0),
    ($$Consistency -- order-service, bunun beklemek ya da başarısız olmak anlamına gelse bile, stoktan emin olmadan asla sipariş oluşturmaz$$, TRUE, 1),
    ($$Availability, çünkü sipariş, stok kontrolünün sonucundan bağımsız olarak her zaman oluşturulur$$, FALSE, 2),
    ($$Hiçbiri -- CAP teoremi yalnızca veritabanlarına uygulanır, servis çağrılarına değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (TR pair 7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste başka bir servisi senkron olarak çağırırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste başka bir servisi senkron olarak çağırırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi adresi sabit kodlamayı ve try/catch atlamayı hata olarak sayar; çağrıyı bir istemci sınıfının arkasına gizlemek ve URL'i @Value ile okumak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$inventory-service'in adresini doğrudan order-service'in kodunun içine sabit kodlamak$$, TRUE, 0),
    ($$Çağrıyı StockClient gibi özel bir istemci sınıfının arkasına gizlemek$$, FALSE, 1),
    ($$Senkron bir servis çağrısını hiçbir try/catch olmadan bırakmak$$, TRUE, 2),
    ($$Hedef servisin base URL'ini @Value aracılığıyla application.yml'den okumak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

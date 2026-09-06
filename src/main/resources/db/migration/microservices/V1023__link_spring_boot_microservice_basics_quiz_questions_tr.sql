-- Promotion-style migration linking TR spring-boot-microservice-basics quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/7 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service'in, learning-platform'unkinden ayrı, kendi application.yml'ine neden ihtiyacı vardır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$order-service'in, learning-platform'unkinden ayrı, kendi application.yml'ine neden ihtiyacı vardır?$$,
           NULL, NULL,
           $$Ders, her bağımsız servisin, aynı makinede diğerleriyle birlikte çalışabilmesi için kendi portuna, uygulama adına ve veritabanı bağlantısına ihtiyacı olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Çünkü Spring Boot her Maven repository'si için tam olarak bir application.yml gerektirir$$, FALSE, 0),
    ($$Çünkü her bağımsız servisin, aynı makinede diğerleriyle birlikte çalışabilmesi için kendi portuna, uygulama adına ve veritabanı bağlantısına ihtiyacı vardır$$, TRUE, 1),
    ($$Çünkü application.yml dosyaları iki Java projesi arasında asla yeniden kullanılamaz$$, FALSE, 2),
    ($$Çünkü Thymeleaf şablonları servis başına özel bir yapılandırma dosyası gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Twelve-Factor App'in "Config" ilkesine göre, order-service'in veritabanı şifresi application.yml'de nasıl ele alınmalıdır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Twelve-Factor App'in "Config" ilkesine göre, order-service'in veritabanı şifresi application.yml'de nasıl ele alınmalıdır?$$,
           NULL, NULL,
           $$Dersin uyarı kutusu, şifrenin bilinçli olarak bir ortam değişkeninden okunduğunu, asla düz metin olarak yazılmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$application.yml git'e commit edilmediği için düz metin olarak yazılmalıdır$$, FALSE, 0),
    ($$Bir ortam değişkeninden (${ORDERS_DB_PASSWORD}) okunmalıdır, asla sabit kodlanmamalıdır$$, TRUE, 1),
    ($$Doğrudan dosyada Base64 ile kodlanmış bir dize olarak saklanmalıdır$$, FALSE, 2),
    ($$Boş bırakılmalıdır, çünkü Spring Boot otomatik olarak birini üretir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki OrderService.create(...) göz önüne alındığında, orderService.create("Keyboard", 0) olarak çağrıldığında ne olur?$$
      AND code_snippet = $$Order create(String productName, int quantity) {
    if (quantity <= 0) {
        throw new IllegalArgumentException("quantity must be positive");
    }
    String id = UUID.randomUUID().toString();
    Order order = new Order(id, productName, quantity);
    orders.put(id, order);
    return order;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki OrderService.create(...) göz önüne alındığında, orderService.create("Keyboard", 0) olarak çağrıldığında ne olur?$$,
           $$Order create(String productName, int quantity) {
    if (quantity <= 0) {
        throw new IllegalArgumentException("quantity must be positive");
    }
    String id = UUID.randomUUID().toString();
    Order order = new Order(id, productName, quantity);
    orders.put(id, order);
    return order;
}$$, $$java$$,
           $$Gerçek OrderService.java kodu, quantity <= 0 olduğunda, hiçbir Order oluşturulmadan veya saklanmadan önce IllegalArgumentException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Sipariş, quantity = 0 ile oluşturulur ve başarıyla saklanır$$, FALSE, 0),
    ($$OrderController çağrıyı sessizce yok sayar ve null döner$$, FALSE, 1),
    ($$Bir IllegalArgumentException fırlatılır, ve hiçbir sipariş saklanmaz$$, TRUE, 2),
    ($$Metot, pozitif bir miktar beklerken sonsuza kadar bloke olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (TR pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service ve inventory-service'in ikisi de, değiştirilmeden, birebir aynı server.port bloğunu kullanıyor. inventory-service, 8082 yerine bu aynı değerle deploy edilirse doğrudan, pratik sonuç nedir?$$
      AND code_snippet = $$server:
  port: 8081$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$order-service ve inventory-service'in ikisi de, değiştirilmeden, birebir aynı server.port bloğunu kullanıyor. inventory-service, 8082 yerine bu aynı değerle deploy edilirse doğrudan, pratik sonuç nedir?$$,
           $$server:
  port: 8081$$, $$yaml$$,
           $$Ders, her servisin kendi ayrı portuna ihtiyacı olduğunu açıklar; ikisi için de aynı portu kullanmak, ikisinin de aynı makinede birlikte çalışamayacağı anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Spring Boot bir servisi otomatik olarak boş bir porta yeniden atar$$, FALSE, 0),
    ($$Her iki servis de aynı makinede birlikte başlatılamaz, çünkü ikisi de 8081 portuna bağlanmaya çalışır$$, TRUE, 1),
    ($$İstekler iki servis arasında otomatik olarak yük dengelenir$$, FALSE, 2),
    ($$Hiçbir şey değişmez, çünkü server.port yalnızca HTTPS trafiğini etkiler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$OrderController, quantity <= 0 kontrolünü neden kendisi doğrulamak yerine OrderService'e devrediyor?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$OrderController, quantity <= 0 kontrolünü neden kendisi doğrulamak yerine OrderService'e devrediyor?$$,
           NULL, NULL,
           $$Ders, "geçerli bir sipariş nedir" kararının, Controller -> Service ayrımı gereği yalnızca servis katmanının sahiplenmesi gereken bir iş kuralı olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Çünkü @RestController sınıfları teknik olarak if ifadeleri çalıştıramaz$$, FALSE, 0),
    ($$Çünkü "geçerli bir sipariş nedir" kararı, yalnızca servis katmanının sahiplenmesi gereken bir iş kuralıdır$$, TRUE, 1),
    ($$Çünkü Spring Boot, @RestController ile işaretlenmiş herhangi bir sınıfta doğrulama mantığını yasaklar$$, FALSE, 2),
    ($$Çünkü OrderController'ın Order sınıfına erişimi yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (TR pair 6, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$GET /actuator/health'in {"status":"UP"} döndürmesi, bu derse göre gerçekte neyi doğrular?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$GET /actuator/health'in {"status":"UP"} döndürmesi, bu derse göre gerçekte neyi doğrular?$$,
           NULL, NULL,
           $$Ders, Actuator'ın varsayılan sağlık göstergelerinin veritabanı bağlantısını da kontrol ettiğini, bu yüzden UP'ın hem servisin çalıştığını hem veritabanına erişebildiğini doğruladığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Yalnızca JVM sürecinin hâlâ çalıştığını, bağımlılıkları hakkında hiçbir şeyi doğrulamaz$$, FALSE, 0),
    ($$order-service'in çalıştığını, ve Actuator'ın varsayılan göstergeleri bunu da kontrol ettiği için veritabanına erişebildiğini$$, TRUE, 1),
    ($$order-service'teki her REST endpoint'inin en az bir kez çağrıldığını$$, FALSE, 2),
    ($$order-service'in bir servis keşfi aracına kayıtlı olduğunu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (TR pair 7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bu derste bir mikroservisi yapılandırırken kaçınılması gereken gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bu derste bir mikroservisi yapılandırırken kaçınılması gereken gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin "Common Mistakes" listesi düz metin sırları ve spring.application.name'i unutmayı hata olarak sayar; her servise kendi application.yml'ini vermek ve sağlık kontrolünü ilk günden açmak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Bir veritabanı şifresini doğrudan application.yml'e düz metin olarak yazmak$$, TRUE, 0),
    ($$Her servise kendi, ayrı application.yml'ini vermek$$, FALSE, 1),
    ($$spring.application.name'i servisler arasında rastgele ya da tutarsız isimlendirmek$$, TRUE, 2),
    ($$/actuator/health endpoint'ini ilk günden itibaren açmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

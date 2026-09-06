-- Promotion batch
-- Topic: spring-boot-microservice-basics (language: en x7, tr x7)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/spring-boot-microservice-basics.md and content/tr/spring-boot-microservice-basics.md -- NOT produced by n8n,
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
           $$Why does order-service need its own application.yml, separate from learning-platform's?$$,
           NULL, NULL,
           $$The lesson explains each independent service needs its own port, application name, and database connection to run alongside others on the same machine.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Spring Boot requires exactly one application.yml per Maven repository$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because each independent service needs its own port, application name, and database connection to run alongside others on the same machine$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because application.yml files cannot be reused across any two Java projects$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because Thymeleaf templates require a dedicated configuration file per service$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$order-service'in, learning-platform'unkinden ayrı, kendi application.yml'ine neden ihtiyacı vardır?$$,
           NULL, NULL,
           $$Ders, her bağımsız servisin, aynı makinede diğerleriyle birlikte çalışabilmesi için kendi portuna, uygulama adına ve veritabanı bağlantısına ihtiyacı olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Spring Boot her Maven repository'si için tam olarak bir application.yml gerektirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü her bağımsız servisin, aynı makinede diğerleriyle birlikte çalışabilmesi için kendi portuna, uygulama adına ve veritabanı bağlantısına ihtiyacı vardır$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü application.yml dosyaları iki Java projesi arasında asla yeniden kullanılamaz$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Thymeleaf şablonları servis başına özel bir yapılandırma dosyası gerektirir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Per the "Config" principle from the Twelve-Factor App, how should order-service's database password be handled in application.yml?$$,
           NULL, NULL,
           $$The lesson's warning callout states the password is deliberately read from an environment variable, never written as plain text.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Written as plain text since application.yml is not committed to git$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Read from an environment variable (${ORDERS_DB_PASSWORD}), never hardcoded$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Stored as a Base64-encoded string directly in the file$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Left blank, since Spring Boot generates one automatically$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Twelve-Factor App'in "Config" ilkesine göre, order-service'in veritabanı şifresi application.yml'de nasıl ele alınmalıdır?$$,
           NULL, NULL,
           $$Dersin uyarı kutusu, şifrenin bilinçli olarak bir ortam değişkeninden okunduğunu, asla düz metin olarak yazılmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$application.yml git'e commit edilmediği için düz metin olarak yazılmalıdır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir ortam değişkeninden (${ORDERS_DB_PASSWORD}) okunmalıdır, asla sabit kodlanmamalıdır$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Doğrudan dosyada Base64 ile kodlanmış bir dize olarak saklanmalıdır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Boş bırakılmalıdır, çünkü Spring Boot otomatik olarak birini üretir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given OrderService.create(...) below, what happens when it's called as orderService.create("Keyboard", 0)?$$,
           $$Order create(String productName, int quantity) {
    if (quantity <= 0) {
        throw new IllegalArgumentException("quantity must be positive");
    }
    String id = UUID.randomUUID().toString();
    Order order = new Order(id, productName, quantity);
    orders.put(id, order);
    return order;
}$$, $$java$$,
           $$The real OrderService.java code throws IllegalArgumentException when quantity <= 0, before any Order is constructed or stored.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The order is created with quantity = 0 and stored successfully$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$OrderController silently ignores the call and returns null$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$An IllegalArgumentException is thrown, and no order is stored$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The method blocks indefinitely waiting for a positive quantity$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sipariş, quantity = 0 ile oluşturulur ve başarıyla saklanır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$OrderController çağrıyı sessizce yok sayar ve null döner$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir IllegalArgumentException fırlatılır, ve hiçbir sipariş saklanmaz$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Metot, pozitif bir miktar beklerken sonsuza kadar bloke olur$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$order-service and inventory-service both use this exact server.port block, unmodified. What is the direct, practical consequence if inventory-service is deployed with this same value instead of 8082?$$,
           $$server:
  port: 8081$$, $$yaml$$,
           $$The lesson explains each service needs its own distinct port; using the same port for both means they cannot both bind it and run together on the same machine.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Boot automatically reassigns one service to a free port$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Both services fail to start together on the same machine, since they'd both try to bind port 8081$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Requests are automatically load-balanced between the two services$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing changes, since server.port only affects HTTPS traffic$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$order-service ve inventory-service'in ikisi de, değiştirilmeden, birebir aynı server.port bloğunu kullanıyor. inventory-service, 8082 yerine bu aynı değerle deploy edilirse doğrudan, pratik sonuç nedir?$$,
           $$server:
  port: 8081$$, $$yaml$$,
           $$Ders, her servisin kendi ayrı portuna ihtiyacı olduğunu açıklar; ikisi için de aynı portu kullanmak, ikisinin de aynı makinede birlikte çalışamayacağı anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Boot bir servisi otomatik olarak boş bir porta yeniden atar$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Her iki servis de aynı makinede birlikte başlatılamaz, çünkü ikisi de 8081 portuna bağlanmaya çalışır$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$İstekler iki servis arasında otomatik olarak yük dengelenir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir şey değişmez, çünkü server.port yalnızca HTTPS trafiğini etkiler$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does OrderController hand off the quantity <= 0 check to OrderService instead of validating it itself?$$,
           NULL, NULL,
           $$The lesson states the decision of what counts as a valid order is a business rule only the service layer should own, following the Controller -> Service split.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because @RestController classes are technically unable to run if statements$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because the decision of "what counts as a valid order" is a business rule that only the service layer should own$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because Spring Boot forbids validation logic in any class annotated with @RestController$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Because OrderController doesn't have access to the Order class$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$OrderController, quantity <= 0 kontrolünü neden kendisi doğrulamak yerine OrderService'e devrediyor?$$,
           NULL, NULL,
           $$Ders, "geçerli bir sipariş nedir" kararının, Controller -> Service ayrımı gereği yalnızca servis katmanının sahiplenmesi gereken bir iş kuralı olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü @RestController sınıfları teknik olarak if ifadeleri çalıştıramaz$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü "geçerli bir sipariş nedir" kararı, yalnızca servis katmanının sahiplenmesi gereken bir iş kuralıdır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü Spring Boot, @RestController ile işaretlenmiş herhangi bir sınıfta doğrulama mantığını yasaklar$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü OrderController'ın Order sınıfına erişimi yoktur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does GET /actuator/health returning {"status":"UP"} actually verify, per this lesson?$$,
           NULL, NULL,
           $$The lesson states Actuator's default health indicators also check the database connection, so UP confirms both that the service runs and that it can reach its database.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only that the JVM process is still running, nothing about its dependencies$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$That order-service is running and, since Actuator's default indicators also check it, that it can reach its database$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$That every REST endpoint in order-service has been called at least once$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$That order-service is registered with a service discovery tool$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$GET /actuator/health'in {"status":"UP"} döndürmesi, bu derse göre gerçekte neyi doğrular?$$,
           NULL, NULL,
           $$Ders, Actuator'ın varsayılan sağlık göstergelerinin veritabanı bağlantısını da kontrol ettiğini, bu yüzden UP'ın hem servisin çalıştığını hem veritabanına erişebildiğini doğruladığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca JVM sürecinin hâlâ çalıştığını, bağımlılıkları hakkında hiçbir şeyi doğrulamaz$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$order-service'in çalıştığını, ve Actuator'ın varsayılan göstergeleri bunu da kontrol ettiği için veritabanına erişebildiğini$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$order-service'teki her REST endpoint'inin en az bir kez çağrıldığını$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$order-service'in bir servis keşfi aracına kayıtlı olduğunu$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes to avoid when configuring a microservice? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's "Common Mistakes" list plaintext secrets and forgetting spring.application.name as mistakes; giving each service its own application.yml and enabling health checks from day one are the recommended best practices instead.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Writing a database password as plain text directly in application.yml$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Giving every service its own, separate application.yml$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Naming spring.application.name randomly or inconsistently across services$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Turning on the /actuator/health endpoint from day one$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bu derste bir mikroservisi yapılandırırken kaçınılması gereken gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin "Common Mistakes" listesi düz metin sırları ve spring.application.name'i unutmayı hata olarak sayar; her servise kendi application.yml'ini vermek ve sağlık kontrolünü ilk günden açmak ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$spring-boot-microservice-basics$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir veritabanı şifresini doğrudan application.yml'e düz metin olarak yazmak$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Her servise kendi, ayrı application.yml'ini vermek$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$spring.application.name'i servisler arasında rastgele ya da tutarsız isimlendirmek$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$/actuator/health endpoint'ini ilk günden itibaren açmak$$, FALSE, 3 FROM new_question_tr7;

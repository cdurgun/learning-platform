-- Promotion batch
-- Topic: deployment (language: en x5, tr x5)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/deployment.md and content/tr/deployment.md -- NOT produced by n8n,
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
           $$Why does every localhost:8761, localhost:8888 this category's earlier lessons hardcoded break once a service moves into its own container?$$,
           NULL, NULL,
           $$The lesson explains localhost inside a container refers to that container itself, not to another service's separate container.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Docker technically forbids the word "localhost" in any configuration file$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because "localhost" inside a container refers to that container itself, not to another service's separate container$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because containers cannot use port numbers above 8000$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because Docker automatically renames every service to "localhost" on startup$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kategorinin önceki derslerinin sabit kodladığı her localhost:8761, localhost:8888, bir servis kendi container'ına taşındığında neden bozulur?$$,
           NULL, NULL,
           $$Ders, bir container içindeki "localhost"un, başka bir servisin ayrı container'ına değil, o container'ın kendisine atıfta bulunduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Docker teknik olarak herhangi bir yapılandırma dosyasında "localhost" kelimesini yasaklar$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü bir container içindeki "localhost", başka bir servisin ayrı container'ına değil, o container'ın kendisine atıfta bulunur$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü container'lar 8000'in üzerindeki port numaralarını kullanamaz$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Docker, başlangıçta her servisi otomatik olarak "localhost" olarak yeniden adlandırır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "A Multi-Stage Build: Keeping the Image Small," what does order-service's final Docker image NOT include, thanks to the multi-stage build?$$,
           NULL, NULL,
           $$The lesson explains the final image never includes Maven, the JDK's compiler, or order-service's own source code -- only the already-built jar and a JRE.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The already-built .jar file itself$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A minimal JRE needed to run the application$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The full JDK, Maven, and order-service's own source code$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Any runtime configuration whatsoever$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"A Multi-Stage Build: Keeping the Image Small" bölümüne göre, çok aşamalı build sayesinde, order-service'in nihai Docker image'ı neyi İÇERMEZ?$$,
           NULL, NULL,
           $$Ders, nihai image'ın hiçbir zaman Maven'i, JDK'nın derleyicisini, veya order-service'in kendi kaynak kodunu içermediğini -- yalnızca zaten derlenmiş jar'ı ve bir JRE'yi içerdiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Zaten derlenmiş .jar dosyasının kendisini$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulamayı çalıştırmak için gereken minimal bir JRE'yi$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam JDK'yı, Maven'i, ve order-service'in kendi kaynak kodunu$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Herhangi bir çalışma zamanı yapılandırmasını$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this docker-compose.yml fragment, what does condition: service_started for kafka actually guarantee, according to this lesson?$$,
           $$order-service:
  build: ./order-service
  depends_on:
    eureka-server:
      condition: service_healthy
    kafka:
      condition: service_started$$, $$yaml$$,
           $$The lesson's warning explains service_started only confirms the container process began running, not that Kafka is actually ready to accept connections.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$That Kafka has passed its own /actuator/health check$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Only that the Kafka container's process has begun running -- not that Kafka is actually ready to accept connections$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$That Kafka has finished creating every topic order-service will ever need$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing -- service_started and service_healthy behave identically$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki docker-compose.yml parçası göz önüne alındığında, bu derse göre, kafka için condition: service_started gerçekte neyi garanti eder?$$,
           $$order-service:
  build: ./order-service
  depends_on:
    eureka-server:
      condition: service_healthy
    kafka:
      condition: service_started$$, $$yaml$$,
           $$Dersin uyarısı, service_started'ın yalnızca Kafka container'ının sürecinin çalışmaya başladığını doğruladığını, Kafka'nın gerçekten bağlantı kabul etmeye hazır olduğunu doğrulamadığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kafka'nın kendi /actuator/health kontrolünü geçtiğini$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca Kafka container'ının sürecinin çalışmaya başladığını -- Kafka'nın gerçekten bağlantı kabul etmeye hazır olduğunu değil$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Kafka'nın, order-service'in ihtiyaç duyacağı her topic'i oluşturmayı bitirdiğini$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir şey -- service_started ve service_healthy birebir aynı şekilde davranır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per "Beyond Local: A Brief, Honest Look at Kubernetes," what does moving from Docker Compose to Kubernetes actually change about order-service's container image?$$,
           NULL, NULL,
           $$The lesson's tip explains Kubernetes runs the exact same image Docker Compose does -- it changes how many instances run and how they're orchestrated, not how the image is built.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The image itself has to be completely rebuilt with Kubernetes-specific tooling$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing -- Kubernetes runs the exact same image Docker Compose does; it changes how many instances run and how they're orchestrated, not how the image is built$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The image must be converted from a .jar-based format to a .war-based one$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Kubernetes requires removing the multi-stage build entirely$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Beyond Local: A Brief, Honest Look at Kubernetes" bölümüne göre, Docker Compose'dan Kubernetes'e geçmek order-service'in container image'ı hakkında gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Dersin ipucu, Kubernetes'in Docker Compose'un çalıştırdığı birebir aynı image'ı çalıştırdığını -- kaç instance'ın çalıştığını ve nasıl orkestre edildiğini değiştirdiğini, image'ın nasıl build edildiğini değil, açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Image'ın kendisinin Kubernetes'e özgü araçlarla tamamen yeniden build edilmesi gerekir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir şey -- Kubernetes, Docker Compose'un çalıştırdığı birebir aynı image'ı çalıştırır; kaç instance'ın çalıştığını ve nasıl orkestre edildiğini değiştirir, image'ın nasıl build edildiğini değil$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Image'ın .jar tabanlı formattan .war tabanlı bir formata dönüştürülmesi gerekir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Kubernetes, çok aşamalı build'in tamamen kaldırılmasını gerektirir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when deploying a microservices system? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list a single-stage build and assuming depends_on alone means ready as mistakes; environment-variable overrides and reaching for Kubernetes only when needed are the recommended approaches.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Shipping a Dockerfile without a multi-stage build$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Using environment variables to override configuration that changes between environments$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Assuming depends_on (without a health check condition) means a dependency is actually ready to accept traffic$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Reaching for Kubernetes only once multi-machine orchestration is genuinely needed$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste bir mikroservis sistemini deploy ederken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi tek aşamalı bir build'i ve depends_on'un tek başına hazır anlamına geldiğini varsaymayı hata olarak sayar; ortam değişkeni override'ları ve Kubernetes'e yalnızca gerektiğinde başvurmak ise önerilen yaklaşımlardır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$deployment$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çok aşamalı bir build olmadan bir Dockerfile göndermek$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Ortamlar arasında değişen yapılandırmayı override etmek için ortam değişkenlerini kullanmak$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$depends_on'un (bir sağlık kontrolü koşulu olmadan) bir bağımlılığın gerçekten trafik kabul etmeye hazır olduğu anlamına geldiğini varsaymak$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Kubernetes'e yalnızca çoklu makine orkestrasyonu gerçekten gerektiğinde başvurmak$$, FALSE, 3 FROM new_question_tr5;

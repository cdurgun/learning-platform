-- Promotion-style migration linking TR deployment quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/5 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu kategorinin önceki derslerinin sabit kodladığı her localhost:8761, localhost:8888, bir servis kendi container'ına taşındığında neden bozulur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kategorinin önceki derslerinin sabit kodladığı her localhost:8761, localhost:8888, bir servis kendi container'ına taşındığında neden bozulur?$$,
           NULL, NULL,
           $$Ders, bir container içindeki "localhost"un, başka bir servisin ayrı container'ına değil, o container'ın kendisine atıfta bulunduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Çünkü Docker teknik olarak herhangi bir yapılandırma dosyasında "localhost" kelimesini yasaklar$$, FALSE, 0),
    ($$Çünkü bir container içindeki "localhost", başka bir servisin ayrı container'ına değil, o container'ın kendisine atıfta bulunur$$, TRUE, 1),
    ($$Çünkü container'lar 8000'in üzerindeki port numaralarını kullanamaz$$, FALSE, 2),
    ($$Çünkü Docker, başlangıçta her servisi otomatik olarak "localhost" olarak yeniden adlandırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"A Multi-Stage Build: Keeping the Image Small" bölümüne göre, çok aşamalı build sayesinde, order-service'in nihai Docker image'ı neyi İÇERMEZ?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"A Multi-Stage Build: Keeping the Image Small" bölümüne göre, çok aşamalı build sayesinde, order-service'in nihai Docker image'ı neyi İÇERMEZ?$$,
           NULL, NULL,
           $$Ders, nihai image'ın hiçbir zaman Maven'i, JDK'nın derleyicisini, veya order-service'in kendi kaynak kodunu içermediğini -- yalnızca zaten derlenmiş jar'ı ve bir JRE'yi içerdiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Zaten derlenmiş .jar dosyasının kendisini$$, FALSE, 0),
    ($$Uygulamayı çalıştırmak için gereken minimal bir JRE'yi$$, FALSE, 1),
    ($$Tam JDK'yı, Maven'i, ve order-service'in kendi kaynak kodunu$$, TRUE, 2),
    ($$Herhangi bir çalışma zamanı yapılandırmasını$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki docker-compose.yml parçası göz önüne alındığında, bu derse göre, kafka için condition: service_started gerçekte neyi garanti eder?$$
      AND code_snippet = $$order-service:
  build: ./order-service
  depends_on:
    eureka-server:
      condition: service_healthy
    kafka:
      condition: service_started$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Kafka'nın kendi /actuator/health kontrolünü geçtiğini$$, FALSE, 0),
    ($$Yalnızca Kafka container'ının sürecinin çalışmaya başladığını -- Kafka'nın gerçekten bağlantı kabul etmeye hazır olduğunu değil$$, TRUE, 1),
    ($$Kafka'nın, order-service'in ihtiyaç duyacağı her topic'i oluşturmayı bitirdiğini$$, FALSE, 2),
    ($$Hiçbir şey -- service_started ve service_healthy birebir aynı şekilde davranır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Beyond Local: A Brief, Honest Look at Kubernetes" bölümüne göre, Docker Compose'dan Kubernetes'e geçmek order-service'in container image'ı hakkında gerçekte neyi değiştirir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Beyond Local: A Brief, Honest Look at Kubernetes" bölümüne göre, Docker Compose'dan Kubernetes'e geçmek order-service'in container image'ı hakkında gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Dersin ipucu, Kubernetes'in Docker Compose'un çalıştırdığı birebir aynı image'ı çalıştırdığını -- kaç instance'ın çalıştığını ve nasıl orkestre edildiğini değiştirdiğini, image'ın nasıl build edildiğini değil, açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Image'ın kendisinin Kubernetes'e özgü araçlarla tamamen yeniden build edilmesi gerekir$$, FALSE, 0),
    ($$Hiçbir şey -- Kubernetes, Docker Compose'un çalıştırdığı birebir aynı image'ı çalıştırır; kaç instance'ın çalıştığını ve nasıl orkestre edildiğini değiştirir, image'ın nasıl build edildiğini değil$$, TRUE, 1),
    ($$Image'ın .jar tabanlı formattan .war tabanlı bir formata dönüştürülmesi gerekir$$, FALSE, 2),
    ($$Kubernetes, çok aşamalı build'in tamamen kaldırılmasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (TR pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste bir mikroservis sistemini deploy ederken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste bir mikroservis sistemini deploy ederken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi tek aşamalı bir build'i ve depends_on'un tek başına hazır anlamına geldiğini varsaymayı hata olarak sayar; ortam değişkeni override'ları ve Kubernetes'e yalnızca gerektiğinde başvurmak ise önerilen yaklaşımlardır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Çok aşamalı bir build olmadan bir Dockerfile göndermek$$, TRUE, 0),
    ($$Ortamlar arasında değişen yapılandırmayı override etmek için ortam değişkenlerini kullanmak$$, FALSE, 1),
    ($$depends_on'un (bir sağlık kontrolü koşulu olmadan) bir bağımlılığın gerçekten trafik kabul etmeye hazır olduğu anlamına geldiğini varsaymak$$, TRUE, 2),
    ($$Kubernetes'e yalnızca çoklu makine orkestrasyonu gerçekten gerektiğinde başvurmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

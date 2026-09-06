-- Promotion-style migration linking TR observability quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/5 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$observability$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"The Three Pillars: Logs, Metrics, and Traces" bölümüne göre, üçünden hangisi "BU belirli istek zamanını nerede harcadı, ve hangi serviste başarısız oldu" sorusunu yanıtlamaya en uygundur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"The Three Pillars: Logs, Metrics, and Traces" bölümüne göre, üçünden hangisi "BU belirli istek zamanını nerede harcadı, ve hangi serviste başarısız oldu" sorusunu yanıtlamaya en uygundur?$$,
           NULL, NULL,
           $$Ders, trace'lerin tek bir isteği birden fazla servis boyunca hareket ederken takip ettiğini, tam olarak bu soruyu yanıtladığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$observability$$
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
    ($$Log'lar$$, FALSE, 0),
    ($$Metrikler$$, FALSE, 1),
    ($$Trace'ler$$, TRUE, 2),
    ($$Üçünden hiçbiri -- bu soru observability araçlarıyla yanıtlanamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$observability$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$observability$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Common Mistakes" bölümüne göre, bir finally bloğunda MDC'yi temizlemeyi unutmak hangi gerçek hataya yol açar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Common Mistakes" bölümüne göre, bir finally bloğunda MDC'yi temizlemeyi unutmak hangi gerçek hataya yol açar?$$,
           NULL, NULL,
           $$Ders, bir servlet container'ın thread'leri istekler arasında yeniden kullandığını, bu yüzden bir isteğin correlation id'sinin tamamen ilgisiz, sonraki bir isteğin log'larına sızdığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$observability$$
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
    ($$Uygulama hemen bir OutOfMemoryError ile çöker$$, FALSE, 0),
    ($$Bir servlet container, thread'leri istekler arasında yeniden kullanır, bu yüzden bir isteğin correlation id'si tamamen ilgisiz, sonraki bir isteğin log'larına sızar$$, TRUE, 1),
    ($$MDC değerleri otomatik olarak şifrelenir ve okunamaz hâle gelir$$, FALSE, 2),
    ($$Correlation id, tüm servislerde aynı anda çoğaltılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$observability$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$observability$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki özel metrik kodu göz önüne alındığında, bu, bu dersin observability sütunları bağlamında gerçekte ne yapar?$$
      AND code_snippet = $$Counter.builder("orders.placed")
    .register(meterRegistry)
    .increment();$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki özel metrik kodu göz önüne alındığında, bu, bu dersin observability sütunları bağlamında gerçekte ne yapar?$$,
           $$Counter.builder("orders.placed")
    .register(meterRegistry)
    .increment();$$, $$java$$,
           $$Dersin hızlı referansı, bunun Micrometer/Actuator aracılığıyla zaman içinde izlenen sayısal bir counter metriğini artırdığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$observability$$
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
    ($$Sipariş hakkında yapılandırılmış bir JSON log satırı yazar$$, FALSE, 0),
    ($$Micrometer/Actuator aracılığıyla zaman içinde izlenen sayısal bir counter metriğini artırır$$, TRUE, 1),
    ($$Bu istek için yeni bir distributed trace span'i başlatır$$, FALSE, 2),
    ($$Sipariş verisini Kafka üzerinden inventory-service'e gönderir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$observability$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$observability$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Exposing What Resilience4j Was Already Tracking" bölümüne göre, Micrometer zaten otomatik olarak entegre olsa bile, bu ders Resilience4j dersindeki elle yazılmış CircuitBreakerEventListener'ın hâlâ neden yararlı olduğunu söyler?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Exposing What Resilience4j Was Already Tracking" bölümüne göre, Micrometer zaten otomatik olarak entegre olsa bile, bu ders Resilience4j dersindeki elle yazılmış CircuitBreakerEventListener'ın hâlâ neden yararlı olduğunu söyler?$$,
           NULL, NULL,
           $$Ders, elle yazılmış listener'ın geliştirme sırasında anında, insan tarafından okunabilir log satırları verdiğini, Micrometer entegrasyonunun ise production'da gerçek bir dashboard/alert'in izlediği şey olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$observability$$
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
    ($$Çünkü Micrometer, hiçbir yapılandırma altında circuit breaker durumlarını izleyemez$$, FALSE, 0),
    ($$Çünkü elle yazılmış listener geliştirme sırasında anında, insan tarafından okunabilir log satırları verirken, Micrometer entegrasyonu production'da gerçek bir dashboard/alert'in izlediği şeydir$$, TRUE, 1),
    ($$Çünkü CircuitBreakerEventListener, circuit breaker'ın hiç çalışması için gereklidir$$, FALSE, 2),
    ($$Çünkü Micrometer entegrasyonu yalnızca @Retry için çalışır, @CircuitBreaker için değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$observability$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (TR pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$observability$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste observability pratiğinde yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste observability pratiğinde yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi metrikleri/log'ları birbirinin yerine geçeni olarak ele almayı ve correlation id'yi ilk servisten sonra yaymamayı hata olarak sayar; her metriği üreten servisle etiketlemek ve tutarlı yayma ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$observability$$
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
    ($$Metrikleri log'ların tam bir yerine geçeni olarak ele almak, ya da tam tersi$$, TRUE, 0),
    ($$Her metriği onu üreten servisle etiketlemek$$, FALSE, 1),
    ($$Correlation id'yi gateway'de atamak ama onu ilk servisten sonra hiç yaymamak$$, TRUE, 2),
    ($$Correlation id'yi her servis sınırında tutarlı bir şekilde yaymak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$observability$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

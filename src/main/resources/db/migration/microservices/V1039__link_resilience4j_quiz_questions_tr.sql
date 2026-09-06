-- Promotion-style migration linking TR resilience4j quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/6 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin Resilience4j tanıtımı, order-service'in mevcut hata yönetimindeki hangi gerçek boşluğu ele alır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin Resilience4j tanıtımı, order-service'in mevcut hata yönetimindeki hangi gerçek boşluğu ele alır?$$,
           NULL, NULL,
           $$Ders, 404-vs-erişilemez ayrımı zaten var olsa bile, order-service'in her istekte geri çekilmek yerine zorlanan inventory-service'e yüklenmeye devam ettiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$order-service'in bu dersten önce JSON yanıtlarını serialize etmenin bir yolu yoktu$$, FALSE, 0),
    ($$404-vs-erişilemez ayrımı zaten var olsa bile, order-service her istekte geri çekilmek yerine zorlanan inventory-service'e yüklenmeye devam ediyordu$$, TRUE, 1),
    ($$order-service'in bu dersten önce hiçbir veritabanına bağlanamıyordu$$, FALSE, 2),
    ($$RestClient, Resilience4j tanıtılmadan önce bir API olarak var olmuyordu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Circuit Breaker: States and Configuration" bölümüne göre, circuit breaker OPEN durumuna geçtiğinde ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Circuit Breaker: States and Configuration" bölümüne göre, circuit breaker OPEN durumuna geçtiğinde ne olur?$$,
           NULL, NULL,
           $$Ders, circuit OPEN olduğunda, yapılandırılmış bir bekleme süresi boyunca, gerçek çağrı hiç denenmeden her çağrının hemen başarısız olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$Gerçek çağrı yine de denenir, ama daha uzun bir zaman aşımıyla$$, FALSE, 0),
    ($$Yapılandırılmış bir bekleme süresi boyunca, gerçek çağrı hiç denenmeden, her çağrı hemen başarısız olur$$, TRUE, 1),
    ($$Uygulama hemen kapanır$$, FALSE, 2),
    ($$Tüm gelecekteki çağrılar, başarısız olmadan önce otomatik olarak üç kez yeniden denenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Wrapping StockClient with a Circuit Breaker" bölümündeki uyarıya göre, aynı sınıftaki bir metot, inject edilmiş bean üzerinden gitmek yerine doğrudan this.checkStock(...) çağırırsa ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Wrapping StockClient with a Circuit Breaker" bölümündeki uyarıya göre, aynı sınıftaki bir metot, inject edilmiş bean üzerinden gitmek yerine doğrudan this.checkStock(...) çağırırsa ne olur?$$,
           NULL, NULL,
           $$Ders, bunun tam olarak @Transactional gibi, Spring'in proxy mekanizmasını tamamen atladığını, bu yüzden ne @CircuitBreaker ne de @Retry'ın hiçbir zaman çalışmadığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$Hiçbir şey değişmez -- annotation'lar bir metodun nasıl çağrıldığından bağımsız olarak uygulanır$$, FALSE, 0),
    ($$Çağrı, Spring'in proxy mekanizmasını tamamen atlar, bu yüzden ne @CircuitBreaker ne de @Retry hiçbir zaman çalışmaz$$, TRUE, 1),
    ($$Uygulama başlatılamaz, bir BeanCreationException fırlatır$$, FALSE, 2),
    ($$Circuit breaker, bir güvenlik önlemi olarak hemen OPEN durumuna geçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Retry: Trying Again Before Giving Up" bölümüne göre, @Retry ve @CircuitBreaker, aynı annotate edilmiş metotta gerçekte hangi sırayla etkileşir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Retry: Trying Again Before Giving Up" bölümüne göre, @Retry ve @CircuitBreaker, aynı annotate edilmiş metotta gerçekte hangi sırayla etkileşir?$$,
           NULL, NULL,
           $$Ders, @Retry'ın, circuit breaker o başarısızlığı hiç kaydetmeden önce, başarısız bir çağrıyı yapılandırılan sayıda yeniden denediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$Circuit breaker her zaman önce çalışır, ve retry yalnızca gerçekten açık devrelere uygulanır$$, FALSE, 0),
    ($$@Retry, circuit breaker o başarısızlığı hiç kaydetmeden önce, başarısız bir çağrıyı yapılandırılan sayıda yeniden dener$$, TRUE, 1),
    ($$İkisi aynı metotta hiçbir şekilde birleştirilemez$$, FALSE, 2),
    ($$@Retry ve @CircuitBreaker, aynı anda tamamen ayrı iki thread'de çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (TR pair 5, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki Resilience4j yapılandırması göz önüne alındığında, inventoryService'e yapılan son 10 çağrının 6'sı başarısız olduysa, circuit breaker hangi duruma geçer?$$
      AND code_snippet = $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki Resilience4j yapılandırması göz önüne alındığında, inventoryService'e yapılan son 10 çağrının 6'sı başarısız olduysa, circuit breaker hangi duruma geçer?$$,
           $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$, $$yaml$$,
           $$Ders, yapılandırılmış eşiği aşan bir başarısızlık oranının circuit'i OPEN'a geçirdiğini açıklar -- burada %60, %50'lik failure-rate-threshold'u aşar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$CLOSED kalır, çünkü 6 başarısızlık, 10'luk sliding window boyutunun altındadır$$, FALSE, 0),
    ($$OPEN'a geçer, çünkü %60, yapılandırılmış %50'lik failure-rate-threshold'u aşar$$, TRUE, 1),
    ($$OPEN'ı tamamen atlayarak doğrudan HALF_OPEN'a geçer$$, FALSE, 2),
    ($$wait-duration-in-open-state herhangi bir durum değişikliğini engellediği için sonsuza kadar CLOSED kalır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (TR pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki ifadelerden hangileri, bu derse göre, Resilience4j'nin koruyucuları hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki ifadelerden hangileri, bu derse göre, Resilience4j'nin koruyucuları hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, rate limiter/bulkhead'in sağlıklıyken bile aşırı yüklenmeye karşı koruduğunu, fallback metot imzasının orijinal parametreler artı sondaki bir Throwable ile eşleşmesi gerektiğini açıklar; bulkhead'in yerine geçme ve retry-vs-circuit-breaker'ın rakip olması ise açıkça yanlış anlama olarak sayılır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$Bir rate limiter ve bir bulkhead, hedef servis tamamen sağlıklı olsa bile aşırı yüklenmeye karşı korur$$, TRUE, 0),
    ($$Bir bulkhead, bir servis gerçekten çökmüşken bir circuit breaker'ın yerine geçebilir$$, FALSE, 1),
    ($$Bir fallback metodunun imzası, orijinal metodun parametreleri artı sondaki bir Throwable ile eşleşmelidir$$, TRUE, 2),
    ($$@Retry ve @CircuitBreaker, hiçbir zaman birlikte uygulanamayan rakip seçeneklerdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

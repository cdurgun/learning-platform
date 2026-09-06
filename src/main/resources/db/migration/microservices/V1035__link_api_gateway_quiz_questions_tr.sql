-- Promotion-style migration linking TR api-gateway quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/5 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$api-gateway$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, API Gateway'in temel rolü nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, API Gateway'in temel rolü nedir?$$,
           NULL, NULL,
           $$Ders, bir API Gateway'i, harici client isteklerini doğru dahili mikroservise yönlendiren tek bir giriş noktası olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$api-gateway$$
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
    ($$Her mikroservisin iş verisini tek bir yerde saklamak$$, FALSE, 0),
    ($$Harici client isteklerini doğru dahili mikroservise yönlendiren tek bir giriş noktası$$, TRUE, 1),
    ($$Eureka'nın yerini servis registry'si olarak almak$$, FALSE, 2),
    ($$order-service ve inventory-service için gerçek iş mantığını çalıştırmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$api-gateway$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$api-gateway$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir Spring Cloud Gateway route'unu birlikte oluşturan üç bileşen nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Spring Cloud Gateway route'unu birlikte oluşturan üç bileşen nedir?$$,
           NULL, NULL,
           $$Ders, bir route'u bir predicate, bir hedef URI, ve isteğe bağlı bir veya daha fazla filtre olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$api-gateway$$
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
    ($$Bir controller, bir servis, ve bir repository$$, FALSE, 0),
    ($$Bir predicate, bir hedef URI, ve isteğe bağlı filtreler$$, TRUE, 1),
    ($$Bir producer, bir consumer, ve bir broker$$, FALSE, 2),
    ($$Bir entity, bir DTO, ve bir mapper$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$api-gateway$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$api-gateway$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki route yapılandırması göz önüne alındığında, bir istek geldiğinde lb://order-service gerçekte neye çözümlenir?$$
      AND code_snippet = $$- id: orders-route
  uri: lb://order-service
  predicates:
    - Path=/orders/**
  filters:
    - StripPrefix=0$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki route yapılandırması göz önüne alındığında, bir istek geldiğinde lb://order-service gerçekte neye çözümlenir?$$,
           $$- id: orders-route
  uri: lb://order-service
  predicates:
    - Path=/orders/**
  filters:
    - StripPrefix=0$$, $$yaml$$,
           $$Ders, lb://'nin Spring Cloud Gateway'e servis adını Eureka üzerinden çözümlemesini ve kayıtlı instance'lar arasında yük dengelemesini söylediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$api-gateway$$
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
    ($$DNS ile aranan, order-service adlı sabit, gerçek bir hostname$$, FALSE, 0),
    ($$order-service'in şu anda kayıtlı Eureka instance'ları arasından seçilen gerçek bir host:port$$, TRUE, 1),
    ($$Gateway'in kendi dosya sistemindeki yerel bir dosya yolu$$, FALSE, 2),
    ($$Bir hata, çünkü lb:// hiçbir bağlamda geçerli bir URI şeması değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$api-gateway$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$api-gateway$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Writing a Custom Filter" bölümündeki uyarıya göre, bir GlobalFilter'ın filter(...) metodu çağıran thread'i neden asla bloke etmemelidir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Writing a Custom Filter" bölümündeki uyarıya göre, bir GlobalFilter'ın filter(...) metodu çağıran thread'i neden asla bloke etmemelidir?$$,
           NULL, NULL,
           $$Ders, Spring WebFlux'ın her eşzamanlı istek arasında paylaşılan küçük, sabit sayıda thread çalıştırdığını -- birini bloke etmenin ilgisiz istekleri de durdurduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$api-gateway$$
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
    ($$Çünkü GlobalFilter metotları 10 milisaniyelik bir çalışma zaman aşımıyla sınırlıdır$$, FALSE, 0),
    ($$Çünkü Spring WebFlux, her eşzamanlı istek arasında paylaşılan küçük, sabit sayıda thread çalıştırır -- birini bloke etmek ilgisiz istekleri de durdurur$$, TRUE, 1),
    ($$Çünkü bloklayan çağrılar tüm gateway uygulamasını otomatik olarak yeniden başlatır$$, FALSE, 2),
    ($$Çünkü Spring MVC (WebFlux değil) tüm filtrelerin asenkron olmasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$api-gateway$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (TR pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$api-gateway$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste bir API Gateway'in YAPMAMASI gereken şeyler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste bir API Gateway'in YAPMAMASI gereken şeyler olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, iş kararlarını ve yanıt birleştirmeyi açıkça sıradan bir gateway'in kapsamı dışında sayar; adına göre yönlendirme ve correlation id atama ise meşru gateway sorumluluklarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$api-gateway$$
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
    ($$Bir siparişin geçerli olup olmadığına karar vermek (bir iş kararı)$$, TRUE, 0),
    ($$Bir isteği, Eureka üzerinden çözümlenen servis adına göre yönlendirmek$$, FALSE, 1),
    ($$Birden fazla servisten gelen yanıtları tek, birleşik bir yanıtta toplamak$$, TRUE, 2),
    ($$Gelen bir isteğe bir correlation id atamak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$api-gateway$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

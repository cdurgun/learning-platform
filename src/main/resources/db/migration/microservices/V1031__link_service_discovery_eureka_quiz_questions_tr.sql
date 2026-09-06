-- Promotion-style migration linking TR service-discovery-eureka quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/6 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Service Discovery hangi temel problemi çözer?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Service Discovery hangi temel problemi çözer?$$,
           NULL, NULL,
           $$Ders, Service Discovery'i, servislerin sabit kodlanmış bir adres yerine merkezi bir registry aracılığıyla birbirini isimle bulmasını sağlayan bir desen olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$REST'i daha hızlı bir ikili protokolle değiştirir$$, FALSE, 0),
    ($$Servislerin, sabit kodlanmış bir adres yerine merkezi bir registry aracılığıyla birbirini isimle bulmasını sağlar$$, TRUE, 1),
    ($$Her mikroservis için otomatik olarak unit test yazar$$, FALSE, 2),
    ($$Birden fazla veritabanını tek, paylaşılan bir veritabanında birleştirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service bir Eureka client olduğunda, spring.application.name değeri hangi yeni rolü üstlenir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$order-service bir Eureka client olduğunda, spring.application.name değeri hangi yeni rolü üstlenir?$$,
           NULL, NULL,
           $$Ders, spring.application.name'in artık yalnızca bir log etiketi olmadığını -- diğer servislerin onu bulmak için kullandığı asıl anahtar hâline geldiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Hiçbiri -- tamamen kozmetik bir log etiketi olarak kalır$$, FALSE, 0),
    ($$Diğer servislerin onu registry'de bulmak için kullandığı asıl anahtar hâline gelir$$, TRUE, 1),
    ($$Yalnızca servisin veritabanı şemasını adlandırmak için kullanılır$$, FALSE, 2),
    ($$Servisin HTTP portunu otomatik olarak belirler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Discovering Services with DiscoveryClient" bölümüne göre, DiscoveryClient'ın gerçek önerilen kullanım senaryosu nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Discovering Services with DiscoveryClient" bölümüne göre, DiscoveryClient'ın gerçek önerilen kullanım senaryosu nedir?$$,
           NULL, NULL,
           $$İpucu kutusu, DiscoveryClient'ın günlük servisler arası çağrılar için doğru araç olmadığını -- gerçek kullanım senaryosunun teşhis ve registry'nin şu anda ne gördüğünü anlamak olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Her rutin servisler arası iş çağrısını yapmak$$, FALSE, 0),
    ($$Teşhis ve registry'nin şu anda ne gördüğünü anlamak, günlük çağrılar değil$$, TRUE, 1),
    ($$@LoadBalanced RestClient'ın yerini tamamen almak$$, FALSE, 2),
    ($$Yeni bir servisi Eureka Server'a kaydetmek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (TR pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$order-service'ten gelen bu çağrı göz önüne alındığında, zaten yapılandırılmış bir @LoadBalanced RestClient.Builder bean'i varken, inventory-service, çalışma zamanında neye çözümlenir?$$
      AND code_snippet = $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$order-service'ten gelen bu çağrı göz önüne alındığında, zaten yapılandırılmış bir @LoadBalanced RestClient.Builder bean'i varken, inventory-service, çalışma zamanında neye çözümlenir?$$,
           $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$, $$java$$,
           $$Ders, @LoadBalanced'ın böyle bir adresi bir servis adı olarak yorumlattığını, Spring Cloud LoadBalancer tarafından kayıtlı instance'lar arasından gerçek bir host:port'a çözümlendiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$İşletim sistemi tarafından çözümlenen, inventory-service adlı gerçek bir DNS hostname'i$$, FALSE, 0),
    ($$Eureka registry'sinde şu anda kayıtlı instance'lardan seçilen gerçek bir host:port$$, TRUE, 1),
    ($$Hiçbir şey -- bu URI formatı geçersizdir ve hemen exception fırlatır$$, FALSE, 2),
    ($$localhost:8080, çözümlenemeyen isimler için varsayılan fallback$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici inventory-service'i yerel olarak kapatıyor, ama birkaç dakika sonra Eureka dashboard'u onu hâlâ "kayıtlı" olarak gösteriyor. "Heartbeats, Eviction, and Self-Preservation Mode" bölümüne göre, en olası açıklama nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici inventory-service'i yerel olarak kapatıyor, ama birkaç dakika sonra Eureka dashboard'u onu hâlâ "kayıtlı" olarak gösteriyor. "Heartbeats, Eviction, and Self-Preservation Mode" bölümüne göre, en olası açıklama nedir?$$,
           NULL, NULL,
           $$Uyarı kutusu, bunun bir hata olmadığını -- Eureka Server'ın muhtemelen self-preservation mode'a girip eviction'ı kasıtlı olarak geciktirdiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Bu her zaman Eureka client kütüphanesindeki bir hatadır$$, FALSE, 0),
    ($$Eureka Server muhtemelen self-preservation mode'a girmiştir, eviction'ı kasıtlı olarak geciktirmektedir$$, TRUE, 1),
    ($$Dashboard cache'lenmiştir ve yenilenmesi için tam bir sunucu yeniden başlatması gerekir$$, FALSE, 2),
    ($$Eureka instance'ları anında evict eder, bu yüzden bu gerçekte hiç yaşanamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (TR pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki ifadelerden hangileri, bu derse göre, Eureka'nın CAP teoremindeki konumu hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki ifadelerden hangileri, bu derse göre, Eureka'nın CAP teoremindeki konumu hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, Eureka'nın bilinçli olarak AP tarafını seçtiğini, self-preservation mode'un bu felsefenin doğrudan bir sonucu olduğunu belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Eureka bilinçli olarak AP tarafını seçer -- kısmen bayat bir registry'den bile olsa her zaman cevap vermeyi tercih eder$$, TRUE, 0),
    ($$Eureka, registry'nin her zaman mükemmel şekilde güncel olduğunu, sıfır bayatlık ile garanti eder$$, FALSE, 1),
    ($$Self-preservation mode, Eureka'nın AP-eğilimli felsefesinin doğrudan bir sonucudur$$, TRUE, 2),
    ($$Eureka, bir ağ bölünmesi sırasında hiçbir sorguyu yanıtlamayı reddeder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

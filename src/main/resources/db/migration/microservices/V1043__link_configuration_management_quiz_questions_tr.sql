-- Promotion-style migration linking TR configuration-management quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/5 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, yapılandırmayı bir Config Server'da merkezileştirmek hangi problemi çözer?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, yapılandırmayı bir Config Server'da merkezileştirmek hangi problemi çözer?$$,
           NULL, NULL,
           $$Ders, merkezileştirmenin, aynı paylaşılan yapılandırma değerini birçok servisin kendi dosyasında kopyalayıp elle güncellemekten kaçındığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Herhangi bir application.yml dosyasına olan ihtiyacı tamamen ortadan kaldırır$$, FALSE, 0),
    ($$Aynı paylaşılan yapılandırma değerini birçok servisin kendi dosyasında kopyalayıp elle güncellemekten kaçınır$$, TRUE, 1),
    ($$Servisler arasındaki her HTTP isteğini otomatik olarak şifreler$$, FALSE, 2),
    ($$Bir veritabanı bağlantı dizesine olan ihtiyacı tamamen ortadan kaldırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"The Config Repository: Where Configuration Actually Lives" bölümüne göre, server.port ve spring.application.name neden merkezileştirilmek yerine order-service'in kendi yerel application.yml'inde kalır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"The Config Repository: Where Configuration Actually Lives" bölümüne göre, server.port ve spring.application.name neden merkezileştirilmek yerine order-service'in kendi yerel application.yml'inde kalır?$$,
           NULL, NULL,
           $$Ders, bir servisin, Config Server'a başka bir şey sormadan önce bile kendi kimliğini ve portunu bilmesi gerektiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Çünkü Config Server teknik olarak port gibi tamsayı değerleri saklayamaz$$, FALSE, 0),
    ($$Çünkü bir servisin, Config Server'a başka bir şey sormadan önce bile kendi kimliğini ve portunu bilmesi gerekir$$, TRUE, 1),
    ($$Çünkü server.port ve spring.application.name kullanımdan kaldırılmış özelliklerdir$$, FALSE, 2),
    ($$Çünkü bunları merkezileştirmek ayrı bir veritabanı gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (TR pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$@RefreshScope ile annotate edilmiş bir bean, greeting.message'ı @Value aracılığıyla okuyor. Bir geliştirici bu değeri Config Repository'de düzenliyor, ama hiçbir zaman /actuator/refresh'i çağırmıyor. Çalışan servis ne görür?$$
      AND code_snippet = $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@RefreshScope ile annotate edilmiş bir bean, greeting.message'ı @Value aracılığıyla okuyor. Bir geliştirici bu değeri Config Repository'de düzenliyor, ama hiçbir zaman /actuator/refresh'i çağırmıyor. Çalışan servis ne görür?$$,
           $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$, $$java$$,
           $$Ders, @RefreshScope'un, @Value ile inject edilen özellikleri yalnızca bir refresh gerçekten tetiklendiğinde yeniden okuduğunu -- olmadan hiçbir şeyin bir sonraki yeniden başlatmaya kadar değişmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Yeni değeri, otomatik olarak, bir sonraki istekte$$, FALSE, 0),
    ($$Eski değeri -- @RefreshScope, @Value'ları yalnızca bir refresh gerçekten tetiklendiğinde yeniden okur$$, TRUE, 1),
    ($$Bir NoSuchBeanDefinitionException, çünkü bean'in yapılandırması artık eşleşmiyor$$, FALSE, 2),
    ($$null, çünkü bir Config Repository dosyasını düzenlemek özelliği her zaman anında geçersiz kılar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Secrets: What Config Server Should NOT Store in Plain Text" bölümüne göre, bu ders, Config Server mevcut olsa bile, order-service'in veritabanı şifresini nasıl ele almayı önerir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$"Secrets: What Config Server Should NOT Store in Plain Text" bölümüne göre, bu ders, Config Server mevcut olsa bile, order-service'in veritabanı şifresini nasıl ele almayı önerir?$$,
           NULL, NULL,
           $$Ders, şifrenin bir ortam değişkeni olarak kaldığını, ve yalnızca gerçekten bir sır olmayan yapılandırmanın merkezileştirildiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Repository özel olduğu için onu düz metin olarak Config Repository'ye taşımak$$, FALSE, 0),
    ($$Onu bir ortam değişkeni (${ORDERS_DB_PASSWORD}) olarak tutmak, ve yalnızca gerçekten bir sır olmayan yapılandırmayı merkezileştirmek$$, TRUE, 1),
    ($$Onu order-service'in kendi derlenmiş .jar dosyasının içinde saklamak$$, FALSE, 2),
    ($$Onu ihtiyacı olan her ekip üyesine elle e-posta ile göndermek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (TR pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri, bu derste Spring Cloud Config kullanırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste Spring Cloud Config kullanırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi kimlik/portu merkezileştirmeyi ve @RefreshScope'u aşırı uygulamayı hata olarak sayar; profilleri kullanmak ve sırları ortam değişkeni olarak tutmak ise önerilen yaklaşımlardır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$server.port veya spring.application.name'i Config Repository'de merkezileştirmek$$, TRUE, 0),
    ($$Ortama özgü yapılandırma override'ları için profilleri kullanmak$$, FALSE, 1),
    ($$@RefreshScope'u "ihtiyaç olur diye" her tek bean'e uygulamak$$, TRUE, 2),
    ($$Bir veritabanı şifresini bir Config Repository dosyası yerine bir ortam değişkeni olarak tutmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

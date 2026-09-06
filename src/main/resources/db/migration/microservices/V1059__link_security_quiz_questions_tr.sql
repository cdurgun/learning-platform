-- Promotion-style migration linking TR security quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/6 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Authentication vs. Authorization: Two Different Questions" bölümüne göre, ikisi arasındaki temel fark nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"Authentication vs. Authorization: Two Different Questions" bölümüne göre, ikisi arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, authentication'ın "bu kim?" sorusunu sorduğunu, authorization'ın ise bu kimliğin bu belirli şeyi yapmaya izinli olup olmadığını sorduğunu -- sonrasında gerçekleşen ayrı bir karar olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$İkisi, birbirinin yerine kullanılan, birebir aynı kontrolün iki adıdır$$, FALSE, 0),
    ($$Authentication "bu kim?" sorusunu sorar, authorization ise "bu kimlik bu belirli şeyi yapmaya izinli mi?" sorusunu sorar -- sonrasında gerçekleşen ayrı bir karar$$, TRUE, 1),
    ($$Authorization her sistemde her zaman authentication'dan önce gerçekleşir$$, FALSE, 2),
    ($$Authentication yalnızca POST isteklerine, authorization yalnızca GET isteklerine uygulanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"JWT: A Self-Contained, Verifiable Identity" bölümüne göre, api-gateway ve order-service'in ikisinin de, merkezi bir depoya geri çağrı yapmadan, aynı token'ı bağımsız olarak doğrulamasını sağlayan nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"JWT: A Self-Contained, Verifiable Identity" bölümüne göre, api-gateway ve order-service'in ikisinin de, merkezi bir depoya geri çağrı yapmadan, aynı token'ı bağımsız olarak doğrulamasını sağlayan nedir?$$,
           NULL, NULL,
           $$Ders, bir JWT'nin kriptografik imzasının, issuer'ın public key'ine sahip herkes tarafından doğrulanabileceğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$İki servis de birebir aynı bellek içi session cache'ini paylaşır$$, FALSE, 0),
    ($$Bir JWT'nin kriptografik imzası, issuer'ın public key'ine sahip herkes tarafından doğrulanabilir$$, TRUE, 1),
    ($$order-service, yeniden doğrulamadan, api-gateway'in zaten kontrol ettiği her şeye her zaman güvenir$$, FALSE, 2),
    ($$JWT'ler, her iki servisin de her istekte sorguladığı paylaşılan bir veritabanında saklanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Why the Gateway Alone Isn't Enough: Zero Trust Between Services" bölümüne göre, order-service, api-gateway'in onu zaten kontrol ettiğine güvenmek yerine JWT'yi neden kendisi doğrular?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Why the Gateway Alone Isn't Enough: Zero Trust Between Services" bölümüne göre, order-service, api-gateway'in onu zaten kontrol ettiğine güvenmek yerine JWT'yi neden kendisi doğrular?$$,
           NULL, NULL,
           $$Ders, api-gateway'i atlayan herhangi bir yolun -- yanlış yapılandırılmış bir route, doğrudan bir dahili çağrı -- aksi halde hiçbir korumaya sahip olmayacağını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$Çünkü api-gateway teknik olarak JWT'leri hiç doğrulayamaz$$, FALSE, 0),
    ($$Çünkü api-gateway'i atlayan herhangi bir yol (yanlış yapılandırılmış bir route, doğrudan bir dahili çağrı) aksi halde hiçbir korumaya sahip olmazdı$$, TRUE, 1),
    ($$Çünkü bir JWT'yi iki kez doğrulamak, JWT spesifikasyonunun kendisi tarafından zorunlu kılınır$$, FALSE, 2),
    ($$Çünkü order-service ve api-gateway uyumsuz JWT formatları kullanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (TR pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki OrderServiceSecurityConfig göz önüne alındığında, POST /orders'a, geçerli ve doğru şekilde imzalanmış bir JWT taşıyan bir istek geliyor -- ama bu JWT'nin kimliğinin customer rolü yok. Hangi HTTP durumu döner?$$
      AND code_snippet = $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki OrderServiceSecurityConfig göz önüne alındığında, POST /orders'a, geçerli ve doğru şekilde imzalanmış bir JWT taşıyan bir istek geliyor -- ama bu JWT'nin kimliğinin customer rolü yok. Hangi HTTP durumu döner?$$,
           $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$, $$java$$,
           $$Gerçek OrderServiceSecurityConfig.java, özellikle POST /orders için hasRole("customer") gerektirir -- authenticate edilmiş ama yetkisiz bir kimlik 401 değil, 403 Forbidden alır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$200 OK, çünkü rolden bağımsız olarak geçerli bir JWT yeterlidir$$, FALSE, 0),
    ($$401 Unauthorized, çünkü token'ın kendisi geçersiz sayılır$$, FALSE, 1),
    ($$403 Forbidden, çünkü authentication başarılı oldu ama bu kimlik bu belirli eylem için yetkili değil$$, TRUE, 2),
    ($$404 Not Found, çünkü /orders, yetkisiz kimliklerden gizlenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Propagating Identity: The Correlation Id's Security Counterpart" bölümüne göre, order-service, inventory-service'i çağırırken RestClientBearerTokenInterceptor eksikse ne olur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Propagating Identity: The Correlation Id's Security Counterpart" bölümüne göre, order-service, inventory-service'i çağırırken RestClientBearerTokenInterceptor eksikse ne olur?$$,
           NULL, NULL,
           $$Ders, orijinal harici istek düzgün şekilde authenticate edilmiş olsa bile, inventory-service'in tamamen authenticate edilmemiş bir istek alacağını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$Çağrı hemen bir compilation hatasıyla başarısız olur$$, FALSE, 0),
    ($$Orijinal harici istek düzgün şekilde authenticate edilmiş olsa bile, inventory-service tamamen authenticate edilmemiş bir istek alır$$, TRUE, 1),
    ($$order-service'in kendi JWT'si, giden çağrı için otomatik olarak yeniden üretilir$$, FALSE, 2),
    ($$inventory-service, order-service'e koşulsuz olarak güvenmeye geri döner$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (TR pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin güvenlik tasarımı hakkındaki aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin güvenlik tasarımı hakkındaki aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin gerçek örnekleri, api-gateway'in reaktif @EnableWebFluxSecurity'yi, order-service'in ise servlet tabanlı @EnableWebSecurity'yi kullandığını gösterir, ve sağlık kontrolü endpoint'leri bilinçli olarak açık tutulur.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$api-gateway, reaktif güvenlik yapılandırma tarzını (@EnableWebFluxSecurity) kullanırken, order-service servlet tabanlı tarzı (@EnableWebSecurity) kullanır$$, TRUE, 0),
    ($$401 Unauthorized ve 403 Forbidden birebir aynı anlama gelir ve birbirinin yerine kullanılabilir$$, FALSE, 1),
    ($$Sağlık kontrolü endpoint'leri (/actuator/health), yük dengeleyicilerin onlara token olmadan ulaşması gerektiği için bilinçli olarak açık tutulur$$, TRUE, 2),
    ($$api-gateway bir JWT'yi doğruladıktan sonra, bu kurstaki başka hiçbir servisin onu tekrar doğrulamasına gerek yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

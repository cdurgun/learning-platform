-- Links the TR react-spring-boot-deployment questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Vercel hangi tür uygulamalar için tasarlanmıştır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Vercel hangi tür uygulamalar için tasarlanmıştır?$$,
           NULL, NULL,
           $$Vercel statik siteler ve kısa ömürlü serverless fonksiyonlar için tasarlanmıştır. Spring Boot'un ihtiyaç duyduğu, gömülü Tomcat ile sürekli çalışan Java sunucu sürecini barındıramaz; bu yüzden backend uzun süre çalışan sunucular için kurulmuş ayrı bir platforma deploy edilir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Sürekli çalışan Java sunucu süreçleri için$$, FALSE, 0),
        ($$Gömülü Tomcat ile çalışan Spring Boot uygulamaları için$$, FALSE, 1),
        ($$Statik siteler ve kısa ömürlü serverless fonksiyonlar için$$, TRUE, 2),
        ($$Uzun süre açık kalan veritabanı sunucuları için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yerel geliştirme sırasında `VITE_API_BASE_URL` neyi gösterir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Yerel geliştirme sırasında `VITE_API_BASE_URL` neyi gösterir?$$,
           NULL, NULL,
           $$Yerelde bu değişken `localhost:8080`'de çalışan Spring Boot uygulamasını gösterir. Production'da ise Vercel'in ortam değişkenlerinde, Render'ın verdiği gerçek adresi gösterir; kod iki durumda da aynıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Render'ın verdiği gerçek backend adresini$$, FALSE, 0),
        ($$Vercel'in verdiği frontend adresini$$, FALSE, 1),
        ($$`dist/` klasöründeki statik dosyaları$$, FALSE, 2),
        ($$`localhost:8080`'de çalışan Spring Boot uygulamasını$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Deploy edilmiş bir Spring Boot backend'inden veri çeken component hangi kalıbı kullanır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Deploy edilmiş bir Spring Boot backend'inden veri çeken component hangi kalıbı kullanır?$$,
           NULL, NULL,
           $$Daha önce görülen `useEffect` + `fetch` + yükleniyor/hata kalıbının aynısı kullanılır. Karşı tarafta `json-server` yerine gerçek bir Spring Boot uygulamasının olması component'i etkilemez; `fetch` yalnızca bir URL ve bir JSON yanıtı görür.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Daha önce görülen `useEffect` + `fetch` + yükleniyor/hata kalıbının aynısını$$, TRUE, 0),
        ($$Yalnızca production'da çalışan, Vercel'e özel bir kalıbı$$, FALSE, 1),
        ($$`fetch` yerine veritabanına doğrudan bağlanan bir kalıbı$$, FALSE, 2),
        ($$Her istekten önce sayfayı baştan yükleyen bir kalıbı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Gerçek bir deployment'ta backend, izin verdiği origin'i nereden okur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Gerçek bir deployment'ta backend, izin verdiği origin'i nereden okur?$$,
           NULL, NULL,
           $$İzin verilen origin, `application.properties` üzerinden `CORS_ALLOWED_ORIGIN` ortam değişkeninden gelir. Bu değişkeni Vercel'in verdiği gerçek adresle doldurmak yeterlidir; koda sabit bir domain yazılmaz ve kod değişmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Koda sabit olarak yazılmış bir domain'den$$, FALSE, 0),
        ($$`CORS_ALLOWED_ORIGIN` ortam değişkeninden; kod değişmez$$, TRUE, 1),
        ($$Tarayıcının her istekte gönderdiği bir başlıktan$$, FALSE, 2),
        ($$Vercel'in kendiliğinden ürettiği bir dosyadan$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Backend'deki `CORS_ALLOWED_ORIGIN` hiç doldurulmazsa tarayıcıda ne görülür?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Backend'deki `CORS_ALLOWED_ORIGIN` hiç doldurulmazsa tarayıcıda ne görülür?$$,
           NULL, NULL,
           $$Frontend backend'e ulaşır, ama tarayıcı yanıtı JavaScript'e vermeyi reddeder. Bu yüzden Network sekmesinde başarılı (200) bir istek, konsolda ise bir CORS hatası görülür. İstek gönderilmemiş ya da 404 dönmüş değildir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Network sekmesinde 404 ile sonuçlanan bir istek$$, FALSE, 0),
        ($$Hiç gönderilmemiş bir istek ve boş bir Network sekmesi$$, FALSE, 1),
        ($$Network sekmesinde başarılı (200) bir istek, konsolda bir CORS hatası$$, TRUE, 2),
        ($$Başarılı bir istek ve normal biçimde gösterilen veri$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

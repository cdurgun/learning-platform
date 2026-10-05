-- Links the TR what-is-react questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React'te bir web sayfası nasıl oluşturulur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$React'te bir web sayfası nasıl oluşturulur?$$,
           NULL, NULL,
           $$React'te sayfa, component adı verilen küçük ve yeniden kullanılabilir parçalara bölünür; bütün sayfa bu parçaların birleştirilmesiyle kurulur. Arayüzün tek parça hâlinde yazılması, React'in çözmeye çalıştığı durumun kendisidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Tüm arayüz tek bir büyük dosyada, tek parça yazılarak$$, FALSE, 0),
        ($$Her sayfa için ayrı bir HTML dosyası elle hazırlanarak$$, FALSE, 1),
        ($$Küçük, yeniden kullanılabilir component'ler birleştirilerek$$, TRUE, 2),
        ($$Sayfa her tıklamada sunucuda baştan üretilerek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React'ten önce, sayfadaki bir sayacı artırmak genellikle ne gerektiriyordu?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$React'ten önce, sayfadaki bir sayacı artırmak genellikle ne gerektiriyordu?$$,
           NULL, NULL,
           $$React'ten önce DOM'a elle dokunmak gerekiyordu: doğru elementi bulan ve onu değiştiren kodu geliştirici kendisi yazardı, sayfa büyüdükçe de bunu takip etmek zorlaşırdı. Yalnızca veriyi değiştirip arayüzün kendiliğinden güncellenmesi, React'in getirdiği yaklaşımdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Yalnızca veriyi değiştirmeyi; arayüz kendiliğinden güncellenirdi$$, FALSE, 0),
        ($$Sayacı ayrı bir component olarak tanımlamayı$$, FALSE, 1),
        ($$Sayfanın tamamını sunucudan yeniden istemeyi$$, FALSE, 2),
        ($$Doğru elementi bulup onu elle değiştiren kodu yazmayı$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Angular gibi bir framework'ü, React gibi bir library'den ayıran nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Angular gibi bir framework'ü, React gibi bir library'den ayıran nedir?$$,
           NULL, NULL,
           $$Bir framework routing, form yönetimi, HTTP istekleri gibi pek çok şeyi kendi kurallarıyla hazır sunar ve onun yapısı içinde çalışılır. Yalnızca arayüzün nasıl kurulacağına odaklanmak ise library'nin, yani React'in tanımıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Routing ve form yönetimi gibi pek çok şeyi kendi kurallarıyla hazır sunması$$, TRUE, 0),
        ($$Yalnızca arayüzün nasıl kurulacağı sorusuna odaklanması$$, FALSE, 1),
        ($$Ek ihtiyaçlar için ayrı kütüphanelerin seçilip eklenmesini gerektirmesi$$, FALSE, 2),
        ($$Yalnızca mobil uygulama geliştirmek için kullanılabilmesi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir SPA'nın kullanıcıya daha hızlı ve akıcı gelmesinin sebebi nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir SPA'nın kullanıcıya daha hızlı ve akıcı gelmesinin sebebi nedir?$$,
           NULL, NULL,
           $$SPA'da bir bağlantıya tıklandığında tarayıcı sayfayı baştan yüklemez; JavaScript yalnızca değişmesi gereken kısmı günceller. Bu yüzden sayfalar arasında kısa süreli beyaz "yeniden yükleniyor" görüntüsü oluşmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Tüm sayfalar baştan itibaren aynı anda ekranda durur$$, FALSE, 0),
        ($$Tıklamada sayfanın tamamı değil, yalnızca değişen kısmı güncellenir$$, TRUE, 1),
        ($$Her tıklamada sayfa sunucudan daha hızlı yeniden indirilir$$, FALSE, 2),
        ($$Uygulama internet bağlantısına hiç ihtiyaç duymaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki eşleştirmelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki eşleştirmelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$React'in temel fikirleri iOS/Android uygulamalarında React Native ile, masaüstü uygulamalarında Electron gibi araçlarla kullanılır. React Router web uygulamaları için bir routing kütüphanesidir; Angular ise React'i başka bir ortamda çalıştıran bir araç değil, ayrı bir framework'tür.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Mobil uygulamalar: React Router$$, FALSE, 0),
        ($$Masaüstü uygulamaları: Angular$$, FALSE, 1),
        ($$Mobil uygulamalar: React Native$$, TRUE, 2),
        ($$Masaüstü uygulamaları: Electron gibi araçlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

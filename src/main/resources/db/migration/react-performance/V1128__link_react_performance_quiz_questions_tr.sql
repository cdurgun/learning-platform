-- Links the TR react-performance questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/4 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Gereksiz yeniden render'lar ne zaman gerçek bir sorun hâline gelir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Gereksiz yeniden render'lar ne zaman gerçek bir sorun hâline gelir?$$,
           NULL, NULL,
           $$Küçük component'lerde bu bir sorun değildir. Büyük listelerde ya da karmaşık hesaplamalarda ise fark edilir yavaşlamalara yol açabilir; optimizasyon da ancak o noktada anlam kazanır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$Her durumda; en küçük component'lerde bile mutlaka önlenmelidir$$, FALSE, 0),
        ($$Yalnızca component hiç prop almadığında$$, FALSE, 1),
        ($$Büyük listelerde ya da karmaşık hesaplamalarda, fark edilir yavaşlamaya yol açtığında$$, TRUE, 2),
        ($$Yalnızca uygulama geliştirme modunda çalışırken$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/4 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`memo()` ile sarılmış bir component ne zaman yeniden render edilir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`memo()` ile sarılmış bir component ne zaman yeniden render edilir?$$,
           NULL, NULL,
           $$`memo()`, component'i prop'ları değişmediği sürece yeniden render edilmeyecek şekilde sarar. Üst component'in render edilmesi tek başına yeterli değildir; React önce yeni prop'ları bir önceki render'dakilerle karşılaştırır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$Üst component her render edildiğinde$$, FALSE, 0),
        ($$İlk render'dan sonra hiçbir zaman$$, FALSE, 1),
        ($$Yalnızca içinde `useMemo` kullanılıyorsa$$, FALSE, 2),
        ($$Yalnızca prop'ları değiştiğinde$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/4 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`memo` ile sarılmış bir component'e fonksiyon prop'u geçerken `useCallback` ne sağlar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`memo` ile sarılmış bir component'e fonksiyon prop'u geçerken `useCallback` ne sağlar?$$,
           NULL, NULL,
           $$`useCallback`, bağımlılıkları değişmediği sürece aynı fonksiyon referansını korur. Böylece `memo` prop'un değişmediğini görür ve render'ı atlayabilir. Fonksiyonun sonucunu önbelleğe almaz; o, `useMemo`'nun işidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$Bağımlılıkları değişmediği sürece aynı fonksiyon referansının korunmasını$$, TRUE, 0),
        ($$Fonksiyonun döndürdüğü sonucun önbelleğe alınmasını$$, FALSE, 1),
        ($$Fonksiyonun yalnızca bir kez çağrılabilmesini$$, FALSE, 2),
        ($$Alt component'in bir daha hiç render edilmemesini$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/4 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Pahalı bir hesaplama `useMemo` ile sarılmışken component başka bir sebeple, örneğin bir sayaç değiştiği için yeniden render edilirse ne olur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Pahalı bir hesaplama `useMemo` ile sarılmışken component başka bir sebeple, örneğin bir sayaç değiştiği için yeniden render edilirse ne olur?$$,
           NULL, NULL,
           $$Hesaplamanın bağımlılığı değişmediği için hesaplama yeniden çalışmaz; önceki sonuç kullanılır. Component'in kendisi yine render edilir; atlanan yalnızca pahalı hesaplamadır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$Hesaplama her render'da olduğu gibi yeniden çalışır$$, FALSE, 0),
        ($$Hesaplama yeniden çalışmaz; önceki sonuç kullanılır$$, TRUE, 1),
        ($$Component'in render'ı tümüyle atlanır$$, FALSE, 2),
        ($$Hesaplama bir sonraki render'a ertelenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR use-effect quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir side effect (yan etki) nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir side effect (yan etki) nedir?$$,
           NULL, NULL,
           $$Bir side effect, bir component'in kendi render çıktısının (döndürdüğü JSX'in) DIŞINDA yaptığı bir şeydir: tab başlığını değiştirmek, bir zamanlayıcı kurmak, veri getirmek, localStorage'a yazmak vb.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$Props gelmeden önce bir component'in döndürdüğü varsayılan değer$$, FALSE, 0),
    ($$Bir component'in kendi render çıktısının dışında yaptığı bir şey, tab başlığını değiştirmek ya da veri getirmek gibi$$, TRUE, 1),
    ($$Koşullu bir operatör kullanan herhangi bir JSX ifadesi$$, FALSE, 2),
    ($$Bir JSX tag'ini kapatmayı unutmaktan kaynaklanan bir hata$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useEffect'e verilen fonksiyon, render'a göre gerçekte ne zaman çalışır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$useEffect'e verilen fonksiyon, render'a göre gerçekte ne zaman çalışır?$$,
           NULL, NULL,
           $$useEffect'e bir fonksiyon verirsin; React o fonksiyonu render bittikten SONRA çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$Render ile tam olarak aynı anda, ayrı bir thread üzerinde$$, FALSE, 0),
    ($$Yalnızca bir kez, uygulama ilk kez açıldığında, component'ten bağımsız olarak$$, FALSE, 1),
    ($$Render bittikten sonra$$, TRUE, 2),
    ($$Render başlamadan önce, böylece ne render edileceğine karar verebilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Component toplam 5 kez render edilirse (ilk render artı state kaynaklı 4 yeniden render) bu effect kaç kez çalışır?$$
      AND code_snippet = $$useEffect(() => {
    console.log("Effect calisti");
}, []);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Component toplam 5 kez render edilirse (ilk render artı state kaynaklı 4 yeniden render) bu effect kaç kez çalışır?$$,
           $$useEffect(() => {
    console.log("Effect calisti");
}, []);$$, $$jsx$$,
           $$Boş bir dependency array [] ile, effect yalnızca bir kez, component ekranda ilk göründüğünde (mount olduğunda) çalışır -- sonraki render'larda tekrar çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$5 kez, her render'da bir kez$$, FALSE, 0),
    ($$4 kez, her yeniden render'da bir kez, ama ilk render'da değil$$, FALSE, 1),
    ($$0 kez, çünkü boş bir dizi effect'in asla çalışmadığı anlamına gelir$$, FALSE, 2),
    ($$1 kez, yalnızca ilk render'da (mount)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$ad değişiyor, ama sayi aynı kalıyor. Bu effect çalışır mı?$$
      AND code_snippet = $$useEffect(() => {
    console.log("sayi degisti");
}, [sayi]);
// Bu render'da yalnizca "ad" degisti, "sayi" degil.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$ad değişiyor, ama sayi aynı kalıyor. Bu effect çalışır mı?$$,
           $$useEffect(() => {
    console.log("sayi degisti");
}, [sayi]);
// Bu render'da yalnizca "ad" degisti, "sayi" degil.$$, $$jsx$$,
           $$[sayi] dependency array'i ile, effect yalnızca sayi değiştiğinde çalışır -- ad değişse bile tetiklenmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$Hayır -- effect yalnızca sayi değiştiğinde çalışır, ve burada sayi değişmedi$$, TRUE, 0),
    ($$Evet -- component'teki herhangi bir state değişikliği her effect'i tetikler$$, FALSE, 1),
    ($$Evet, ama yalnızca ad, sayi ile alfabetik olarak ilişkili olduğu için$$, FALSE, 2),
    ($$Hangisinin useState ile önce tanımlandığına bağlıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React, bir effect'ten döndürülen cleanup fonksiyonunu ne zaman çağırır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$React, bir effect'ten döndürülen cleanup fonksiyonunu ne zaman çağırır?$$,
           NULL, NULL,
           $$React, cleanup fonksiyonunu component ekrandan kaldırıldığında (unmount olduğunda) ya da effect tekrar çalışmadan hemen önce otomatik olarak çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$Hiçbir zaman otomatik olarak -- kodun başka bir yerinde elle çağrılmalıdır$$, FALSE, 0),
    ($$Component unmount olduğunda, ya da effect tekrar çalışmadan hemen önce$$, TRUE, 1),
    ($$Hemen, effect'in kendi fonksiyon gövdesi hiç çalışmadan önce$$, FALSE, 2),
    ($$Yalnızca tarayıcı sekmesi tamamen kapatıldığında$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useEffect'e hiç dependency array verilmediğinde ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$useEffect'e hiç dependency array verilmediğinde ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dependency array'i olmayan bir useEffect, her render'dan SONRA çalışır -- bu, hem []'ten (bir kez) hem de [value]'dan (yalnızca value değiştiğinde) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
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
    ($$Bu davranış, boş bir dizi [] geçirmekten farklıdır$$, TRUE, 0),
    ($$Boş bir dependency array [] geçirmekle birebir aynı şekilde davranır$$, FALSE, 1),
    ($$Bir dependency array açıkça sağlanmadıkça effect hiç çalışmaz$$, FALSE, 2),
    ($$Effect, her tek render'dan sonra çalışır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-effect')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste ele alınan sonsuz döngü hatasını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste ele alınan sonsuz döngü hatasını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Hata, dependency array'i unutup effect içinde state güncellemektir; effect her render'dan sonra çalışır, ve state güncellerse bu yeni bir render tetikler, bu da effect'i tekrar çalıştırır, sonsuz bir döngü oluşur. Çözüm, dependency array'i doğru şekilde kurmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-effect'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$Dependency array'i olmayan bir useEffect kendi içinde state güncellediğinde gerçekleşir$$, TRUE, 0),
    ($$Effect içindeki her state güncellemesi yeni bir render tetikler, bu da effect'i tekrar çalıştırır$$, TRUE, 1),
    ($$Çözüm, useEffect'i tamamen kaldırıp bu mantık için bir daha asla kullanmamaktır$$, FALSE, 2),
    ($$Bu hata yalnızca dependency array'i birden fazla değer içerdiğinde gerçekleşir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-effect'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

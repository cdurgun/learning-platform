-- Promotion-style migration linking TR events quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React, tıklama ve yazma gibi kullanıcı eylemlerini yakalamak için sana ne verir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$React, tıklama ve yazma gibi kullanıcı eylemlerini yakalamak için sana ne verir?$$,
           NULL, NULL,
           $$onClick, onChange, onSubmit gibi hazır attribute'lar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$Yerleşik hiçbir şey -- ham tarayıcı DOM event kodunu kendin yazmalısın$$, FALSE, 0),
    ($$onClick, onChange ve onSubmit gibi hazır attribute'lar$$, TRUE, 1),
    ($$Her tür eylem için tek, evrensel bir onUserAction attribute'u$$, FALSE, 2),
    ($$Elle örneklemen gereken ayrı bir EventListener sınıfı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu component render edildiğinde ne olur?$$
      AND code_snippet = $$function selamVer() {
    console.log("Merhaba!");
}

function Selamlayici() {
    return <button onClick={selamVer()}>Selam Ver</button>;
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu component render edildiğinde ne olur?$$,
           $$function selamVer() {
    console.log("Merhaba!");
}

function Selamlayici() {
    return <button onClick={selamVer()}>Selam Ver</button>;
}$$, $$jsx$$,
           $$selamVer() yazmak, component render edilir edilmez fonksiyonu hemen çağırır ve sonucunu (undefined) onClick'e verir -- bu yüzden "Merhaba!" hiçbir tıklama olmadan hemen loglanır, ve düğmeye tıklamak hiçbir şey yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$selamVer() undefined döndürdüğü için hiçbir şey loglanmaz$$, FALSE, 0),
    ($$React bir hata fırlatır, çünkü onClick her zaman adlandırılmış bir fonksiyon referansı olmalıdır$$, FALSE, 1),
    ($$Component render edildiğinde "Merhaba!" hemen loglanır, ve düğmeye tıklamak hiçbir şey yapmaz$$, TRUE, 2),
    ($$Beklendiği gibi, düğmeye her tıklandığında "Merhaba!" loglanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir event handler, ayrı adlandırılmış bir fonksiyon yerine doğrudan inline olarak yazılabilir mi?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir event handler, ayrı adlandırılmış bir fonksiyon yerine doğrudan inline olarak yazılabilir mi?$$,
           NULL, NULL,
           $$Evet -- bir event handler, adlandırılmış bir fonksiyon olarak ya da doğrudan inline olarak yazılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$Hayır -- React yalnızca önceden tanımlanmış, adlandırılmış bir fonksiyon referansı kabul eder$$, FALSE, 0),
    ($$Yalnızca onSubmit inline handler'ları destekler; onClick desteklemez$$, FALSE, 1),
    ($$Yalnızca class component'ler inline event handler kullanabilir$$, FALSE, 2),
    ($$Evet -- bir event handler, adlandırılmış bir fonksiyon olarak ya da doğrudan inline olarak yazılabilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir onChange event handler'ı, kullanıcının bir input'a az önce ne yazdığını nasıl okur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir onChange event handler'ı, kullanıcının bir input'a az önce ne yazdığını nasıl okur?$$,
           NULL, NULL,
           $$Event handler otomatik olarak bir event nesnesi alır, ve az önce yazılan şey event.target.value ile okunur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$Handler'a otomatik olarak geçirilen event nesnesini kullanarak, event.target.value ile$$, TRUE, 0),
    ($$React'in global olarak sağladığı ayrı bir getInputValue() fonksiyonunu çağırarak$$, FALSE, 1),
    ($$Yazılan değer, handler'ın ilk düz string argümanı olarak doğrudan geçirilir$$, FALSE, 2),
    ($$onChange yazılan değeri okuyamaz -- yalnızca onSubmit okuyabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir formun onSubmit handler'ı event.preventDefault()'u ÇAĞIRMIYOR. Kullanıcı formu gönderdiğinde ne olur?$$
      AND code_snippet = $$function GirisFormu() {
    function handleSubmit(event) {
        console.log("Gonderildi!");
        // event.preventDefault() eksik
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir formun onSubmit handler'ı event.preventDefault()'u ÇAĞIRMIYOR. Kullanıcı formu gönderdiğinde ne olur?$$,
           $$function GirisFormu() {
    function handleSubmit(event) {
        console.log("Gonderildi!");
        // event.preventDefault() eksik
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$preventDefault() olmadan, tarayıcı kendi varsayılan davranışına döner ve sayfayı yeniden yükler -- React uygulamalarının neredeyse hiç istemediği bir şey.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$React her formda otomatik olarak preventDefault()'u çağırır$$, FALSE, 0),
    ($$"Gonderildi!" loglanır, ve tarayıcı da kendi varsayılan davranışına döner ve sayfayı yeniden yükler$$, TRUE, 1),
    ($$Yalnızca "Gonderildi!" loglanır ve başka hiçbir şey olmaz$$, FALSE, 2),
    ($$Form gönderimi sessizce iptal edilir ve hiçbir şey loglanmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir event handler içinde event.type sana ne verir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir event handler içinde event.type sana ne verir?$$,
           NULL, NULL,
           $$event.type sana "click", "change", "submit" gibi olayın türünü verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$Bu handler'ın şu ana kadar kaç kez çalıştığının bir sayımı$$, FALSE, 0),
    ($$Elementi render eden component'in adı$$, FALSE, 1),
    ($$"click", "change" ya da "submit" gibi gerçekleşen olayın türü$$, TRUE, 2),
    ($$Olayın gerçekleştiği input'un mevcut değeri$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'events')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, React'in event handling'i ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, React'in event handling'i ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her event handler otomatik olarak React'ten bir event nesnesi alır; onClick={f}, fonksiyonun kendisini verir (React onu daha sonra çağırır); event.target, olayın gerçekleştiği DOM elementini verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'events'
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
    ($$Her event handler otomatik olarak React'ten bir event nesnesi alır$$, TRUE, 0),
    ($$onClick={f}, fonksiyonun kendisini verir, ve React onu doğru zamanda senin için çağırır$$, TRUE, 1),
    ($$event.target, olayın gerçekleştiği DOM elementini verir$$, TRUE, 2),
    ($$preventDefault(), onClick dahil her tek event handler'da zorunludur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'events'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

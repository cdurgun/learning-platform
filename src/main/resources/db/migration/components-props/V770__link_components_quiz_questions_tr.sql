-- Promotion-style migration linking TR components quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$En basit haliyle, bir React component'i nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$En basit haliyle, bir React component'i nedir?$$,
           NULL, NULL,
           $$Bir component, JSX döndüren sıradan bir JavaScript fonksiyonudur -- yeni bir sözdizimi ya da özel bir anahtar kelime gerekmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$İçine JavaScript gömülmüş bir HTML dosyası$$, FALSE, 0),
    ($$JSX döndüren sıradan bir JavaScript fonksiyonu$$, TRUE, 1),
    ($$Bir React temel sınıfını extend etmesi gereken özel bir sınıf$$, FALSE, 2),
    ($$Bir UI parçasını tanımlayan bir JSON yapılandırma dosyası$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yazdığın bir component'i JSX içinde nasıl "kullanırsın" (render edersin)?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Yazdığın bir component'i JSX içinde nasıl "kullanırsın" (render edersin)?$$,
           NULL, NULL,
           $$Onu, tıpkı <h1> ya da <div> yazar gibi, bir tag olarak yazarsın, örneğin <Welcome />.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$Doğrudan bir HTML <script> tag'ine import ederek$$, FALSE, 0),
    ($$Özel bir components.json dosyasına ekleyerek$$, FALSE, 1),
    ($$JSX içinde onu bir tag olarak yazarak, örneğin <Welcome />$$, TRUE, 2),
    ($$Sade bir fonksiyon olarak çağırarak: Welcome()$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React, bir component'i sıradan bir HTML tag'inden nasıl ayırt eder?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$React, bir component'i sıradan bir HTML tag'inden nasıl ayırt eder?$$,
           NULL, NULL,
           $$Adın büyük harfle mi yoksa küçük harfle mi başladığına bakarak -- büyük harf component, küçük harf sıradan bir HTML tag'i demektir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$Fonksiyonun herhangi bir parametresi olup olmadığını kontrol ederek$$, FALSE, 0),
    ($$Fonksiyonun "function" kelimesiyle mi yoksa arrow function olarak mı tanımlandığını kontrol ederek$$, FALSE, 1),
    ($$Dosya adının .jsx ile bitip bitmediğini kontrol ederek$$, FALSE, 2),
    ($$Adın büyük harfle mi yoksa küçük harfle mi başladığına bakarak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu JSX render edildiğinde React ne yapar?$$
      AND code_snippet = $$function selamla() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <selamla />;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu JSX render edildiğinde React ne yapar?$$,
           $$function selamla() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <selamla />;
}$$, $$jsx$$,
           $$Ad küçük harfle başladığı için, React <selamla />'yı selamla fonksiyon component'i olarak değil, sıradan (tanınmayan) bir HTML tag'i olarak ele alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$React <selamla />'yı selamla fonksiyon component'i olarak değil, sıradan (tanınmayan) bir HTML tag'i olarak ele alır$$, TRUE, 0),
    ($$React beklendiği gibi h1 "Merhaba!" metnini render eder$$, FALSE, 1),
    ($$React derleme hatası fırlatır, çünkü component adları büyük harfle başlamalıdır$$, FALSE, 2),
    ($$React adı otomatik olarak büyük harfe çevirir ve doğru render eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir şeyi component olarak yazmanın en büyük faydası nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir şeyi component olarak yazmanın en büyük faydası nedir?$$,
           NULL, NULL,
           $$Bir kez yaz, istediğin kadar kullan -- aynı component, her seferinde aynı HTML'i yeniden yazmadan birden fazla kez render edilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$Component'ler hiç JavaScript yazma ihtiyacını ortadan kaldırır$$, FALSE, 0),
    ($$Bir kez yaz, istediğin kadar kullan$$, TRUE, 1),
    ($$Component'ler her zaman düz HTML'den daha hızlı çalışır$$, FALSE, 2),
    ($$Component'ler otomatik olarak kendi verilerini bir sunucudan getirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, component'leri başka component'lerin içinde kullanmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, component'leri başka component'lerin içinde kullanmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir component başka bir component'in içinde kullanılabilir (App'in Welcome kullanması gibi), ve bu, başka herhangi bir component kullanımıyla aynı tag sözdizimiyle yapılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$Başka bir component'in içinde kullanılan bir component yine de aynı büyük harf kuralına uyar$$, TRUE, 0),
    ($$Bir component, tüm uygulama boyunca yalnızca bir kez kullanılabilir$$, FALSE, 1),
    ($$Bir component'i başka birinin içinde kullanmak özel bir nested anahtar kelimesi gerektirir$$, FALSE, 2),
    ($$Bir component, App'in Welcome kullanması gibi, başka bir component'in içinde kullanılabilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu koda göre, ekranda gerçekte ne görünür?$$
      AND code_snippet = $$function Selam() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <div>App icerigi</div>;
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu koda göre, ekranda gerçekte ne görünür?$$,
           $$function Selam() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <div>App icerigi</div>;
}$$, $$jsx$$,
           $$Selam'dan hiçbir şey görünmez -- bir component fonksiyonunu tanımlamak onu render etmez; bir component ancak bir yerde gerçekten bir tag olarak kullanıldığında (render edildiğinde) ekranda görünür, ve Selam burada hiç kullanılmıyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'components'
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
    ($$Selam tanımlandığı için hem "Merhaba!" hem "App icerigi" görünür$$, FALSE, 0),
    ($$Yalnızca "App icerigi" görünür -- Selam tanımlanmış ama hiçbir yerde render edilmemiş$$, TRUE, 1),
    ($$Yalnızca "Merhaba!" görünür, çünkü önce tanımlanmış$$, FALSE, 2),
    ($$App, Selam()'ı açıkça çağırmadığı için ikisi de görünmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

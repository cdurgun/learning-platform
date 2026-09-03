-- Promotion-style migration linking TR props quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Props nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Props nedir?$$,
           NULL, NULL,
           $$Props, bir component'e dışarıdan veri göndermenin yoludur -- bir HTML tag'ine attribute vermeye çok benzer, ama değer component fonksiyonuna bir parametre olarak ulaşır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$Bir component unmount olduğunda otomatik çalışan bir fonksiyon$$, FALSE, 0),
    ($$Bir component'e dışarıdan, ona attribute verir gibi veri gönderme yolu$$, TRUE, 1),
    ($$Bir component'in zamanla değişen dahili verisi$$, FALSE, 2),
    ($$Component'ler için özel bir CSS stillendirme mekanizması$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$App, <Greeting name="Ayşe" />'yi render ediyorsa, bu hangi ilişkiyi kurar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$App, <Greeting name="Ayşe" />'yi render ediyorsa, bu hangi ilişkiyi kurar?$$,
           NULL, NULL,
           $$App, Greeting'i (child) kullanan parent'tır ve bu, Greeting'e "Ayşe" değerine sahip name adında bir prop gönderir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$Bu, App içinde name adında yeni bir state değişkeni oluşturur$$, FALSE, 0),
    ($$Bu geçersiz bir sözdizimidir -- props yalnızca ayrı bir fonksiyon çağrısı olarak geçirilebilir$$, FALSE, 1),
    ($$App parent'tır, Greeting child'tır ve Greeting name adında bir prop alır$$, TRUE, 2),
    ($$Greeting parent'tır, App child'tır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu render'a göre, KullaniciKarti sehir değerine nasıl erişir?$$
      AND code_snippet = $$<KullaniciKarti ad="Ali" yas={30} sehir="Ankara" />

function KullaniciKarti(props) {
    return <p>{props.sehir}</p>;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu render'a göre, KullaniciKarti sehir değerine nasıl erişir?$$,
           $$<KullaniciKarti ad="Ali" yas={30} sehir="Ankara" />

function KullaniciKarti(props) {
    return <p>{props.sehir}</p>;
}$$, $$jsx$$,
           $$Her prop, props nesnesinde kendi alanı olarak component'e ulaşır -- bu yüzden sehir, props.sehir olarak okunur ve "Ankara" yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$props[2], çünkü sehir yazılan üçüncü attribute'tur$$, FALSE, 0),
    ($$props.ad.sehir, çünkü props'lar iç içedir$$, FALSE, 1),
    ($$Önce destructuring yapmadan sehir'e hiç erişemez$$, FALSE, 2),
    ($$props.sehir, bu da "Ankara" yazdırır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$function Selamla({ ad }) { return <p>{ad}</p>; } ile function Selamla(props) { return <p>{props.ad}</p>; } karşılaştırıldığında, bu ikisi arasındaki ilişki nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$function Selamla({ ad }) { return <p>{ad}</p>; } ile function Selamla(props) { return <p>{props.ad}</p>; } karşılaştırıldığında, bu ikisi arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$İki versiyon da tam olarak aynı şeyi yapar -- destructuring yalnızca tekrarlanan props.'u kaldırır ve kodu biraz kısaltır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$Tam olarak aynı şeyi yaparlar -- destructuring yalnızca aynı erişimi yazmanın daha kısa bir yoludur$$, TRUE, 0),
    ($$Destructured versiyon, bir props nesnesi oluşturmayı atladığı için çalışma zamanında daha hızlıdır$$, FALSE, 1),
    ($$Destructured versiyon toplamda yalnızca bir prop okuyabilir, asla daha fazlasını okuyamaz$$, FALSE, 2),
    ($$Farklı davranırlar -- destructuring prop'u mutable yapar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ne render eder?$$
      AND code_snippet = $$function Selamla({ ad = "Misafir" }) {
    return <p>Merhaba, {ad}!</p>;
}

<Selamla />$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ne render eder?$$,
           $$function Selamla({ ad = "Misafir" }) {
    return <p>Merhaba, {ad}!</p>;
}

<Selamla />$$, $$jsx$$,
           $$ad hiç gönderilmediği için, destructuring içinde tanımlanan varsayılan değer "Misafir" kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$ad için hiçbir değer sağlanmadığından çalışma zamanı hatası fırlatır$$, FALSE, 0),
    ($$Merhaba, Misafir!$$, TRUE, 1),
    ($$Merhaba, undefined!$$, FALSE, 2),
    ($$Hiçbir şey render edilmez, çünkü ad zorunludur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir component aldığı bir prop'u doğrudan hiç değiştirmeli midir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir component aldığı bir prop'u doğrudan hiç değiştirmeli midir?$$,
           NULL, NULL,
           $$Hayır -- props salt okunurdur (read-only); bir component aldığı bir prop'u asla değiştirmemelidir. Veri zaman içinde değişmesi gerekiyorsa, bunun için state vardır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$Yalnızca prop bir sayıysa, string değilse$$, FALSE, 0),
    ($$Yalnızca bir event handler fonksiyonu içinde$$, FALSE, 1),
    ($$Hayır -- props salt okunurdur; bir component aldığı bir prop'u asla değiştirmemelidir$$, TRUE, 2),
    ($$Evet -- bir prop'un değerini yeniden atamak onu güncellemenin normal yoludur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'props')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri props ile sıradan bir fonksiyon parametresi arasındaki ilişkiyi doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri props ile sıradan bir fonksiyon parametresi arasındaki ilişkiyi doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Props, sıradan bir fonksiyon parametresinden başka bir şey değildir -- burada React'e özgü bir mekanizma yoktur; fark yalnızca fonksiyonu nasıl "çağırdığındadır" (JSX tag sözdizimi ile normal fonksiyon çağrısı).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'props'
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
    ($$Props, sıradan bir fonksiyon parametresinden başka bir şey değildir -- özel bir React mekanizması söz konusu değildir$$, TRUE, 0),
    ($$Normal bir fonksiyonu Selamla({ ad: "Ayşe" }) olarak çağırırsın, JSX içinde bir component'i ise <Selamla ad="Ayşe" /> olarak "çağırırsın"$$, TRUE, 1),
    ($$Props, JavaScript fonksiyonlarının normalde argüman almasıyla hiç ilgisi olmayan, tamamen ayrı bir mekanizma gerektirir$$, FALSE, 2),
    ($$Bir component fonksiyonunu Selamla({ad: "Ayşe"}) gibi doğrudan çağırmak geçersiz JavaScript'tir ve her zaman hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'props'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

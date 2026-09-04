-- Promotion-style migration linking TR route-parameters-navigation quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$path="/kurslar/:kursSlug" verildiğinde ve /kurslar/java ziyaret edildiğinde, component içinde kursSlug'ın değeri nasıl okunur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$path="/kurslar/:kursSlug" verildiğinde ve /kurslar/java ziyaret edildiğinde, component içinde kursSlug'ın değeri nasıl okunur?$$,
           NULL, NULL,
           $$Component içinde bu değer useParams() hook'u ile okunur; döndürülen nesnedeki key, Route'ta kullanılan adla (kursSlug) eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$Hiç okunamaz -- route parametreleri yalnızca yazma amaçlıdır$$, FALSE, 0),
    ($$Döndürülen nesnesinde bir kursSlug alanı olan useParams() hook'u ile$$, TRUE, 1),
    ($$Otomatik olarak kursSlug adında global bir değişken olarak enjekte edilir$$, FALSE, 2),
    ($$window.location.pathname okunup string elle bölünerek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Route'u başka birinin İÇİNE yazmak neyi oluşturur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Route'u başka birinin İÇİNE yazmak neyi oluşturur?$$,
           NULL, NULL,
           $$Bir Route'u başka birinin içine yazmak, nested (iç içe) bir yapı -- bir nested route -- oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$Tamamen bağımsız, ilgisiz iki sayfa$$, FALSE, 0),
    ($$Sonsuz bir yönlendirme döngüsü$$, FALSE, 1),
    ($$Nested (iç içe) bir route yapısı$$, TRUE, 2),
    ($$Route'lar asla birbirinin içine yerleştirilemeyeceği için bir sözdizimi hatası$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$KursDuzeni, parent route'un element'idir, ama içinde HİÇ <Outlet /> yoktur. Eşleşen nested child route'a ne olur?$$
      AND code_snippet = $$function KursDuzeni() {
    return (
        <div>
            <h1>Kurs Sayfasi</h1>
            {/* Burada hic <Outlet /> yok */}
        </div>
    );
}

<Route path="/kurslar/:kursSlug" element={<KursDuzeni />}>
    <Route path=":konuSlug" element={<KonuIcerigi />} />
</Route>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$KursDuzeni, parent route'un element'idir, ama içinde HİÇ <Outlet /> yoktur. Eşleşen nested child route'a ne olur?$$,
           $$function KursDuzeni() {
    return (
        <div>
            <h1>Kurs Sayfasi</h1>
            {/* Burada hic <Outlet /> yok */}
        </div>
    );
}

<Route path="/kurslar/:kursSlug" element={<KursDuzeni />}>
    <Route path=":konuSlug" element={<KonuIcerigi />} />
</Route>$$, $$jsx$$,
           $$Parent component'in içine yerleştirilen Outlet, eşleşen child route'un tam olarak nerede render edileceğini işaretler -- Outlet olmadan, path'i eşleşse bile child route hiçbir yerde görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$KonuIcerigi, ne olursa olsun KursDuzeni'nin altında otomatik olarak render edilir$$, FALSE, 0),
    ($$React, Outlet zorunlu bir sözdizimi olduğu için bir derleme zamanı hatası fırlatır$$, FALSE, 1),
    ($$KursDuzeni'nin kendisi hiç render edilemez$$, FALSE, 2),
    ($$Path'i eşleşse bile, KonuIcerigi ekranda hiçbir yerde görünmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useNavigate() hook'u sana ne verir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$useNavigate() hook'u sana ne verir?$$,
           NULL, NULL,
           $$useNavigate() hook'u bize, çağrıldığında URL'yi değiştiren bir navigate fonksiyonu verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$Çağrıldığında URL'yi değiştiren bir navigate fonksiyonu$$, TRUE, 0),
    ($$Uygulamada şu anda tanımlı olan her route'un bir listesini$$, FALSE, 1),
    ($$Mevcut sayfanın tamamen yüklenip yüklenmediğini belirten bir boolean$$, FALSE, 2),
    ($$Tarayıcının adres çubuğu DOM elementine bir referans$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu form gönderildikten sonra ne olur?$$
      AND code_snippet = $$function KursEkleFormu() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... kaydetme mantigi burada ...
        navigate("/kurslar");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu form gönderildikten sonra ne olur?$$,
           $$function KursEkleFormu() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... kaydetme mantigi burada ...
        navigate("/kurslar");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$Form "gönderildikten" sonra, kullanıcı navigate("/kurslar") ile kurs listesine yönlendirilir -- bir eylemden sonra yönlendirme için useNavigate'in yaygın bir kullanımı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$navigate("/kurslar") yalnızca bir Link component'inin içinden çağrılırsa çalışır$$, FALSE, 0),
    ($$Formun kaydetme mantığı çalıştıktan sonra kullanıcı /kurslar'a yönlendirilir$$, TRUE, 1),
    ($$URL'ye hiçbir şey olmaz -- navigate yalnızca console'a bir mesaj loglar$$, FALSE, 2),
    ($$Tarayıcı tüm sayfayı yeniden yükler ve /kurslar'ı gösterir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, navigate(-1)'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, navigate(-1)'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$navigate'e bir URL yerine tarayıcı geçmişinde ileri ya da geri gitmek için bir sayı verilebilir; navigate(-1), tarayıcının geri düğmesiyle aynı şeyi yapar ve genellikle Geri düğmeleri için tercih edilir, çünkü kullanıcıyı geldiği yere geri götürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$navigate(-1), tarayıcının "geri" düğmesiyle aynı şeyi yapar$$, TRUE, 0),
    ($$navigate(-1), geçmişten bağımsız olarak kullanıcıyı her zaman /kurslar gibi sabit bir sayfaya gönderir$$, FALSE, 1),
    ($$navigate(-1) yalnızca bir Link component'inin içinde kullanılabilir, asla bir event handler içinde değil$$, FALSE, 2),
    ($$navigate'e, tarayıcı geçmişinde ileri ya da geri gitmek için bir URL yerine bir sayı verilebilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Link'i useNavigate'ten aşağıdakilerden hangileri doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Link'i useNavigate'ten aşağıdakilerden hangileri doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Link her zaman kullanıcının bir şeye TIKLAMASINI gerektirir; useNavigate, bir tıklamaya değil bir koşula bağlı olarak, koddan sayfa değiştirmeni sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$Link, gezinmeyi tetiklemek için her zaman kullanıcının bir şeye tıklamasını gerektirir$$, TRUE, 0),
    ($$useNavigate, bir tıklamaya değil bir koşula bağlı olarak, koddan sayfa değiştirmeni sağlar$$, TRUE, 1),
    ($$useNavigate yalnızca bir Link component'inin onClick prop'unun içinden çağrılabilir$$, FALSE, 2),
    ($$Link ve useNavigate, tam olarak aynı mekanizmanın birbirinin yerine geçebilen iki adıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

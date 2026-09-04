-- Promotion-style migration linking TR react-router-basics quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir React SPA'sında, "sayfa değiştirmek" gerçekte ne anlama gelir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir React SPA'sında, "sayfa değiştirmek" gerçekte ne anlama gelir?$$,
           NULL, NULL,
           $$React uygulamaları tek bir HTML dosyası olarak çalışır; "sayfa değiştirmek", yeni bir HTML dosyası yüklemek yerine, URL'ye göre aynı sayfada FARKLI component'ler render etmek anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$Hiçbir şey değişmez -- SPA'lar her zaman tek, sabit bir ekran gösterir$$, FALSE, 0),
    ($$URL'ye göre, aynı tek HTML dosyasında farklı component'ler render etmek$$, TRUE, 1),
    ($$Tarayıcı her sayfa için tamamen yeni bir HTML dosyası yükler$$, FALSE, 2),
    ($$Sunucu yeni sayfanın önceden render edilmiş bir görüntüsünü gönderir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, her Route'un ne tanımlaması gerekir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, her Route'un ne tanımlaması gerekir?$$,
           NULL, NULL,
           $$Her Route'un bir path'i (bir URL kalıbı) ve bir element'i (o URL için gösterilecek component) vardır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$Bir CSS class'ı ve bir animasyon süresi$$, FALSE, 0),
    ($$Bir veritabanı tablo adı ve bir query string$$, FALSE, 1),
    ($$Bir path (bir URL kalıbı) ve bir element (gösterilecek component)$$, TRUE, 2),
    ($$Yalnızca bir component adı, URL ondan otomatik olarak çıkarılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Mevcut URL /hakkinda. Hangi component render edilir?$$
      AND code_snippet = $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="/hakkinda" element={<Hakkinda />} />
</Routes>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Mevcut URL /hakkinda. Hangi component render edilir?$$,
           $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="/hakkinda" element={<Hakkinda />} />
</Routes>$$, $$jsx$$,
           $$Routes, hangi Route'un eşleştiğini bulmak için URL'ye bakar; herhangi bir anda yalnızca eşleşen Route render edilir -- burada /hakkinda üçüncü Route ile eşleşir, bu yüzden Hakkinda render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$AnaSayfa, çünkü önce tanımlanmıştır$$, FALSE, 0),
    ($$Üç component de birlikte, sayfada üst üste render edilir$$, FALSE, 1),
    ($$Hiçbir şey render edilmez, çünkü /hakkinda kök path değildir$$, FALSE, 2),
    ($$Hakkinda, çünkü path'i mevcut URL ile eşleşir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, sayfalar arasında geçiş için neden <a href="..."> yerine Link öneriyor?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, sayfalar arasında geçiş için neden <a href="..."> yerine Link öneriyor?$$,
           NULL, NULL,
           $$<a href="...">, tarayıcının tüm sayfayı yeniden yüklemesine neden olur; Link yalnızca URL'yi değiştirir ve React, yeniden yükleme olmadan eşleşen Route'u render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$<a href="...">, tarayıcının tüm sayfayı yeniden yüklemesine neden olur; Link, yeniden yüklemeden URL'yi değiştirir$$, TRUE, 0),
    ($$<a> tag'leri JSX içinde hiç geçerli değildir$$, FALSE, 1),
    ($$React'te <a> tag'leri href attribute'una sahip olamadığı için Link gereklidir$$, FALSE, 2),
    ($$Gerçek bir fark yoktur -- Link, <a>'ya yalnızca stilistik bir alternatiftir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, NavLink sana Link'in vermediği neyi verir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, NavLink sana Link'in vermediği neyi verir?$$,
           NULL, NULL,
           $$NavLink, className'e (ya da style'a) bir FONKSİYON geçirmene izin verir; bu fonksiyon, o link'in sayfasının mevcut sayfa olup olmadığını belirten bir { isActive } nesnesi alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$NavLink, uygulamadaki ilk Route için gereklidir, diğerleri için Link gereklidir$$, FALSE, 0),
    ($$className/style'a, link'in sayfasının şu anda aktif olup olmadığını alan bir fonksiyon geçirebilme yeteneği$$, TRUE, 1),
    ($$NavLink, Link'in aksine, URL'yi hiç değiştirmeden gezinebilir$$, FALSE, 2),
    ($$NavLink, tıklanmadan önce link'lenen sayfanın verisini otomatik olarak önceden getirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, paylaşılan bir navigasyon menüsüyle birden fazla sayfayı birleştirmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, paylaşılan bir navigasyon menüsüyle birden fazla sayfayı birleştirmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Gerçek bir uygulamada genellikle her birinin kendi path'i ve element'i olan birkaç Route, ve onlara işaret eden birkaç Link birlikte bulunur; bu, küçük bir çok sayfalı uygulamanın temel iskeletidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$Paylaşılan bir navigasyon menüsü genellikle her sayfaya işaret eden birkaç Link içerir$$, TRUE, 0),
    ($$Bir navigasyon menüsü her zaman tam olarak bir Link içerebilir, asla daha fazlasını içeremez$$, FALSE, 1),
    ($$Her ek sayfa, tamamen ayrı bir BrowserRouter tanımlamayı gerektirir$$, FALSE, 2),
    ($$Gerçek bir uygulamada genellikle her birinin kendi path'i ve element'i olan birkaç Route bulunur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-router-basics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir kullanıcı /olmayan-sayfa'yı ziyaret ediyor. Hangi Route render edilir?$$
      AND code_snippet = $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="*" element={<BulunamadiSayfasi />} />
</Routes>$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı /olmayan-sayfa'yı ziyaret ediyor. Hangi Route render edilir?$$,
           $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="*" element={<BulunamadiSayfasi />} />
</Routes>$$, $$jsx$$,
           $$path="*", başka hiçbir Route ile eşleşmeyen her URL'yi yakalar; React yukarıdan aşağıya bir eşleşme arar, ve /olmayan-sayfa ne / ne de /kurslar ile eşleştiği için, catch-all'a düşer ve BulunamadiSayfasi render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-router-basics'
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
    ($$AnaSayfa, çünkü ilk tanımlanan Route'tur$$, FALSE, 0),
    ($$Hiçbir tam eşleşme olmadığı için hiçbir şey render edilmez$$, FALSE, 1),
    ($$URL bir sunucuda mevcut olmadığı için tarayıcı bir ağ hatası fırlatır$$, FALSE, 2),
    ($$BulunamadiSayfasi, çünkü path="*" başka hiçbir Route ile eşleşmeyen her URL'yi yakalar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-router-basics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

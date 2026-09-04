-- Promotion-style migration linking TR lazy-loading-code-splitting quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$lazy(() => import("./KursDetaylari.jsx")), KursDetaylari'nın koduna ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$lazy(() => import("./KursDetaylari.jsx")), KursDetaylari'nın koduna ne yapar?$$,
           NULL, NULL,
           $$KursDetaylari'nın kodunu uygulamanın ilk bundle'ından çıkarır -- yalnızca gerçekten ihtiyaç duyulduğunda indirilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Bundling üzerinde hiçbir etkisi yoktur -- lazy() yalnızca bir isimlendirme kuralıdır$$, FALSE, 0),
    ($$KursDetaylari'nın kodunu ilk bundle'dan çıkarır, yalnızca ihtiyaç duyulduğunda indirir$$, TRUE, 1),
    ($$KursDetaylari'nın kodunu projeden tamamen siler$$, FALSE, 2),
    ($$KursDetaylari'nın kodunu yedeklilik için her diğer bundle'a kopyalar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$lazy() kullanırken Suspense ne için gereklidir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$lazy() kullanırken Suspense ne için gereklidir?$$,
           NULL, NULL,
           $$Suspense, lazy yüklenen component'in kodu indirilirken bir fallback göstermek için gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Bir named export'u bir default export'a dönüştürmek için$$, FALSE, 0),
    ($$Tamamen isteğe bağlıdır ve lazy() ile birlikte kullanıldığında gerçek bir amacı yoktur$$, FALSE, 1),
    ($$Lazy yüklenen component'in kodu indirilirken bir fallback göstermek için$$, TRUE, 2),
    ($$İndirme başarısız olursa, başka hiçbir yapılandırma olmadan otomatik olarak yeniden denemek için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir kullanıcı yalnızca ana sayfayı ziyaret ediyor ve hiç /hakkinda'ya gitmiyor. Bu kuruluma göre, HakkindaSayfasi'nın kodu hiç indirilir mi?$$
      AND code_snippet = $$const HakkindaSayfasi = lazy(() => import("./HakkindaSayfasi.jsx"));

<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/hakkinda" element={
        <Suspense fallback={<p>Yukleniyor...</p>}>
            <HakkindaSayfasi />
        </Suspense>
    } />
</Routes>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı yalnızca ana sayfayı ziyaret ediyor ve hiç /hakkinda'ya gitmiyor. Bu kuruluma göre, HakkindaSayfasi'nın kodu hiç indirilir mi?$$,
           $$const HakkindaSayfasi = lazy(() => import("./HakkindaSayfasi.jsx"));

<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/hakkinda" element={
        <Suspense fallback={<p>Yukleniyor...</p>}>
            <HakkindaSayfasi />
        </Suspense>
    } />
</Routes>$$, $$jsx$$,
           $$Bir kullanıcı hiç /hakkinda'yı ziyaret etmezse, o sayfanın kodu hiç indirilmez -- bu, route tabanlı code splitting'dir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Evet -- lazy(), her route'un kodunu uygulama başlangıcında hemen indirir$$, FALSE, 0),
    ($$Evet, ama yalnızca gezinmeden bağımsız olarak 5 saniyelik bir gecikmeden sonra$$, FALSE, 1),
    ($$AnaSayfa'nın da dahili olarak HakkindaSayfasi'nı import edip etmediğine bağlıdır$$, FALSE, 2),
    ($$Hayır -- kullanıcı hiç /hakkinda'yı ziyaret etmediği için, HakkindaSayfasi'nın kodu hiç indirilmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$KursGrafigi bir NAMED export'tur, default export değildir. Burada .then((module) => ({ default: module.KursGrafigi })) neden gereklidir?$$
      AND code_snippet = $$const KursGrafigi = lazy(() =>
    import("./KursGrafigi.jsx").then((module) => ({ default: module.KursGrafigi }))
);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$KursGrafigi bir NAMED export'tur, default export değildir. Burada .then((module) => ({ default: module.KursGrafigi })) neden gereklidir?$$,
           $$const KursGrafigi = lazy(() =>
    import("./KursGrafigi.jsx").then((module) => ({ default: module.KursGrafigi }))
);$$, $$jsx$$,
           $$lazy(), import()'ın bir default export'a çözülmesini bekler -- .then(...), named export olan KursGrafigi'ni lazy'nin beklediği { default: ... } şekline dönüştürür.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Çünkü lazy(), import()'ın bir default export'a çözülmesini bekler, ve bu named export'u o şekle dönüştürür$$, TRUE, 0),
    ($$Çünkü named export'lar import() sözdizimiyle hiç kullanılamaz$$, FALSE, 1),
    ($$Çünkü KursGrafigi'nin kodunun bir default export'tan daha hızlı yüklenmesini sağlar$$, FALSE, 2),
    ($$Gerçek bir işlevsel amacı olmayan gereksiz bir boilerplate'tir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, lazy() yalnızca sayfaları/route'ları bölmek için mi kullanışlıdır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lazy() yalnızca sayfaları/route'ları bölmek için mi kullanışlıdır?$$,
           NULL, NULL,
           $$lazy(), yalnızca sayfalar için değil, emoji seçici gibi NADIREN kullanılan HERHANGİ bir component için de kullanışlıdır -- kodu, showPicker ilk kez true olana kadar hiç indirilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Hayır -- ama nadiren kullanılan component'ler tamamen farklı bir API ile bölünmelidir$$, FALSE, 0),
    ($$Hayır -- bir emoji seçici gibi nadiren kullanılan herhangi bir component için de kullanışlıdır$$, TRUE, 1),
    ($$Evet -- lazy() yalnızca bir Route component'iyle birleştirildiğinde çalışır$$, FALSE, 2),
    ($$Evet, ve showPicker gibi bir state değişikliğiyle asla tetiklenemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, code splitting'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, code splitting'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Code splitting, bir uygulamayı tek bir dev bundle yerine birden fazla küçük parçaya bölme tekniğidir; bir bundle, bir uygulamanın birleştirilmiş JavaScript dosyalarıdır; bir chunk, code splitting'in ürettiği küçük, ayrı ayrı indirilebilir bir dosyadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Bir chunk, code splitting'in ürettiği küçük, ayrı ayrı indirilebilir bir JavaScript dosyasıdır$$, TRUE, 0),
    ($$Code splitting her zaman uygulamayı tamamen farklı bir dilde yeniden yazmayı gerektirir$$, FALSE, 1),
    ($$Bir bundle ve bir chunk, tam olarak aynı şeyin birbirinin yerine geçebilen iki adıdır$$, FALSE, 2),
    ($$Bir uygulamayı tek bir dev bundle yerine birden fazla küçük parçaya bölme tekniğidir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, lazy()'nin genel etkisini aşağıdakilerden hangileri doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lazy()'nin genel etkisini aşağıdakilerden hangileri doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$lazy(), bir component'in kodunu ayrı bir chunk'a böler, yalnızca gerçekten ihtiyaç duyulduğunda indirir -- bu, başlangıçta yüklenen JavaScript miktarını azaltır; lazy() her zaman Suspense ile birlikte kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Kodu yalnızca ihtiyaç duyulduğunda indirerek, başlangıçta yüklenen JavaScript miktarını azaltır$$, TRUE, 0),
    ($$İndirme sırasında bir fallback gerektiği için, lazy() her zaman Suspense ile birlikte kullanılır$$, TRUE, 1),
    ($$lazy(), tarayıcının indirdiği toplam JavaScript miktarını her durumda artırır$$, FALSE, 2),
    ($$lazy(), bir bundler'a ihtiyacı tamamen ortadan kaldırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

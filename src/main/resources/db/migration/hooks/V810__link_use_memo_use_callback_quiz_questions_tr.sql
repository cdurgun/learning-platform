-- Promotion-style migration linking TR use-memo-use-callback quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Memoization nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Memoization nedir?$$,
           NULL, NULL,
           $$Memoization, bir hesaplamanın sonucunu saklama tekniğidir, böylece aynı girdilerle tekrar istendiğinde, hesaplamayı tekrarlamadan o sonuç geri verilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$use ile başlayan fonksiyonlar için bir isimlendirme kuralı$$, FALSE, 0),
    ($$Bir hesaplamanın sonucunu, hesaplamayı tekrarlamadan tekrar döndürülebilecek şekilde saklama tekniği$$, TRUE, 1),
    ($$Kullanılmayan state değişkenlerini bellekten kalıcı olarak silmenin bir yolu$$, FALSE, 2),
    ($$JSX'i tarayıcıya gönderilmeden önce sıkıştırma tekniği$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useMemo neyi önbelleğe alır (cache eder)?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$useMemo neyi önbelleğe alır (cache eder)?$$,
           NULL, NULL,
           $$useMemo bir hesaplamanın SONUCUNU cache eder -- dependency array'in değerleri değişmediği sürece hesaplamayı tekrar çalıştırmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$Tüm sayfanın tarayıcı DOM ağacını$$, FALSE, 0),
    ($$Component'in tüm render'lar boyunca şimdiye kadar aldığı her prop'u$$, FALSE, 1),
    ($$Bir hesaplamanın sonucunu$$, TRUE, 2),
    ($$Tüm component'in render çıktısını HTML olarak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$ayarlar, useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []) ile oluşturuluyor. Ardışık iki render boyunca, ayarlar aynı nesne referansı mıdır?$$
      AND code_snippet = $$const ayarlar = useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []);
// component ilgisiz bir nedenle yeniden render ediliyor$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$ayarlar, useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []) ile oluşturuluyor. Ardışık iki render boyunca, ayarlar aynı nesne referansı mıdır?$$,
           $$const ayarlar = useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []);
// component ilgisiz bir nedenle yeniden render ediliyor$$, $$jsx$$,
           $$Dependency array'i boş olduğu için (asla değişmediği için), useMemo her render'da yeni bir nesne oluşturmak yerine AYNI nesne referansını döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$Hayır -- useMemo ile bile her render'da yepyeni bir nesne oluşturulur$$, FALSE, 0),
    ($$tema ya da yaziBoyutu değişip değişmediğine bağlıdır, dependency array'e değil$$, FALSE, 1),
    ($$Yalnızca ilk render bir nesne üretir; sonraki render'lar undefined döndürür$$, FALSE, 2),
    ($$Evet -- useMemo, dependency array değişmediği sürece aynı nesne referansını döndürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useCallback, neyi memoize ettiği bakımından useMemo'dan nasıl farklıdır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$useCallback, neyi memoize ettiği bakımından useMemo'dan nasıl farklıdır?$$,
           NULL, NULL,
           $$useCallback, useMemo'ya çok benzer, ama bir değer yerine bir FONKSİYONU memoize eder -- useMemo bir hesaplamanın sonucunu (bir değeri) memoize eder, useCallback bir fonksiyon referansını memoize eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$useCallback bir fonksiyonu memoize eder, useMemo ise bir değeri (bir hesaplamanın sonucunu) memoize eder$$, TRUE, 0),
    ($$useCallback ve useMemo tam olarak aynı şeyi memoize eder, yalnızca farklı adları vardır$$, FALSE, 1),
    ($$useCallback bir değeri memoize eder, useMemo bir fonksiyonu memoize eder$$, FALSE, 2),
    ($$useCallback yalnızca class component'ler için, useMemo yalnızca function component'ler içindir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İki render arasında sayi değişmiyor. handleClick, her iki render'da da aynı fonksiyon referansı mıdır?$$
      AND code_snippet = $$function Buton({ sayi }) {
    function handleClick() {
        console.log(sayi);
    }
    // Burada hic useCallback kullanilmiyor
    return <button onClick={handleClick}>Tikla</button>;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$İki render arasında sayi değişmiyor. handleClick, her iki render'da da aynı fonksiyon referansı mıdır?$$,
           $$function Buton({ sayi }) {
    function handleClick() {
        console.log(sayi);
    }
    // Burada hic useCallback kullanilmiyor
    return <button onClick={handleClick}>Tikla</button>;
}$$, $$jsx$$,
           $$useCallback olmadan, handleClick her render'da YENİ bir fonksiyon olurdu -- sayi değişmese bile, düz bir fonksiyon tanımı her render'da yepyeni bir fonksiyon nesnesi oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$Render'lar arasında düğmeye gerçekten tıklanıp tıklanmadığına bağlıdır$$, FALSE, 0),
    ($$Hayır -- useCallback olmadan, sayi değişse de değişmese de her render'da yeni bir fonksiyon oluşturulur$$, TRUE, 1),
    ($$Evet -- sayi değişmediği için React otomatik olarak aynı fonksiyonu yeniden kullanır$$, FALSE, 2),
    ($$Yalnızca ilk iki render'da aynı referanstır, sonrasında asla değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, useMemo/useCallback'in NE ZAMAN kullanılmaması gerektiğini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useMemo/useCallback'in NE ZAMAN kullanılmaması gerektiğini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Basit, hızlı işlemler için, onları useMemo'ya sarmalamanın gerçek bir faydası yoktur; bu hook'ları gereksiz yere kullanmak, daha karmaşık ama gerçekte daha hızlı olmayan koda yol açar -- "erken optimizasyon".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$Bu hook'ları gereksiz yere kullanmak, daha karmaşık ama gerçekte daha hızlı olmayan koda yol açabilir$$, TRUE, 0),
    ($$useMemo ve useCallback varsayılan olarak her tek hesaplamaya ve fonksiyona uygulanmalıdır$$, FALSE, 1),
    ($$Bir component herhangi bir hook kullandığı andan itibaren useMemo ya da useCallback'i atlamanın hiçbir geçerli nedeni yoktur$$, FALSE, 2),
    ($$sayi * 2 gibi basit, zaten hızlı bir işlemi useMemo'ya sarmalamanın gerçek bir faydası yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-memo-use-callback')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, useMemo/useCallback'in kendi maliyetiyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useMemo/useCallback'in kendi maliyetiyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useMemo ve useCallback'in kendi maliyeti vardır -- dependency array'i karşılaştırmak ve sonucu elde tutmak; basit, hızlı işlemler için, bu maliyet kazandırdığından daha pahalı olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-memo-use-callback'
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
    ($$Kendi maliyetleri vardır: dependency array'i karşılaştırmak ve önceki sonucu elde tutmak$$, TRUE, 0),
    ($$Basit, hızlı işlemler için, bu maliyet gerçekte kazandırdığından daha pahalı olabilir$$, TRUE, 1),
    ($$Neyi sarmaladıklarından bağımsız olarak maliyetleri her zaman tam olarak sıfırdır$$, FALSE, 2),
    ($$Maliyetleri yalnızca bir component'in ilk render'ında geçerlidir, sonrasında asla değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-memo-use-callback'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

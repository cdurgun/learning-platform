-- Promotion-style migration linking TR portals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$createPortal(child, container) ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$createPortal(child, container) ne yapar?$$,
           NULL, NULL,
           $$child'ı, normal ağaç konumu yerine container DOM node'una render eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$child'ı bir kez render ettikten sonra DOM'dan tamamen siler$$, FALSE, 0),
    ($$child'ı, normal ağaç konumu yerine container DOM node'una render eder$$, TRUE, 1),
    ($$Yepyeni, tamamen ayrı bir React uygulaması oluşturur$$, FALSE, 2),
    ($$Bir function component'i bir class component'e dönüştürür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$createPortal kullandıktan sonra, component React DevTools'ta nerede görünür, gerçek DOM konumuna kıyasla?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$createPortal kullandıktan sonra, component React DevTools'ta nerede görünür, gerçek DOM konumuna kıyasla?$$,
           NULL, NULL,
           $$Component ağacında beklenen yerinde görünmeye devam eder (React DevTools'ta), ama gerçek DOM konumu tamamen farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$Hem DevTools konumu hem DOM konumu birlikte, aynı şekilde değişir$$, FALSE, 0),
    ($$React DevTools onu iki kez gösterir -- her konumda bir kez$$, FALSE, 1),
    ($$Component ağacında beklenen yerinde görünmeye devam eder; yalnızca gerçek DOM konumu farklıdır$$, TRUE, 2),
    ($$Bir portal kullanıldığında React DevTools'tan tamamen kaybolur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir modal'ın CSS'i (position: fixed, yüksek z-index), neden bazen onu sayfanın geri kalanının ÜSTÜNDE göstermeyi başaramaz?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir modal'ın CSS'i (position: fixed, yüksek z-index), neden bazen onu sayfanın geri kalanının ÜSTÜNDE göstermeyi başaramaz?$$,
           NULL, NULL,
           $$Modal'ın gerçek DOM konumu (örneğin overflow: hidden olan bir kartın içinde olması) bunu bazen engelleyebilir; bir Portal, modal'ı doğrudan document.body'ye render ederek bu sorunu ORTADAN KALDIRIR.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$CSS z-index'in bir React uygulamasındaki hiçbir element üzerinde gerçek bir etkisi yoktur$$, FALSE, 0),
    ($$Modal'lar yapısal olarak position: fixed kullanmaktan tamamen men edilmiştir$$, FALSE, 1),
    ($$Hiçbir zaman başarısız olmaz -- bu, Portal'ların çözmek için tasarlandığı gerçek bir sorun değildir$$, FALSE, 2),
    ($$overflow: hidden olan bir atanın içine yerleştirilmiş olmak gibi gerçek DOM konumu bunu engelleyebilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$AcilirPencere, bir Portal aracılığıyla document.body'ye, DOM'da fiziksel olarak dış div'in dışına render ediliyor. AcilirPencere içindeki düğmeye tıklandığında, dış div'deki onClick tetiklenir mi?$$
      AND code_snippet = $$function AcilirPencere() {
    return createPortal(<button>Tikla</button>, document.body);
}

<div onClick={() => console.log("Dis div tiklandi")}>
    <AcilirPencere />
</div>$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$AcilirPencere, bir Portal aracılığıyla document.body'ye, DOM'da fiziksel olarak dış div'in dışına render ediliyor. AcilirPencere içindeki düğmeye tıklandığında, dış div'deki onClick tetiklenir mi?$$,
           $$function AcilirPencere() {
    return createPortal(<button>Tikla</button>, document.body);
}

<div onClick={() => console.log("Dis div tiklandi")}>
    <AcilirPencere />
</div>$$, $$jsx$$,
           $$React, olayları gerçek DOM ağacına göre değil KENDİ component ağacına göre yayar -- AcilirPencere DOM'da onun dışına render edilse bile, düğmeye tıklamak yine de onClick'in dış div'e kadar yükselmesine (bubble) neden olur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$Evet -- React, olayları kendi component ağacına göre yayar, bu yüzden tıklama yine de dış div'e kadar yükselir$$, TRUE, 0),
    ($$Hayır -- AcilirPencere DOM'da fiziksel olarak div'in dışında olduğu için, tıklama ona hiç ulaşmaz$$, FALSE, 1),
    ($$Bir çalışma zamanı hatası fırlatır, çünkü Portal'lara hiç tıklanamaz$$, FALSE, 2),
    ($$Yalnızca document.body'ye de elle bir onClick handler'ı verilirse$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$index.html'de #root'a sibling olarak <div id="tooltip-root"></div> eklemenin amacı nedir?$$
      AND code_snippet = $$<body>
    <div id="root"></div>
    <div id="tooltip-root"></div>
</body>$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$index.html'de #root'a sibling olarak <div id="tooltip-root"></div> eklemenin amacı nedir?$$,
           $$<body>
    <div id="root"></div>
    <div id="tooltip-root"></div>
</body>$$, $$jsx$$,
           $$document.body yerine genellikle özel (dedicated) bir hedef kullanılır; bu, portal içeriğinin kendi stillerini ve konumlandırmasını yönetmesini kolaylaştırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$#root içinde render edilen her şey için React DevTools'u devre dışı bırakır$$, FALSE, 0),
    ($$Özel bir portal hedefi sağlar, portal içeriğinin kendi stillerini/konumlandırmasını yönetmesini kolaylaştırır$$, TRUE, 1),
    ($$Zorunlu bir sözdizimidir -- createPortal ikinci bir root div olmadan çalışamaz$$, FALSE, 2),
    ($$Tüm React uygulamasını otomatik olarak ikinci bir instance'a kopyalar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, aşağıdakilerden hangileri Portal'ların yaygın kullanımları olarak belirtilir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri Portal'ların yaygın kullanımları olarak belirtilir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$En yaygın kullanımlar, ata elementlerdeki overflow: hidden gibi CSS özelliklerinden kaçınmak için modal'lar, tooltip'ler ve dropdown'lardır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$Tooltip'ler ve dropdown'lar$$, TRUE, 0),
    ($$Bir uygulamadaki tüm useState çağrılarını değiştirmek$$, FALSE, 1),
    ($$Bir REST API'den veri getirmek$$, FALSE, 2),
    ($$Modal'lar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'portals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, aşağıdakilerden hangileri bir Portal'ın temel özelliklerini doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri bir Portal'ın temel özelliklerini doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$createPortal, component'in React ağacındaki konumunu korurken onu farklı bir DOM node'una render eder; olaylar gerçek DOM konumuna göre değil React'in component ağacına göre yükselir (bubble) -- bu, Portal'ların sıradan component'ler gibi çalışmaya devam etmesini sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'portals'
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
    ($$createPortal, component'in React ağacındaki konumunu korurken onu farklı bir DOM node'una render eder$$, TRUE, 0),
    ($$Olaylar, gerçek DOM konumuna göre değil, React'in component ağacına göre yükselir (bubble)$$, TRUE, 1),
    ($$Bir Portal, herhangi bir atadaki tüm olayların yükselmesini tamamen durdurur$$, FALSE, 2),
    ($$Olayların çalışması için bir Portal'ın her tek render'da elle yeniden oluşturulması gerekir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'portals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

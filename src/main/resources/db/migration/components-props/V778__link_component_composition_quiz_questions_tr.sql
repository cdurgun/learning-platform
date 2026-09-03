-- Promotion-style migration linking TR component-composition quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$children prop'u nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$children prop'u nedir?$$,
           NULL, NULL,
           $$children, her component'in otomatik olarak aldığı, o component'in açılış ve kapanış tag'leri arasına yazılan her şeyi taşıyan özel bir prop'tur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$Her zaman diğer herhangi bir attribute gibi elle geçirmen gereken zorunlu bir prop$$, FALSE, 0),
    ($$Her component'in otomatik olarak aldığı, açılış ve kapanış tag'leri arasına yazılanı taşıyan özel bir prop$$, TRUE, 1),
    ($$Bir component'in şimdiye kadar aldığı her prop'un bir dizisi$$, FALSE, 2),
    ($$İç içe elementlere otomatik olarak uygulanan bir CSS class'ı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kodda Kutu'nun children'ı neye eşittir?$$
      AND code_snippet = $$function Kutu({ children }) {
    return <div className="kutu">{children}</div>;
}

<Kutu>
    <p>Merhaba</p>
</Kutu>$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kodda Kutu'nun children'ı neye eşittir?$$,
           $$function Kutu({ children }) {
    return <div className="kutu">{children}</div>;
}

<Kutu>
    <p>Merhaba</p>
</Kutu>$$, $$jsx$$,
           $$Kutu'nun açılış ve kapanış tag'leri arasına yazılan her şey onun children'ı olur -- burada bu, <p>Merhaba</p> elementidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$children hiç bir attribute olarak geçirilmediği için undefined$$, FALSE, 0),
    ($$Kutu'nun hiç attribute'u olmadığı için boş bir dizi$$, FALSE, 1),
    ($$Kutu'nun açılış ve kapanış tag'leri arasına yazılan <p>Merhaba</p> elementi$$, TRUE, 2),
    ($$"Kutu" string'i$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri children'ın ad ya da yas gibi sıradan bir prop'tan farkını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri children'ın ad ya da yas gibi sıradan bir prop'tan farkını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$children, bir attribute olarak değil, component'in açılış ve kapanış tag'lerinin İÇİNE yazılır; ad gibi sıradan bir prop ise açılış tag'inin kendisinde bir attribute olarak yazılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$children, bir attribute olarak değil, component'in açılış ve kapanış tag'lerinin içine yazılır$$, TRUE, 0),
    ($$ad gibi sıradan bir prop, ad="Ayşe" gibi bir attribute olarak yazılır$$, TRUE, 1),
    ($$children, asla destructuring kullanamayan tamamen farklı bir component fonksiyon imzası gerektirir$$, FALSE, 2),
    ($$Sıradan prop'lar aynı component'te children ile asla birleştirilemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Component'ler nested (iç içe) olabilir" ne anlama gelir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"Component'ler nested (iç içe) olabilir" ne anlama gelir?$$,
           NULL, NULL,
           $$Bir component, kendileri de başka component'ler içerebilen başka component'ler içerebilir -- büyük bir UI, küçük, odaklanmış component'lerden bu şekilde inşa edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$Bir component başka component'ler içerebilir, büyük bir UI'ı küçük parçalardan inşa eder$$, TRUE, 0),
    ($$Her component dosyası, parent'ının adını taşıyan bir klasörün içine kaydedilmelidir$$, FALSE, 1),
    ($$Component fonksiyonları otomatik olarak sınırsız sayıda özyinelemeli (recursive) çağrılabilir$$, FALSE, 2),
    ($$Nested component'ler parent'larıyla tam olarak aynı adı taşır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu yapıya göre, App nihayetinde hangi component'leri, doğrudan ya da dolaylı olarak, render eder?$$
      AND code_snippet = $$function Avatar() { return <img alt="avatar" />; }
function KullaniciAdi() { return <span>Ayse</span>; }
function KullaniciProfili() {
    return (
        <div>
            <Avatar />
            <KullaniciAdi />
        </div>
    );
}
function App() {
    return <KullaniciProfili />;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu yapıya göre, App nihayetinde hangi component'leri, doğrudan ya da dolaylı olarak, render eder?$$,
           $$function Avatar() { return <img alt="avatar" />; }
function KullaniciAdi() { return <span>Ayse</span>; }
function KullaniciProfili() {
    return (
        <div>
            <Avatar />
            <KullaniciAdi />
        </div>
    );
}
function App() {
    return <KullaniciProfili />;
}$$, $$jsx$$,
           $$App doğrudan KullaniciProfili'ni render eder, ve KullaniciProfili de Avatar ile KullaniciAdi'nı render eder -- bu yüzden üçü de App'in ağacının parçası olarak render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$Hiçbiri, çünkü App yalnızca tek bir tag döndürür$$, FALSE, 0),
    ($$KullaniciProfili, Avatar ve KullaniciAdi'nın üçü de App'in ağacının parçası olarak render edilir$$, TRUE, 1),
    ($$Yalnızca KullaniciProfili -- Avatar ve KullaniciAdi, App ile ilgisizdir$$, FALSE, 2),
    ($$Yalnızca Avatar ve KullaniciAdi -- KullaniciProfili kendi içeriği olmadığı için atlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React, component'leri birleştirmek için class inheritance (bir component'in başka birini extend etmesi) kullanır mı?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$React, component'leri birleştirmek için class inheritance (bir component'in başka birini extend etmesi) kullanır mı?$$,
           NULL, NULL,
           $$Hayır -- React component'lerinde böyle bir inheritance yoktur; component'ler inheritance ile değil, composition ile (children aracılığıyla birbirinin içine yerleştirilerek) birleştirilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$Yalnızca class component'ler inheritance kullanır; function component'ler hiç birleştirilemez$$, FALSE, 0),
    ($$Aynı dosyayı paylaşıp paylaşmadıklarına bağlıdır$$, FALSE, 1),
    ($$Hayır -- React component'leri inheritance ile değil, composition ile birleştirilir$$, TRUE, 2),
    ($$Evet -- her component paylaşılan bir temel component sınıfını extend etmelidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'component-composition')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin composition ile inheritance karşılaştırmasına göre, aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin composition ile inheritance karşılaştırmasına göre, aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$React ekibi, composition'ın neredeyse her senaryo için yeterli olduğunu belirtmiştir, bu yüzden React'te bir component'i extends ile extend etmek gibi bir kalıp görmezsin.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'component-composition'
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
    ($$React ekibi, composition'ın neredeyse her senaryo için yeterli olduğunu belirtmiştir$$, TRUE, 0),
    ($$Component'ler arasında bir component'i extends ile extend etmek gibi bir kalıp görmezsin$$, TRUE, 1),
    ($$Component'ler arasında inheritance, React'in resmi olarak önerdiği varsayılan kalıptır$$, FALSE, 2),
    ($$Composition ve inheritance birebir aynı component ağaçlarını üretir ve birbirinin yerine kullanılabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'component-composition'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

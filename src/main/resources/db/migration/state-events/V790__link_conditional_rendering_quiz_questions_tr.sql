-- Promotion-style migration linking TR conditional-rendering quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir if ifadesi JSX'in süslü parantezlerinin { } içine doğrudan yazılabilir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir if ifadesi JSX'in süslü parantezlerinin { } içine doğrudan yazılabilir mi?$$,
           NULL, NULL,
           $$Hayır -- if, JSX'in { }'inin içine doğrudan yazılamaz, ama return'DEN ÖNCE, sıradan bir JavaScript değişkeninin değerine karar vermek için kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$Yalnızca component bir class component ise, function component ise değil$$, FALSE, 0),
    ($$Hayır -- if, { }'in içine giremez, ama bir değişkenin değerine karar vermek için return'den önce kullanılabilir$$, TRUE, 1),
    ($$Evet -- if, { } içindeki başka herhangi bir ifade gibi tam olarak çalışır$$, FALSE, 2),
    ($$Yalnızca bir ternary ifadesinin içinde, tek başına asla$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ternary (? :), if'in aksine, JSX'in { }'inin içine neden doğrudan yazılabilir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir ternary (? :), if'in aksine, JSX'in { }'inin içine neden doğrudan yazılabilir?$$,
           NULL, NULL,
           $$Bir ternary bir değer üretir, bu da tam olarak { }'in ihtiyaç duyduğu şeydir -- bir ifade (statement) olan, değer üretmeyen if'in aksine.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$Çünkü if modern JavaScript'te kullanımdan kaldırılmıştır, ama ternary'ler kaldırılmamıştır$$, FALSE, 0),
    ($$Gerçek bir fark yoktur -- ikisi de { } içinde birebir aynı şekilde çalışır$$, FALSE, 1),
    ($$Çünkü bir ternary bir değer üretir, bu da tam olarak { }'in ihtiyaç duyduğu şeydir$$, TRUE, 2),
    ($$Çünkü ternary'ler JavaScript ile ilgisi olmayan, yalnızca JSX'e özgü özel bir özelliktir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ternary'nin aksine, && operatörü conditional rendering'de ne için kullanılır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir ternary'nin aksine, && operatörü conditional rendering'de ne için kullanılır?$$,
           NULL, NULL,
           $$Bir ternary iki seçenek arasında seçim yapmak içindir (bu YA DA şu); && ise "bir şey göster" ile "hiçbir şey gösterme" arasında seçim yapmak içindir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$Tamamen farklı iki component arasında seçim yapmak, asla tek bir element için değil$$, FALSE, 0),
    ($$Aynı anda iki bağımsız event handler'ı çalıştırmak$$, FALSE, 1),
    ($$İki ayrı state değişkenini tek birinde birleştirmek$$, FALSE, 2),
    ($$"Bir şey göster" ile "hiçbir şey gösterme" arasında seçim yapmak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$yeniMesajVar, 0 sayısıdır. Bu ne render eder?$$
      AND code_snippet = $$function Bildirim({ yeniMesajVar }) {
    return <div>{yeniMesajVar && <p>Yeni bir mesajin var!</p>}</div>;
}

<Bildirim yeniMesajVar={0} />$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$yeniMesajVar, 0 sayısıdır. Bu ne render eder?$$,
           $$function Bildirim({ yeniMesajVar }) {
    return <div>{yeniMesajVar && <p>Yeni bir mesajin var!</p>}</div>;
}

<Bildirim yeniMesajVar={0} />$$, $$jsx$$,
           $$0 falsy olsa da JSX içinde hâlâ render edilebilir bir değer olduğu için, yeniMesajVar && <p>...</p> ekranda hiçbir şey değil, gerçekten literal "0" metnini render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$Ekranda literal "0" metni render edilir$$, TRUE, 0),
    ($$0 falsy olduğu için hiçbir şey render edilmez$$, FALSE, 1),
    ($$<p>Yeni bir mesajin var!</p> metni yine de render edilir$$, FALSE, 2),
    ($$yeniMesajVar boolean olması gerektiği için React bir hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$yukleniyor false. Bu component ne render eder?$$
      AND code_snippet = $$function YuklemeMesaji() { return <p>Yukleniyor...</p>; }
function HosgeldinMesaji() { return <p>Hosgeldin!</p>; }

function Durum({ yukleniyor }) {
    return yukleniyor ? <YuklemeMesaji /> : <HosgeldinMesaji />;
}

<Durum yukleniyor={false} />$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$yukleniyor false. Bu component ne render eder?$$,
           $$function YuklemeMesaji() { return <p>Yukleniyor...</p>; }
function HosgeldinMesaji() { return <p>Hosgeldin!</p>; }

function Durum({ yukleniyor }) {
    return yukleniyor ? <YuklemeMesaji /> : <HosgeldinMesaji />;
}

<Durum yukleniyor={false} />$$, $$jsx$$,
           $$yukleniyor false olduğu için, ternary ikinci dalı seçer, HosgeldinMesaji -- yalnızca farklı bir metin değil, tamamen farklı bir component.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$yukleniyor falsy olduğu için hiçbiri render edilmez$$, FALSE, 0),
    ($$HosgeldinMesaji'nın "Hosgeldin!" metni$$, TRUE, 1),
    ($$YuklemeMesaji'nın "Yukleniyor..." metni$$, FALSE, 2),
    ($$YuklemeMesaji ve HosgeldinMesaji birlikte render edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, aşağıdaki değerlerden hangileri falsy'dir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdaki değerlerden hangileri falsy'dir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$false, 0, "", null ve undefined falsy'dir -- geri kalan her şey truthy'dir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$"" (boş bir string)$$, TRUE, 0),
    ($$"0" (sıfır karakteri içeren string)$$, FALSE, 1),
    ($$null$$, TRUE, 2),
    ($$0$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'conditional-rendering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, aşağıdakilerden hangileri bir conditional rendering tekniğini kullanım amacıyla doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri bir conditional rendering tekniğini kullanım amacıyla doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$if, JSX dışında, return'den önce, bir değişkenin değerine karar vermek için kullanılır; bir ternary, JSX içinde iki seçenek arasında seçim yapmak için kullanılır; && "göster ya da hiçbir şey gösterme" içindir; koşula bağlı olarak tamamen farklı component'ler de döndürebilirsin.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'conditional-rendering'
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
    ($$if, JSX dışında, return'den önce, bir değişkenin değerine karar vermek için kullanılır$$, TRUE, 0),
    ($$Bir ternary, JSX içinde iki seçenek arasında seçim yapmak için kullanılır$$, TRUE, 1),
    ($$&&, tıpkı bir ternary gibi, özellikle iki farklı component arasında seçim yapmak için kullanılır$$, FALSE, 2),
    ($$Yalnızca farklı metin değil, koşula bağlı olarak tamamen farklı component'ler de döndürebilirsin$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'conditional-rendering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

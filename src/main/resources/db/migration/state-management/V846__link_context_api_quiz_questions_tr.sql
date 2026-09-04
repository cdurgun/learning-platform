-- Promotion-style migration linking TR context-api quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$createContext("acik")'a geçirilen değer neyi temsil eder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$createContext("acik")'a geçirilen değer neyi temsil eder?$$,
           NULL, NULL,
           $$Parantez içindeki değer, hiç Provider olmadığında kullanılan VARSAYILAN değerdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Bu Context'i kullanan her component'in sağlaması gereken zorunlu bir prop$$, FALSE, 0),
    ($$Hiç Provider olmadığında kullanılan varsayılan değer$$, TRUE, 1),
    ($$Her component'e otomatik olarak uygulanan bir CSS tema adı$$, FALSE, 2),
    ($$Yalnızca hata ayıklama amaçlı kullanılan, Context'in adı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$<ThemeContext.Provider value="koyu"> ne yapar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$<ThemeContext.Provider value="koyu"> ne yapar?$$,
           NULL, NULL,
           $$Provider'ın içindeki tüm ağaç için context'in değerini "koyu"ya GEÇERSİZ KILAR (override eder).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Yalnızca Provider'ın doğrudan parent component'ini etkiler, çocuklarını değil$$, FALSE, 0),
    ($$Her child component'in özel bir prop ile açıkça katılım göstermesini gerektirir$$, FALSE, 1),
    ($$Provider'ın içindeki tüm ağaç için context'in değerini "koyu"ya geçersiz kılar$$, TRUE, 2),
    ($$Context'in varsayılan değerini tüm uygulama için kalıcı olarak siler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$TemaliButon, useContext(TemaContext)'i çağırıyor. Hangi değeri okur?$$
      AND code_snippet = $$const TemaContext = createContext("acik");

function App() {
    return (
        <TemaContext.Provider value="koyu">
            <TemaliButon />
        </TemaContext.Provider>
    );
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$TemaliButon, useContext(TemaContext)'i çağırıyor. Hangi değeri okur?$$,
           $$const TemaContext = createContext("acik");

function App() {
    return (
        <TemaContext.Provider value="koyu">
            <TemaliButon />
        </TemaContext.Provider>
    );
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$, $$jsx$$,
           $$useContext(TemaContext), en yakın Provider'dan değeri okur -- TemaliButon, value="koyu" olan bir Provider'ın içinde olduğu için, createContext varsayılanını değil "koyu"yu okur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$createContext'ten gelen varsayılan değer olan "acik"$$, FALSE, 0),
    ($$TemaliButon Provider'ın kendisi değil bir çocuğu olduğu için undefined$$, FALSE, 1),
    ($$Hem "acik" hem "koyu" birlikte bir dizi olarak döndürülür$$, FALSE, 2),
    ($$En yakın Provider'dan gelen değer olan "koyu"$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ağaçta hiçbir yerde hiç Provider yok. TemaliButon içinde useContext(TemaContext) hangi değeri döndürür?$$
      AND code_snippet = $$const TemaContext = createContext("acik");

function App() {
    return <TemaliButon />; // hicbir yerde Provider yok
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ağaçta hiçbir yerde hiç Provider yok. TemaliButon içinde useContext(TemaContext) hangi değeri döndürür?$$,
           $$const TemaContext = createContext("acik");

function App() {
    return <TemaliButon />; // hicbir yerde Provider yok
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$, $$jsx$$,
           $$Bir Provider her zaman gerekli değildir -- olmadan, useContext, createContext'e verilen varsayılan değeri döndürür, bu da burada "acik"tır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$"acik" -- Provider olmadığında createContext'e verilen varsayılan değer kullanılır$$, TRUE, 0),
    ($$Okuyacağı bir Provider olmadığı için undefined$$, FALSE, 1),
    ($$Bir Provider her zaman zorunlu olduğu için hemen bir çalışma zamanı hatası fırlatır$$, FALSE, 2),
    ($$Context'in çalışması için her zaman açık bir Provider gerektirdiği için null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$value={{ items, addItem }}, Provider'a ne verir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$value={{ items, addItem }}, Provider'a ne verir?$$,
           NULL, NULL,
           $$value={{ items, addItem }}, Provider'a bir NESNE verir -- hem mevcut items listesini hem de onu güncelleyen addItem fonksiyonunu. Bu, Context'in gerçek uygulamalarda kullanılmasının en yaygın yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Aynı anda oluşturulan iki ayrı, ilgisiz Context$$, FALSE, 0),
    ($$Hem mevcut items listesini hem de onu güncelleyen addItem fonksiyonunu taşıyan bir nesne$$, TRUE, 1),
    ($$Yalnızca items listesini -- fonksiyonlar Context aracılığıyla asla geçirilemez$$, FALSE, 2),
    ($$items ve addItem'ı tek bir metin parçasında birleştiren bir string$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Context'i useTheme() gibi bir custom hook içine sarmalamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Context'i useTheme() gibi bir custom hook içine sarmalamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useTheme(), tüketen component'e daha temiz bir API sunmak için useContext(ThemeContext)'i sarmalar; bir Provider dışında kullanıldığında hata fırlatmak, yanlış kullanımı erken yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Hook bir Provider dışında kullanıldığında hata fırlatmak, yanlış kullanımı erken yakalar$$, TRUE, 0),
    ($$Context'i sarmalayan bir custom hook'un kendisi asla useContext çağıramaz$$, FALSE, 1),
    ($$Context'i bir custom hook'a sarmalamak zorunlu bir sözdizimidir ve onsuz çalışmaz$$, FALSE, 2),
    ($$useTheme(), tüketen component'e daha temiz bir API sunmak için useContext(ThemeContext)'i sarmalar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Context'in Sharing State'teki props drilling sorununu nasıl çözdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Context'in Sharing State'teki props drilling sorununu nasıl çözdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Level1, Level2, Level3'ün hiçbiri artık user prop'undan haberdar değildir -- yalnızca en altta olan Level4 onu doğrudan UserContext'ten okur; ara katmanlar aracılığıyla hiçbir şeyin geçirilmesine gerek yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Ara seviyelerin artık değerden hiç haberdar olmasına gerek yoktur$$, TRUE, 0),
    ($$Yalnızca değere gerçekten ihtiyaç duyan component onu doğrudan Context'ten okur$$, TRUE, 1),
    ($$Context, hâlâ her ara component'in değeri açıkça bir prop olarak iletmesini gerektirir$$, FALSE, 2),
    ($$Context, ağaçtaki herhangi bir yerde bir Provider ihtiyacını ortadan kaldırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

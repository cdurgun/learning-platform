-- Promotion-style migration linking TR controlled-components quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir controlled component (kontrollü component) nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir controlled component (kontrollü component) nedir?$$,
           NULL, NULL,
           $$Kontrollü bir component'te, input'un değeri, DOM'un kendi içinde bir değer tutması yerine React'in state'i tarafından BELİRLENİR.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Hiçbir kod olmadan kendi input'larını otomatik olarak doğrulayan bir component$$, FALSE, 0),
    ($$Değeri, DOM'un kendisi tarafından tutulmak yerine, React'in state'i tarafından belirlenen bir form elementi$$, TRUE, 1),
    ($$Mount edildikten sonra asla yeniden render edilemeyen bir component$$, FALSE, 2),
    ($$Yalnızca props kabul eden, hiç state kullanmayan bir component$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir <input>'a value={metin} yazmak neyi garanti eder?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir <input>'a value={metin} yazmak neyi garanti eder?$$,
           NULL, NULL,
           $$value={metin} yazıldığı için, input'ta gösterilen değer HER ZAMAN metin'in o anda state'te tuttuğu değerdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Input salt okunur hale gelir ve bir daha asla kontrollü olamaz$$, FALSE, 0),
    ($$metin her render'da otomatik olarak boş bir string'e sıfırlanır$$, FALSE, 1),
    ($$Input'ta gösterilen değer her zaman metin'in o anda state'te tuttuğu değerdir$$, TRUE, 2),
    ($$Input otomatik olarak değerini localStorage'a kaydeder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu input'ta value var ama onChange yok. Kullanıcı bu input'a yazmaya çalıştığında ne olur?$$
      AND code_snippet = $$function AdInput() {
    const [metin, metinAyarla] = useState("");
    return <input value={metin} />; // onChange yok
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu input'ta value var ama onChange yok. Kullanıcı bu input'a yazmaya çalıştığında ne olur?$$,
           $$function AdInput() {
    const [metin, metinAyarla] = useState("");
    return <input value={metin} />; // onChange yok
}$$, $$jsx$$,
           $$Tek başına value, input'u salt okunur yapar -- kullanıcı hiçbir şey yazamaz, çünkü tuş vuruşunu yansıtmak için hiçbir şey state'i güncellemiyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Kullanıcı normal şekilde yazabilir, ve metin onChange olmadan otomatik olarak güncellenir$$, FALSE, 0),
    ($$Bu component render edildiğinde React hemen bir çalışma zamanı hatası fırlatır$$, FALSE, 1),
    ($$Input çalışır, ama yalnızca sayıları kabul eder, harfleri değil$$, FALSE, 2),
    ($$Input etkin bir şekilde salt okunur hale gelir -- kullanıcı hiçbir şey yazamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kontrollü bir checkbox, value yerine hangi attribute'u kullanır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kontrollü bir checkbox, value yerine hangi attribute'u kullanır?$$,
           NULL, NULL,
           $$Checkbox'lar value yerine checked kullanır, ama mantık aynıdır -- React'in state'i işaretli olup olmadığına karar verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$checked$$, TRUE, 0),
    ($$selected$$, FALSE, 1),
    ($$toggled$$, FALSE, 2),
    ($$active$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, kontrollü bir <select>'in nasıl çalıştığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, kontrollü bir <select>'in nasıl çalıştığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir <select>, tıpkı bir metin input'u gibi, value ve onChange ile kontrol edilir -- aynı kalıp farklı form elementleri arasında da geçerlidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Bir <select> yalnızca checked ile kontrol edilebilir, value ile asla kontrol edilemez$$, FALSE, 0),
    ($$Kontrollü select'ler, metin input'larının kullanmadığı tamamen ayrı bir hook gerektirir$$, FALSE, 1),
    ($$Bir <select>, tıpkı bir metin input'u gibi, value ve onChange ile kontrol edilir$$, TRUE, 2),
    ($$Aynı kontrollü kalıp (state değere karar verir) farklı form elementi türlerinde de geçerlidir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$metin, useState aracılığıyla state'te tutuluyor. metin'e bağlı kontrollü bir input üzerinde metinAyarla("") çağırmak ne yapar?$$
      AND code_snippet = $$const [metin, metinAyarla] = useState("Merhaba");
// ... daha sonra, bir click handler icinde:
metinAyarla("");$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$metin, useState aracılığıyla state'te tutuluyor. metin'e bağlı kontrollü bir input üzerinde metinAyarla("") çağırmak ne yapar?$$,
           $$const [metin, metinAyarla] = useState("Merhaba");
// ... daha sonra, bir click handler icinde:
metinAyarla("");$$, $$jsx$$,
           $$Değer state'te yaşadığı için, input'u temizlemek metinAyarla("") kadar basittir -- value={metin} ile metin'e bağlı input hemen boş olarak yeniden render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Input'u gerçekten temizlemek için ayrıca ayrı bir DOM reset() metodunu da çağırmak gerekir$$, FALSE, 0),
    ($$State boş bir string'e ayarlanamayacağı için bir hata fırlatır$$, FALSE, 1),
    ($$Kontrollü input, her zaman o anki state değerine bağlı olduğu için hemen boş olarak görünür$$, TRUE, 2),
    ($$Görünür hiçbir şey olmaz, çünkü metinAyarla yalnızca dahili değişkeni etkiler, render edilen input'u etkilemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlled-components')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, kontrollü component döngüsünü (yaz → state'i güncelle → yeniden render et → input'ta göster) aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, kontrollü component döngüsünü (yaz → state'i güncelle → yeniden render et → input'ta göster) aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her tuş vuruşu onChange'i çalıştırır, metinAyarla state'i günceller, React yeniden render eder, ve input'un value'su o yeni state'i yansıtır; değer state'te yaşadığı için, aynı anda ekranda başka bir yerde de anında kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlled-components'
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
    ($$Her tuş vuruşu, setter fonksiyonu aracılığıyla state'i güncelleyen onChange'i çalıştırır$$, TRUE, 0),
    ($$Değer state'te yaşadığı için, aynı anda ekranda başka bir yerde de anında kullanılabilir (bir karakter sayacı gibi)$$, TRUE, 1),
    ($$Input'un DOM değeri önce kendini günceller, state daha sonra yetişir$$, FALSE, 2),
    ($$Bu döngü yalnızca metin input'ları için çalışır, checkbox'lar ya da select'ler için asla çalışmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlled-components'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

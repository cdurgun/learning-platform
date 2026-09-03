-- Promotion-style migration linking TR what-are-hooks quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir hook nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir hook nedir?$$,
           NULL, NULL,
           $$Bir hook, adı use ile başlayan ve function component'lere React özellikleri (state, side effect, DOM referansları ve daha fazlası) eklemeni sağlayan bir fonksiyondur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$Uygulamadaki her component'i listeleyen bir yapılandırma dosyası$$, FALSE, 0),
    ($$Adı use ile başlayan ve function component'lere React özellikleri eklemeni sağlayan bir fonksiyon$$, TRUE, 1),
    ($$Bir component'i belirli bir stile bağlayan bir CSS class'ı$$, FALSE, 2),
    ($$Yalnızca class component'ler içinde kullanılan özel bir JSX tag'i$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hook'lar var olmadan önce, state ve diğer React özellikleri nerede kullanılabiliyordu?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Hook'lar var olmadan önce, state ve diğer React özellikleri nerede kullanılabiliyordu?$$,
           NULL, NULL,
           $$Hook'lardan önce, state ve diğer React özellikleri yalnızca farklı bir sözdizimiyle yazılan "class component"lerde kullanılabiliyordu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$Yalnızca CSS dosyalarının içinde$$, FALSE, 0),
    ($$Hook'lar tanıtılmadan önce React'te state hiç var olmadı$$, FALSE, 1),
    ($$Yalnızca farklı bir sözdizimiyle yazılan class component'lerin içinde$$, TRUE, 2),
    ($$Zaten function component'lerde birebir aynı şekilde kullanılabiliyordu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Rules of Hooks'a göre, bir hook bir component içinde nereden çağrılabilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Rules of Hooks'a göre, bir hook bir component içinde nereden çağrılabilir?$$,
           NULL, NULL,
           $$Hook'lar her zaman bir component'in en üst seviyesinde çağrılır -- asla bir if içine, bir for döngüsüne ya da başka bir fonksiyonun içine yerleştirilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$Bir return ifadesinin içinde olduğu sürece herhangi bir yerde$$, FALSE, 0),
    ($$Yalnızca props'un değişip değişmediğini kontrol eden bir if ifadesinin içinde$$, FALSE, 1),
    ($$Yalnızca bir öğe listesi üzerinde yineleme yapan bir for döngüsünün içinde$$, FALSE, 2),
    ($$Her zaman en üst seviyede -- asla bir if içine, bir for döngüsüne ya da başka bir fonksiyonun içine değil$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$function toplamHesapla() {
    const [toplam, toplamAyarla] = useState(0); // toplamHesapla sıradan bir fonksiyon, component değil
    return toplam;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$function toplamHesapla() {
    const [toplam, toplamAyarla] = useState(0); // toplamHesapla sıradan bir fonksiyon, component değil
    return toplam;
}$$, $$jsx$$,
           $$Hook'lar yalnızca function component'lerin içinde çalışır -- useState'i sıradan bir JavaScript fonksiyonunun (component olmayan) içinde çağırmak bir hataya yol açar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$React, toplamHesapla'yı otomatik olarak sessizce bir component'e dönüştürür$$, FALSE, 0),
    ($$Sorunsuz çalışır, çünkü useState herhangi bir JavaScript fonksiyonundan çağrılabilir$$, FALSE, 1),
    ($$toplamHesapla sıradan bir fonksiyon olduğu, bir component ya da başka bir hook olmadığı için bir hataya yol açar$$, TRUE, 2),
    ($$toplam her zaman undefined'dır, ama hiçbir hata fırlatılmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Rules of Hooks'u ihlal etmek (bir hook'u koşullu olarak çağırmak gibi) React'i neden karıştırır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Rules of Hooks'u ihlal etmek (bir hook'u koşullu olarak çağırmak gibi) React'i neden karıştırır?$$,
           NULL, NULL,
           $$React, hook'ların her render'da aynı sırada çağrıldığını varsayarak state'i doğru hook çağrısıyla eşleştirir -- bu varsayımı bozmak hangi state'in hangi hook çağrısına ait olduğunu karıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$Yalnızca performansı ilgilendirir, doğruluğu asla ilgilendirmez$$, FALSE, 0),
    ($$React, her render'da hook'ların aynı sırada çağrıldığını varsayarak state'i doğru hook çağrısıyla eşleştirir$$, TRUE, 1),
    ($$Gerçekte hiçbir sorun yaratmaz -- yalnızca stilistik bir en iyi uygulamadır$$, FALSE, 2),
    ($$Bir hook atlandığında React tüm component ağacını sıfırdan yeniden derler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kart gerçek bir function component. useState çağırdığında ne olur?$$
      AND code_snippet = $$function Kart() {
    const [acik, acikAyarla] = useState(false);
    return <div>{acik ? "Acik" : "Kapali"}</div>;
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kart gerçek bir function component. useState çağırdığında ne olur?$$,
           $$function Kart() {
    const [acik, acikAyarla] = useState(false);
    return <div>{acik ? "Acik" : "Kapali"}</div>;
}$$, $$jsx$$,
           $$Kart gerçek bir function component olduğu için, içinde useState çağırmak tam olarak amaçlandığı gibi çalışır -- bu kurstaki her component bir function component olduğu için hook kullanmaya uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$Çalışır, ama yalnızca Kart aynı zamanda useEffect ile de sarmalanmışsa$$, FALSE, 0),
    ($$Kart aynı zamanda props'a sahip olmadıkça useState sessizce hiçbir şey yapmaz$$, FALSE, 1),
    ($$Kart gerçek bir function component olduğu için doğru şekilde çalışır$$, TRUE, 2),
    ($$Yalnızca class component'ler hook çağırabildiği için bir hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-are-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, hook'lar ve use... isimlendirme kalıbı ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hook'lar ve use... isimlendirme kalıbı ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useState, React'in sana hazır verdiği bir hook'tur; useEffect, useRef, useMemo ve useCallback hepsi useState ile aynı use... isimlendirme kalıbını izler; bunların hepsi hook'tur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-are-hooks'
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
    ($$useState, React'in sana hazır verdiği bir hook'tur$$, TRUE, 0),
    ($$useEffect, useRef, useMemo ve useCallback hepsi useState ile aynı use... isimlendirme kalıbını izler$$, TRUE, 1),
    ($$Yalnızca useState gerçek bir hook sayılır; diğerleri farklı bir React özelliği türüdür$$, FALSE, 2),
    ($$Bir fonksiyonun hook sayılması için yalnızca yararlı bir şey yapması yeterlidir -- use öneki aslında gerekli değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-are-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

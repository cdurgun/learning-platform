-- Promotion-style migration linking TR state quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$State nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$State nedir?$$,
           NULL, NULL,
           $$State, bir component'in zamanla değişebilen, "hatırladığı" verisidir; state değiştiğinde React o component'i otomatik olarak yeniden render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$Bir component'in orijinal olarak yazıldığı HTML işaretlemesi$$, FALSE, 0),
    ($$Bir component'in zamanla değişebilen, "hatırladığı" verisi, değiştiğinde bir yeniden render tetikler$$, TRUE, 1),
    ($$Bir component'in parent'ından aldığı, asla değişmeyen veri$$, FALSE, 2),
    ($$Bir component'in mevcut görsel stilini tanımlayan bir CSS class'ı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu koddaki sayi ve sayiAyarla neyi temsil eder?$$
      AND code_snippet = $$const [sayi, sayiAyarla] = useState(0);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu koddaki sayi ve sayiAyarla neyi temsil eder?$$,
           $$const [sayi, sayiAyarla] = useState(0);$$, $$jsx$$,
           $$useState(0), başlangıç değeri 0 olan bir state kurar ve iki şey döndürür: mevcut değer (sayi) ve onu güncellemek için bir fonksiyon (sayiAyarla).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$sayi ve sayiAyarla'nın ikisi de aynı başlangıç değerinin salt okunur kopyalarıdır$$, FALSE, 0),
    ($$sayi component'in adıdır; sayiAyarla onun props nesnesidir$$, FALSE, 1),
    ($$sayi mevcut state değeridir; sayiAyarla onu güncellemek için kullanılan fonksiyondur$$, TRUE, 2),
    ($$sayi bir fonksiyondur; sayiAyarla mevcut değerdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu düğmeye tıklandığında ne olur?$$
      AND code_snippet = $$function Sayac() {
    const [sayi, sayiAyarla] = useState(0);

    function handleClick() {
        sayi = sayi + 1; // dogrudan atama, sayiAyarla degil
    }

    return <button onClick={handleClick}>{sayi}</button>;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu düğmeye tıklandığında ne olur?$$,
           $$function Sayac() {
    const [sayi, sayiAyarla] = useState(0);

    function handleClick() {
        sayi = sayi + 1; // dogrudan atama, sayiAyarla degil
    }

    return <button onClick={handleClick}>{sayi}</button>;
}$$, $$jsx$$,
           $$sayi'ya doğrudan atama yapmak React'e "bir şey değişti" demez, bu yüzden yeniden render olmaz -- gösterilen sayı asla güncellenmez (ve bu satır aslında hata fırlatır, çünkü useState ile tanımlanan sayi bu şekilde yeniden atanamaz).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$Düğmeye her tıklandığında gösterilen sayı 1 artar$$, FALSE, 0),
    ($$React, doğrudan atamayı perde arkasında otomatik olarak bir sayiAyarla çağrısına dönüştürür$$, FALSE, 1),
    ($$handleClick çalıştığında component hemen unmount olur$$, FALSE, 2),
    ($$Doğrudan atama React'e bir değişiklik olduğunu bildirmez, bu yüzden ekran yeni bir değeri göstermek için asla güncellenmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tek bir click handler içinde, sayiAyarla(sayi + 1) art arda iki kez çağrılıyor. Bunu sayiAyarla((oncekiSayi) => oncekiSayi + 1)'i iki kez çağırmakla karşılaştırınca sonuç nedir?$$
      AND code_snippet = $$function handleClick() {
    sayiAyarla(sayi + 1);
    sayiAyarla(sayi + 1);
    // buna karsi:
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Tek bir click handler içinde, sayiAyarla(sayi + 1) art arda iki kez çağrılıyor. Bunu sayiAyarla((oncekiSayi) => oncekiSayi + 1)'i iki kez çağırmakla karşılaştırınca sonuç nedir?$$,
           $$function handleClick() {
    sayiAyarla(sayi + 1);
    sayiAyarla(sayi + 1);
    // buna karsi:
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
}$$, $$jsx$$,
           $$sayiAyarla(sayi + 1), aynı render içinde birden fazla çağrılırsa güvenilir değildir, çünkü sayi o render boyunca sabit kalır -- her iki çağrı da aynı başlangıç değerini kullanır. Fonksiyonel biçim her seferinde en güncel değere göre hesaplar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$sayiAyarla(sayi + 1), fonksiyonel biçimden her zaman daha güvenilirdir$$, FALSE, 0),
    ($$İki biçim de her zaman sayıyı tam olarak 2 artırır, aralarında hiçbir fark yoktur$$, FALSE, 1),
    ($$sayiAyarla(sayi + 1)'i iki kez çağırmak sayıyı 2 artırmayabilir, çünkü sayi o render boyunca sabit kalır; fonksiyonel biçim güvenilir şekilde artırır$$, TRUE, 2),
    ($$Fonksiyonel biçim geçersiz bir sözdizimidir ve hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$let ile tanımlanan sıradan bir değişkeni değiştirmek, state değiştirmenin yaptığı gibi ekranı neden güncellemez?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$let ile tanımlanan sıradan bir değişkeni değiştirmek, state değiştirmenin yaptığı gibi ekranı neden güncellemez?$$,
           NULL, NULL,
           $$React, sıradan bir değişkenin değişikliğinden haberdar olmadığı için, component'i yeniden render etmesi için bir nedeni yoktur -- useState özeldir çünkü React'e "bu değer değiştiğinde bana haber ver" der.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$Gerçek bir fark yoktur -- ikisi de ekranı aynı şekilde günceller$$, FALSE, 0),
    ($$Çünkü React değişiklikten haberdar olmadığı için, component'i yeniden render etmesi için bir nedeni yoktur$$, TRUE, 1),
    ($$Çünkü let değişkenleri JavaScript'te her zaman salt okunurdur$$, FALSE, 2),
    ($$Çünkü let değişkenleri yalnızca sayı tutabilir, başka veri tipleri tutamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Nesne/dizi state'i için state immutability'sini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Nesne/dizi state'i için state immutability'sini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Mevcut olanı mutate etmek yerine her zaman YENİ bir nesne/dizi oluşturmalısın; spread operatörü, yalnızca belirtilen alanı değiştirerek eski nesnenin tüm alanlarını yeni birine kopyalar; bir nesneyi doğrudan mutate edip aynı nesneyi geri vermek React'in değişikliği fark edeceğini garanti etmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$Spread operatörü ({ ...user, age: ... }), yalnızca belirtilen alanı değiştirerek eski nesnenin tüm alanlarını yeni birine kopyalar$$, TRUE, 0),
    ($$Bir nesneyi doğrudan mutate edip aynı nesneyi geri vermek, React'in her zaman doğru şekilde yeniden render edeceğini garanti eder$$, FALSE, 1),
    ($$State immutability yalnızca dizilere uygulanır, sıradan nesnelere asla uygulanmaz$$, FALSE, 2),
    ($$Mevcut olanı mutate etmek yerine her zaman yeni bir nesne/dizi oluşturup onu setter'a geçirmelisin$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'state')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$sayiAyarla(...) çağrıldığında ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$sayiAyarla(...) çağrıldığında ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$React, state'in yeni değerini kaydeder ve component'i o yeni değerle yeniden render eder -- ikisi de setter'ı çağırmanın bir sonucu olarak birlikte gerçekleşir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'state'
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
    ($$React, state'in yeni değerini kaydeder$$, TRUE, 0),
    ($$React, component'i yeni değerle yeniden render eder$$, TRUE, 1),
    ($$sayiAyarla(...)'yı çağırmak, bir yeniden render olmadan sayi değişkenini yerinde hemen mutate eder$$, FALSE, 2),
    ($$sayiAyarla(...), yalnızca bir JSX ifadesinin içinden çağrılabilir, sıradan bir fonksiyondan asla çağrılamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'state'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

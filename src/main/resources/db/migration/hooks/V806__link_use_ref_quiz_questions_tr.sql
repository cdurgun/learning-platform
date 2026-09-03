-- Promotion-style migration linking TR use-ref quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir JSX elementine ref={inputRef} yazmak gerçekte ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir JSX elementine ref={inputRef} yazmak gerçekte ne yapar?$$,
           NULL, NULL,
           $$React'e "bu elementin gerçek DOM node'unu inputRef.current'a koy" der -- inputRef.current, focus() gibi tarayıcı metotlarını çağırabileceğin gerçek bir DOM elementi olur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$Elementi otomatik olarak bir child component'e prop olarak geçirir$$, FALSE, 0),
    ($$React'e o elementin gerçek DOM node'unu inputRef.current'a koymasını söyler$$, TRUE, 1),
    ($$Input değiştiğinde her zaman yeniden render olan yeni bir state değişkeni oluşturur$$, FALSE, 2),
    ($$Elemente doğrudan bir CSS stili ekler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Her render'da renderSayaci.current'ı artırmak, tek başına, bir yeniden render tetikler mi?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Her render'da renderSayaci.current'ı artırmak, tek başına, bir yeniden render tetikler mi?$$,
           NULL, NULL,
           $$Hayır -- renderSayaci.current artar ve değeri render'lar arasında kalıcıdır, ama bu artış tek başına bir yeniden render tetiklemez; güncellenen değeri yalnızca başka bir nedenle tetiklenen bir sonraki render'da görürsün.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$Evet, ama yalnızca her üçüncü render'da$$, FALSE, 0),
    ($$Aynı component'te useEffect'in de kullanılıp kullanılmadığına bağlıdır$$, FALSE, 1),
    ($$Hayır -- artış tek başına bir yeniden render tetiklemez$$, TRUE, 2),
    ($$Evet -- bir ref'in .current değerindeki herhangi bir değişiklik her zaman bir yeniden render tetikler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, useRef ile useState arasındaki temel fark nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useRef ile useState arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$useState ile state değiştirmek bir yeniden render TETİKLER; bir ref'i değiştirmek TETİKLEMEZ.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$useRef yalnızca sayı saklayabilirken, useState herhangi bir tip saklayabilir$$, FALSE, 0),
    ($$useState her koşulda useRef'ten her zaman daha yavaştır$$, FALSE, 1),
    ($$useRef bir dependency array gerektirir, useState hiçbir zaman gerektirmez$$, FALSE, 2),
    ($$useState ile state değiştirmek bir yeniden render tetikler; bir ref'i değiştirmek tetiklemez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Ref Artir" düğmesine tıklandığında ekranda ne olur?$$
      AND code_snippet = $$function Sayac() {
    const refDegeri = useRef(0);

    function handleClick() {
        refDegeri.current = refDegeri.current + 1;
        console.log(refDegeri.current);
    }

    return <button onClick={handleClick}>Ref Artir: {refDegeri.current}</button>;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Ref Artir" düğmesine tıklandığında ekranda ne olur?$$,
           $$function Sayac() {
    const refDegeri = useRef(0);

    function handleClick() {
        refDegeri.current = refDegeri.current + 1;
        console.log(refDegeri.current);
    }

    return <button onClick={handleClick}>Ref Artir: {refDegeri.current}</button>;
}$$, $$jsx$$,
           $$Ref'in değeri gerçekten değişir (console'da görülebilir), ama ekranda hiçbir şey değişmez -- bir ref değişikliği React'e "yeniden render et" demez, bu yüzden gösterilen sayı başka bir state değişikliği bir yeniden render'a neden olana kadar aynı kalır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$Console yeni değeri loglar, ama düğmede gösterilen sayı görsel olarak güncellenmez$$, TRUE, 0),
    ($$Düğmedeki gösterilen sayı beklendiği gibi hemen 1 artar$$, FALSE, 1),
    ($$Hiçbir şey olmaz -- refDegeri.current gerçekte hiç değişmez$$, FALSE, 2),
    ($$Ref'ler bir event handler içinde mutate edilemediği için React bir hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin rehberliğine göre, ne zaman state'e, ne zaman bir ref'e başvurmalısın?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin rehberliğine göre, ne zaman state'e, ne zaman bir ref'e başvurmalısın?$$,
           NULL, NULL,
           $$Ekranda GÖRÜNÜR olması gereken bir değer state olmalıdır; ekranda görünmesi gerekmeyen, yalnızca "hatırlanması" gereken bir değer ref olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$Ref'ler yalnızca sayılar içindir; string ve nesneler için state kullanılmalıdır$$, FALSE, 0),
    ($$Ekranda görünür olması gereken bir değer state olmalıdır; görünmesi gerekmeyen bir "arka plan" değeri ref olabilir$$, TRUE, 1),
    ($$Ref'ler, gereksiz yeniden render'ları hiç tetiklemediği için her zaman state'e tercih edilmelidir$$, FALSE, 2),
    ($$State ve ref'ler tamamen birbirinin yerine geçebilir ve seçim hiçbir zaman önemli değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$sayi 5'ten başlıyor, sonra sayi 8'e değiştikten sonra component yeniden render ediliyor. Effect tekrar çalışmadan önce, O render SIRASINDA oncekiSayiRef.current ne tutar?$$
      AND code_snippet = $$function Takipci({ sayi }) {
    const oncekiSayiRef = useRef();

    useEffect(() => {
        oncekiSayiRef.current = sayi;
    });

    return <p>Simdi: {sayi}, Once: {oncekiSayiRef.current}</p>;
}
// sayi 5'ten 8'e degisiyor, bir yeniden render tetikliyor$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$sayi 5'ten başlıyor, sonra sayi 8'e değiştikten sonra component yeniden render ediliyor. Effect tekrar çalışmadan önce, O render SIRASINDA oncekiSayiRef.current ne tutar?$$,
           $$function Takipci({ sayi }) {
    const oncekiSayiRef = useRef();

    useEffect(() => {
        oncekiSayiRef.current = sayi;
    });

    return <p>Simdi: {sayi}, Once: {oncekiSayiRef.current}</p>;
}
// sayi 5'ten 8'e degisiyor, bir yeniden render tetikliyor$$, $$jsx$$,
           $$Bir ref'i güncellemek tek başına yeni bir render tetiklemediği için, oncekiSayiRef.current bu render sırasında, effect (render'dan sonra çalışan) onu 8'e güncellemeden önce, hâlâ ÖNCEKİ render'ın değerini (5) tutar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$undefined, çünkü ref hiçbir zaman bir başlangıç değeriyle başlatılmadı$$, FALSE, 0),
    ($$Her render'da sayi'nin o anki değerine her zaman eşittir$$, FALSE, 1),
    ($$5, önceki render'dan kaydedilen değer, çünkü effect bu render için henüz çalışmadı$$, TRUE, 2),
    ($$8, çünkü ref sayi değiştiğinde hemen güncellenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, useRef'in .current alanı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useRef'in .current alanı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$.current, şu anda saklanan değeri tutar; bu, ref attribute'u aracılığıyla gerçek bir DOM node'u ya da sade, kalıcı bir değer olabilir; .current'ı değiştirmek bir yeniden render tetiklemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$.current, useRef'in döndürdüğü nesnede şu anda saklanan değeri tutan alandır$$, TRUE, 0),
    ($$ref attribute'uyla kullanıldığında, .current tarayıcı metotlarını çağırabileceğin gerçek bir DOM elementi olur$$, TRUE, 1),
    ($$.current'ı değiştirmek, tıpkı bir state setter çağırmak gibi her zaman component'in yeniden render olmasına neden olur$$, FALSE, 2),
    ($$.current yalnızca bir DOM elementi tutabilir, asla sade bir sayı ya da başka bir değer tutamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

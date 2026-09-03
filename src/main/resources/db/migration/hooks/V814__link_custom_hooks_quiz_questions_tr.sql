-- Promotion-style migration linking TR custom-hooks quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir custom hook nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir custom hook nedir?$$,
           NULL, NULL,
           $$Bir custom hook, içinde React'in kendi hook'larını (useState, useEffect vb.) kullanan, yazdığın sıradan bir fonksiyondur -- tekrarlanan state+effect mantığını çıkarmak için kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Hiçbir şey render etmeyen ama children'ı sarmalayan bir JSX component'i$$, FALSE, 0),
    ($$İçinde React'in kendi hook'larını kullanan, yazdığın sıradan bir fonksiyon$$, TRUE, 1),
    ($$Uygulama başına yalnızca bir kez kullanılabilen, yerleşik bir React hook'u$$, FALSE, 2),
    ($$Hook kullanan her component'e otomatik olarak uygulanan özel bir CSS class'ı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir fonksiyonun custom hook sayılması için tek gereklilik nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir fonksiyonun custom hook sayılması için tek gereklilik nedir?$$,
           NULL, NULL,
           $$Tek gereklilik, adının use ile başlamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Bir JSX elementi döndürmelidir$$, FALSE, 0),
    ($$Tam olarak bir parametre almalıdır, ne daha fazla ne daha az$$, FALSE, 1),
    ($$Adı use ile başlamalıdır$$, TRUE, 2),
    ($$Kendi ayrı dosyasında tanımlanmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir custom hook'un adındaki use öneki neden önemlidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir custom hook'un adındaki use öneki neden önemlidir?$$,
           NULL, NULL,
           $$Hem React'e (Rules of Hooks kontrolleri için) hem de kodunu okuyan diğer geliştiricilere "bu bir hook'tur ve içinde başka hook'lar çağırabilir" sinyalini verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Gerçekte hiçbir etkisi yoktur -- tamamen kozmetik bir isimlendirme tercihidir$$, FALSE, 0),
    ($$Fonksiyonun sıradan adlandırılmış bir fonksiyondan daha hızlı çalışmasını sağlar$$, FALSE, 1),
    ($$Yalnızca useEffect kullanan hook'lar için gereklidir, başka hiçbir hook için değil$$, FALSE, 2),
    ($$React'e ve diğer geliştiricilere, bunun içinde başka hook'lar çağırabilen bir hook olduğu sinyalini verir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$elmalar ve portakallar ikisi de useSayac() çağırıyor. Aynı sayi değerini paylaşırlar mı?$$
      AND code_snippet = $$function useSayac() {
    const [sayi, sayiAyarla] = useState(0);
    return [sayi, sayiAyarla];
}

function MeyveSepeti() {
    const [elmalar, elmalarAyarla] = useSayac();
    const [portakallar, portakallarAyarla] = useSayac();
    // elmalarAyarla uc kez cagriliyor, portakallarAyarla hic cagrilmiyor
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$elmalar ve portakallar ikisi de useSayac() çağırıyor. Aynı sayi değerini paylaşırlar mı?$$,
           $$function useSayac() {
    const [sayi, sayiAyarla] = useState(0);
    return [sayi, sayiAyarla];
}

function MeyveSepeti() {
    const [elmalar, elmalarAyarla] = useSayac();
    const [portakallar, portakallarAyarla] = useSayac();
    // elmalarAyarla uc kez cagriliyor, portakallarAyarla hic cagrilmiyor
}$$, $$jsx$$,
           $$Bir custom hook'a yapılan her çağrı kendi BAĞIMSIZ state'ini alır -- elmalar ve portakallar, aynı useSayac hook'unu kullansalar bile tamamen bağımsız iki state parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Hayır -- her çağrı kendi bağımsız state'ini alır, bu yüzden elmalar ve portakallar birbiriyle ilgisizdir$$, TRUE, 0),
    ($$Evet -- useSayac'a yapılan her iki çağrı da tam olarak aynı temel state'i paylaşır ve günceller$$, FALSE, 1),
    ($$Bağımsız başlarlar ama ilk elmalarAyarla çağrısından sonra birbirine bağlanırlar$$, FALSE, 2),
    ($$İki çağrıdan yalnızca biri gerçekten çalışır; ikincisi bir hata fırlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir custom hook'u component'ler arasında yeniden kullandığında, gerçekte yeniden kullanılan nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir custom hook'u component'ler arasında yeniden kullandığında, gerçekte yeniden kullanılan nedir?$$,
           NULL, NULL,
           $$Custom hook'ların gücü budur: state'in kendisini değil, state'i YÖNETME MANTIĞINI yeniden kullanıyorsun -- her kullanım kendi bağımsız state'ini alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Hook'un ilk bağlandığı belirli DOM node'u$$, FALSE, 0),
    ($$State'i yönetme mantığı -- state'in kendisi değil$$, TRUE, 1),
    ($$Onu kullanan her component arasında paylaşılan ve senkronize edilen, tam olarak aynı state değeri$$, FALSE, 2),
    ($$Component'in kendi JSX işaretlemesi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin örneğine göre, useFetch hangi iki yerleşik hook'u birleştirir?$$
      AND code_snippet = $$function useFetch(url) {
    const [veri, veriAyarla] = useState(null);
    const [yukleniyor, yukleniyorAyarla] = useState(true);

    useEffect(() => {
        // sonunda veriAyarla ve yukleniyorAyarla'yi cagiran fetch mantigi
    }, [url]);

    return { veri, yukleniyor };
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin örneğine göre, useFetch hangi iki yerleşik hook'u birleştirir?$$,
           $$function useFetch(url) {
    const [veri, veriAyarla] = useState(null);
    const [yukleniyor, yukleniyorAyarla] = useState(true);

    useEffect(() => {
        // sonunda veriAyarla ve yukleniyorAyarla'yi cagiran fetch mantigi
    }, [url]);

    return { veri, yukleniyor };
}$$, $$jsx$$,
           $$useFetch, useState'i (veri ve yükleme durumu için) useEffect ile (veriyi getirmek için) birleştirir, bunları her component'te yeniden yazmak yerine tek bir yerde toplar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$useCallback ve useContext$$, FALSE, 0),
    ($$Yalnızca useEffect -- useState aslında dahil değildir$$, FALSE, 1),
    ($$useState ve useEffect$$, TRUE, 2),
    ($$useRef ve useMemo$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-hooks')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bir custom hook'u sıradan bir JavaScript yardımcı fonksiyonundan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir custom hook'u sıradan bir JavaScript yardımcı fonksiyonundan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir custom hook, içinde React'in kendi hook'larını (useState gibi) kullanabilir; useSayac, içinde useState çağıran, yazdığın bir fonksiyondur, bu sıradan bir yardımcı fonksiyonun yapabildiği (ya da kendisi bir hook olmadan yapmasına izin verilen) bir şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-hooks'
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
    ($$Bir custom hook, içinde React'in kendi hook'larını (useState gibi) kullanabilir$$, TRUE, 0),
    ($$Bir custom hook'un adı, başka hook'lar çağırabileceğini belirten use isimlendirme kalıbını izler$$, TRUE, 1),
    ($$Sıradan bir yardımcı fonksiyon ile bir custom hook her açıdan işlevsel olarak birebir aynıdır$$, FALSE, 2),
    ($$Bir custom hook her zaman onu kullanan component'in içinde tanımlanmalıdır, asla ayrı bir dosyada değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-hooks'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

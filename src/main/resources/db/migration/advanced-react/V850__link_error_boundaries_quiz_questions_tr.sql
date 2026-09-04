-- Promotion-style migration linking TR error-boundaries quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir error boundary, hook'lar kullanan bir function component olarak yazılabilir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir error boundary, hook'lar kullanan bir function component olarak yazılabilir mi?$$,
           NULL, NULL,
           $$Error boundary'leri hook'larla yazmanın bir yolu yoktur -- yalnızca class component'ler kullanılarak yazılabilirler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Evet, ama yalnızca özel bir custom hook ile birleştirildiğinde$$, FALSE, 0),
    ($$Hayır -- error boundary'ler yalnızca class component'ler kullanılarak yazılabilir$$, TRUE, 1),
    ($$Evet -- herhangi bir function component otomatik olarak bir error boundary olur$$, FALSE, 2),
    ($$Evet, useState'i useEffect ile birleştirerek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$static getDerivedStateFromError() ne için kullanılır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$static getDerivedStateFromError() ne için kullanılır?$$,
           NULL, NULL,
           $$Bir child hata fırlattığında React tarafından çağrılır -- döndürdüğü değer yeni state olur ve fallback UI'yi tetikler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Herhangi bir hatanın baştan hiç fırlatılmasını engeller$$, FALSE, 0),
    ($$Hatalardan bağımsız olarak, uygulama ilk başladığında bir kez çalışır$$, FALSE, 1),
    ($$Bir child hata fırlattığında çağrılır; döndürdüğü değer yeni state olur ve fallback UI'yi tetikler$$, TRUE, 2),
    ($$Hatayı otomatik olarak harici bir loglama servisine gönderir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$getDerivedStateFromError zaten varken, componentDidCatch neden gereklidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$getDerivedStateFromError zaten varken, componentDidCatch neden gereklidir?$$,
           NULL, NULL,
           $$getDerivedStateFromError YALNIZCA fallback UI'yi göstermek içindir -- hatayı bir yere göndermek (loglamak) ayrı componentDidCatch(error, errorInfo) metodunu gerektirir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$componentDidCatch, getDerivedStateFromError'ın yerini tamamen alır -- yalnızca biri gerekir$$, FALSE, 0),
    ($$componentDidCatch, uygulamanın hiç çökmemesini sağlamak için gereklidir$$, FALSE, 1),
    ($$componentDidCatch, getDerivedStateFromError'dan sonra değil önce çalışır$$, FALSE, 2),
    ($$getDerivedStateFromError yalnızca fallback UI'yi gösterir; componentDidCatch, hatayı loglamak için ayrı metottur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$HatalıSayac, sayi 3'e ulaştığında hata fırlatıyor ve bir HataSiniri ile sarmalanmış. sayi 3'e ulaştıktan sonra kullanıcı ne görür?$$
      AND code_snippet = $$function HataliSayac({ sayi }) {
    if (sayi === 3) {
        throw new Error("Sayac coktu!");
    }
    return <p>{sayi}</p>;
}

<HataSiniri>
    <HataliSayac sayi={3} />
</HataSiniri>$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$HatalıSayac, sayi 3'e ulaştığında hata fırlatıyor ve bir HataSiniri ile sarmalanmış. sayi 3'e ulaştıktan sonra kullanıcı ne görür?$$,
           $$function HataliSayac({ sayi }) {
    if (sayi === 3) {
        throw new Error("Sayac coktu!");
    }
    return <p>{sayi}</p>;
}

<HataSiniri>
    <HataliSayac sayi={3} />
</HataSiniri>$$, $$jsx$$,
           $$HataSiniri, fırlatılan hatayı yakalar ve normal render'ın yerine bir fallback UI koyar -- HataliSayac'ın kendisinin hatayı ele alması gerekmez, bu error boundary'nin işidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Tarayıcının varsayılan JavaScript hata konsolu diyaloğu$$, FALSE, 0),
    ($$Sanki hiçbir şey olmamış gibi 3 sayısı normal şekilde gösterilir$$, FALSE, 1),
    ($$React tüm uygulamayı unmount ettiği için boş, beyaz bir ekran$$, FALSE, 2),
    ($$Render sırasında fırlatılan hatayı yakaladığı için HataSiniri'nin fallback UI'si$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, tek bir büyük error boundary yerine birden fazla küçük error boundary kullanmayı neden önerir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, tek bir büyük error boundary yerine birden fazla küçük error boundary kullanmayı neden önerir?$$,
           NULL, NULL,
           $$Bir bölüm kendi boundary'si içinde çökerse, diğer bölümler (ayrı boundary'lerle sarmalanmış) ETKİLENMEZ; tek bir büyük boundary ile, herhangi bir hata TÜM sayfayı bir fallback mesajına dönüştürebilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Bir bölümdeki çökmenin tüm sayfayı bir fallback mesajına dönüştürmesini önlemek için$$, TRUE, 0),
    ($$Çünkü tek bir error boundary toplamda yalnızca tam olarak bir hatayı yakalayabilir, hiçbir zaman daha fazlasını yakalayamaz$$, FALSE, 1),
    ($$React her uygulama için en az iki error boundary gerektirdiği için$$, FALSE, 2),
    ($$Küçük boundary'ler, uygulamanın JavaScript bundle'ını küçültür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, error boundary'lerin YAKALAMADIĞI şeylerle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, error boundary'lerin YAKALAMADIĞI şeylerle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Error boundary'ler yalnızca RENDER sırasında fırlatılan hataları yakalar -- event handler'lardaki, asenkron koddaki, server-side rendering'deki ya da boundary'nin kendisindeki hataları YAKALAMAZ.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$setTimeout ya da fetch callback'leri gibi asenkron kodda fırlatılan hatalar$$, TRUE, 0),
    ($$Boundary'nin sarmaladığı bir component tarafından render sırasında fırlatılan hatalar$$, FALSE, 1),
    ($$Hiçbir istisna olmadan, tüm uygulamadaki her tür hata$$, FALSE, 2),
    ($$onClick gibi bir event handler içinde fırlatılan hatalar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu onClick handler'ının içinde bir hata fırlatılıyor, ve düğme bir HataSiniri ile sarmalanmış. HataSiniri bunu yakalar mı?$$
      AND code_snippet = $$function handleClick() {
    throw new Error("Tiklama basarisiz!");
}

<HataSiniri>
    <button onClick={handleClick}>Tikla</button>
</HataSiniri>$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu onClick handler'ının içinde bir hata fırlatılıyor, ve düğme bir HataSiniri ile sarmalanmış. HataSiniri bunu yakalar mı?$$,
           $$function handleClick() {
    throw new Error("Tiklama basarisiz!");
}

<HataSiniri>
    <button onClick={handleClick}>Tikla</button>
</HataSiniri>$$, $$jsx$$,
           $$Error boundary'ler event handler'lardaki hataları YAKALAMAZ -- yalnızca render sırasında fırlatılan hataları yakalar. handleClick içindeki hatalar için sıradan try/catch gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Evet -- HataSiniri, sarmaladığı bir component tarafından fırlatılan her hatayı, event handler'lar dahil yakalar$$, FALSE, 0),
    ($$Yalnızca getDerivedStateFromError, componentDidCatch ile birleştirilmişse$$, FALSE, 1),
    ($$Düğmenin ayrıca bir onError prop'una sahip olup olmadığına bağlıdır$$, FALSE, 2),
    ($$Hayır -- error boundary'ler yalnızca render sırasında fırlatılan hataları yakalar, event handler'ların içindekileri değil$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

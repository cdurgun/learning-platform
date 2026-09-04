-- Promotion-style migration linking TR suspense quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Suspense, fallback'ini ne zaman gösterir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Suspense, fallback'ini ne zaman gösterir?$$,
           NULL, NULL,
           $$Suspense, içindeki bir şey henüz hazır olmadığı sürece bir fallback gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Yalnızca tüm uygulamanın ilk render'ı sırasında$$, FALSE, 0),
    ($$Suspense sınırının içindeki bir şey henüz hazır olmadığı sürece$$, TRUE, 1),
    ($$Suspense'i kullanan component var olduğu sürece, kalıcı olarak$$, FALSE, 2),
    ($$Yalnızca tarayıcı penceresi yeniden boyutlandırıldığında$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$fallback prop'u ne olabilir ve içerik hazır olduğunda ona ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$fallback prop'u ne olabilir ve içerik hazır olduğunda ona ne olur?$$,
           NULL, NULL,
           $$fallback, yalnızca metin değil, bir spinner, bir skeleton ekran ya da başka bir component gibi HERHANGİ BİR JSX olabilir; içindeki component hazır olduğunda, fallback otomatik olarak gerçek içerikle DEĞİŞTİRİLİR.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$İçerik hazır olduğunda, gerçek içeriğin yanında sonsuza kadar görünür kalır$$, FALSE, 0),
    ($$Yükleme bittiğinde ayrı bir fonksiyon çağrısıyla elle kaldırılmalıdır$$, FALSE, 1),
    ($$Spinner ya da skeleton ekran gibi herhangi bir JSX olabilir; içerik hazır olduğunda otomatik olarak değiştirilir$$, TRUE, 2),
    ($$Yalnızca düz bir metin string'i -- JSX elementlerine fallback olarak izin verilmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$KursBaslik zaten yüklendi, ama iç Suspense içindeki KursYorumlari henüz yüklenmedi. Kullanıcı sayfanın geri kalanında ne görür?$$
      AND code_snippet = $$<Suspense fallback={<p>Sayfa yukleniyor...</p>}>
    <KursBaslik />
    <Suspense fallback={<p>Yorumlar yukleniyor...</p>}>
        <KursYorumlari />
    </Suspense>
</Suspense>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$KursBaslik zaten yüklendi, ama iç Suspense içindeki KursYorumlari henüz yüklenmedi. Kullanıcı sayfanın geri kalanında ne görür?$$,
           $$<Suspense fallback={<p>Sayfa yukleniyor...</p>}>
    <KursBaslik />
    <Suspense fallback={<p>Yorumlar yukleniyor...</p>}>
        <KursYorumlari />
    </Suspense>
</Suspense>$$, $$jsx$$,
           $$KursBaslik göründükten sonra, iç Suspense yalnızca KursYorumlari'nı kapsar -- sayfanın geri kalanı bir yükleme durumuna GERİ DÖNMEZ; yalnızca hâlâ bekleyen kısım yükleniyor gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Tüm sayfa, KursBaslik dahil, "Sayfa yukleniyor..."ya geri döner$$, FALSE, 0),
    ($$Hem KursBaslik hem KursYorumlari birlikte hazır olana kadar hiçbir şey render edilmez$$, FALSE, 1),
    ($$Her iki fallback mesajı da aynı anda, üst üste görünür$$, FALSE, 2),
    ($$KursBaslik görünür kalır, ve KursYorumlari'nın yerinde yalnızca "Yorumlar yukleniyor..." gösterilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$use() hook'u (React 19), bir Promise ile ne yapmanı sağlar?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$use() hook'u (React 19), bir Promise ile ne yapmanı sağlar?$$,
           NULL, NULL,
           $$use() hook'u, bir Promise'i DOĞRUDAN Suspense ile entegre edebilir -- bir Promise verildiğinde, henüz çözülmediyse, React'e beklemesini söyler ve en yakın Suspense'in fallback'ini gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Onu doğrudan Suspense ile entegre etmek -- çözülmediyse, React'e beklemesini ve en yakın fallback'i göstermesini söyler$$, TRUE, 0),
    ($$Herhangi bir Promise'i sıfır gecikmeyle senkron bir değere dönüştürmek$$, FALSE, 1),
    ($$Bekleyen bir Promise'i sabit bir zaman aşımından sonra otomatik olarak iptal etmek$$, FALSE, 2),
    ($$Her tür component state'i için useState'in tamamen yerini almak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, diğer hook'ların aksine, use() koşullu olarak çağrılabilir mi?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, diğer hook'ların aksine, use() koşullu olarak çağrılabilir mi?$$,
           NULL, NULL,
           $$Diğer hook'ların aksine, use() KOŞULLU olarak da çağrılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Yalnızca önce bir custom hook'a sarmalanırsa$$, FALSE, 0),
    ($$Evet -- diğer hook'ların aksine, use() koşullu olarak da çağrılabilir$$, TRUE, 1),
    ($$Hayır -- use(), istisnasız, diğer her hook ile tam olarak aynı yalnızca-en-üst-seviye kuralını izler$$, FALSE, 2),
    ($$Yalnızca bir class component'in render metodu içinde$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu component, bir Suspense sınırının içinde klasik useEffect + fetch kalıbını kullanıyor. fetch beklerken Suspense otomatik olarak fallback'ini gösterir mi?$$
      AND code_snippet = $$function KursListesi() {
    const [kurslar, kurslarAyarla] = useState(null);
    useEffect(() => {
        fetch("/kurslar").then((r) => r.json()).then(kurslarAyarla);
    }, []);
    return <ul>{kurslar?.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}

<Suspense fallback={<p>Yukleniyor...</p>}>
    <KursListesi />
</Suspense>$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu component, bir Suspense sınırının içinde klasik useEffect + fetch kalıbını kullanıyor. fetch beklerken Suspense otomatik olarak fallback'ini gösterir mi?$$,
           $$function KursListesi() {
    const [kurslar, kurslarAyarla] = useState(null);
    useEffect(() => {
        fetch("/kurslar").then((r) => r.json()).then(kurslarAyarla);
    }, []);
    return <ul>{kurslar?.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}

<Suspense fallback={<p>Yukleniyor...</p>}>
    <KursListesi />
</Suspense>$$, $$jsx$$,
           $$useEffect + fetch kalıbı Suspense'i otomatik olarak tetiklemez -- Suspense yalnızca use() gibi React'in DOĞRUDAN tanıdığı bir Promise kaynağıyla çalışır; bu component kendi yükleme state'ini kendisi yönetmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Yalnızca fetch çağrısı 1000ms'den uzun sürerse$$, FALSE, 0),
    ($$Yalnızca kurslarAyarla önce açıkça null ile çağrılırsa$$, FALSE, 1),
    ($$Hayır -- useEffect + fetch, Suspense'i otomatik olarak tetiklemez; component kendi yükleme state'ini kendisi yönetmelidir$$, TRUE, 2),
    ($$Evet -- bir Suspense sınırının içindeki herhangi bir component, fetch sırasında otomatik olarak fallback'i gösterir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Suspense'in otomatik olarak yapıp yapmadığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Suspense'in otomatik olarak yapıp yapmadığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Suspense yalnızca use() gibi React'in doğrudan tanıdığı bir Promise kaynağıyla otomatik olarak çalışır; useEffect + fetch gibi "klasik" veri getirme kalıpları onu otomatik olarak tetiklemez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Suspense yalnızca use() gibi React'in doğrudan tanıdığı bir Promise kaynağıyla otomatik olarak çalışır$$, TRUE, 0),
    ($$useEffect + fetch gibi "klasik" kalıplar Suspense'i otomatik olarak tetiklemez$$, TRUE, 1),
    ($$Bir React uygulamasındaki her asenkron işlem, en yakın Suspense'i otomatik olarak tetikler$$, FALSE, 2),
    ($$Suspense, her asenkron işlem için elle bir triggerSuspense() fonksiyonu çağrılmasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

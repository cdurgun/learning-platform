-- Promotion-style migration linking TR fetching-data quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$fetch(url) çağırmak ne döndürür?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$fetch(url) çağırmak ne döndürür?$$,
           NULL, NULL,
           $$fetch, tarayıcının yerleşik bir fonksiyonudur -- bir URL'ye HTTP isteği gönderir ve bir Promise döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$Hiçbir şey -- fetch'in hiç dönüş değeri yoktur$$, FALSE, 0),
    ($$Bir Promise$$, TRUE, 1),
    ($$Zaten bir JavaScript nesnesi olarak ayrıştırılmış, doğrudan response verisini$$, FALSE, 2),
    ($$İsteğin başarılı olup olmadığını belirten bir boolean$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, fetch'i neden boş bir dependency array [] ile bir useEffect içinde çağırır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, fetch'i neden boş bir dependency array [] ile bir useEffect içinde çağırır?$$,
           NULL, NULL,
           $$useEffect'in ikinci argümanı boş bir dizi olduğu için, bu istek yalnızca BİR KEZ, component ilk render edildiğinde çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$fetch yalnızca bir dependency array'in içinden çağrılabildiği için, başka hiçbir yerden değil$$, FALSE, 0),
    ($$Gerçek bir etkisi yoktur -- boş bir dizi, hiç useEffect olmamasıyla birebir aynı davranır$$, FALSE, 1),
    ($$İsteğin yalnızca bir kez, component ilk render edildiğinde çalışması için$$, TRUE, 2),
    ($$Veriyi her zaman taze tutmak için isteğin her tek yeniden render'da çalışması için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$yukleniyor şu anda true. Bu component ne render eder?$$
      AND code_snippet = $$function KursListesi() {
    const [yukleniyor, yukleniyorAyarla] = useState(true);
    const [kurslar, kurslarAyarla] = useState([]);

    if (yukleniyor) {
        return <p>Yukleniyor...</p>;
    }

    return <ul>{kurslar.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$yukleniyor şu anda true. Bu component ne render eder?$$,
           $$function KursListesi() {
    const [yukleniyor, yukleniyorAyarla] = useState(true);
    const [kurslar, kurslarAyarla] = useState([]);

    if (yukleniyor) {
        return <p>Yukleniyor...</p>;
    }

    return <ul>{kurslar.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}$$, $$jsx$$,
           $$yukleniyor true olduğu sürece, component <p>Yukleniyor...</p>'yi render eder ve ERKEN döner -- JSX'in geri kalanı (kurs listesi) asla çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$Hem "Yukleniyor..." hem de (boş) kurs listesi birlikte render edilir$$, FALSE, 0),
    ($$Yalnızca boş <ul>, çünkü kurslar boş bir dizi olarak başlar$$, FALSE, 1),
    ($$yukleniyor true olması bir hata olarak ele alındığı için hiçbir şey render edilmez$$, FALSE, 2),
    ($$Yalnızca "Yukleniyor..." -- fonksiyon erken döner, bu yüzden liste JSX'i asla çalışmaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Sunucu 404 ya da 500 durum koduyla yanıt verdiğinde, fetch Promise'ini otomatik olarak reddeder mi?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Sunucu 404 ya da 500 durum koduyla yanıt verdiğinde, fetch Promise'ini otomatik olarak reddeder mi?$$,
           NULL, NULL,
           $$fetch, 404 ya da 500 gibi durum kodlarında otomatik olarak reddetmez, bu yüzden response.ok'u kendimiz kontrol edip throw etmemiz gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$Hayır -- fetch, 404 ya da 500 gibi durum kodlarında otomatik olarak reddetmez; response.ok elle kontrol edilmelidir$$, TRUE, 0),
    ($$Evet -- 200 dışındaki herhangi bir durum otomatik olarak .catch()'i tetikler$$, FALSE, 1),
    ($$Yalnızca 500 seviyesi hatalar için, 404 için asla değil$$, FALSE, 2),
    ($$Yalnızca response body'si boşsa$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu options nesnesi fetch'e hangi üç şeyi sağlar?$$
      AND code_snippet = $$fetch("/kurslar", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ baslik: "React" }),
});$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu options nesnesi fetch'e hangi üç şeyi sağlar?$$,
           $$fetch("/kurslar", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ baslik: "React" }),
});$$, $$jsx$$,
           $$Bir POST isteğinde, fetch'in ikinci argümanı bir options nesnesidir: method ('POST'), headers (sunucuya verinin JSON olduğunu söyler) ve body (JSON.stringify ile string'e dönüştürülmüş, gönderilen veri).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$Bir callback fonksiyonu, bir hata işleyici ve bir yeniden deneme sayısı$$, FALSE, 0),
    ($$HTTP metodu, içerik tipini belirten header'lar, ve JSON string'i olarak gönderilen body$$, TRUE, 1),
    ($$URL, response formatı ve bir zaman aşımı süresi$$, FALSE, 2),
    ($$Yalnızca body -- method ve headers URL'den otomatik olarak çıkarılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Neyin gönderildiği açısından DELETE, PUT'tan tipik olarak nasıl farklıdır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Neyin gönderildiği açısından DELETE, PUT'tan tipik olarak nasıl farklıdır?$$,
           NULL, NULL,
           $$POST gibi, PUT de bir body gönderir -- ama URL, hangi kaydın güncelleneceğini belirtir; DELETE genellikle hiç body göndermez, yalnızca URL'nin id'si üzerinden hangi kaydın kaldırılacağını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$PUT ve DELETE her açıdan işlevsel olarak birebir aynıdır$$, FALSE, 0),
    ($$PUT, hangi kaydı etkileyeceğini asla belirtmez; yalnızca DELETE, URL üzerinden belirtir$$, FALSE, 1),
    ($$PUT, güncellenen veriyle bir body gönderir; DELETE genellikle hiç body göndermez$$, TRUE, 2),
    ($$DELETE her zaman bir body gönderir, PUT ise asla göndermez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'fetching-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir fetch isteği etrafındaki hata/yükleme yönetimini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir fetch isteği etrafındaki hata/yükleme yönetimini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$.catch(), fırlatılan hatayı yakalar ve error state'ine yazabilir; .finally(), başarı ya da başarısızlıktan bağımsız olarak loading'i kapatır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'fetching-data'
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
    ($$.catch(), fırlatılan bir hatayı yakalar ve error state'ine yazabilir$$, TRUE, 0),
    ($$.finally(), isteğin başarılı ya da başarısız olmasından bağımsız olarak loading'i kapatır$$, TRUE, 1),
    ($$.finally() yalnızca istek başarılı olduğunda çalışır, başarısız olduğunda asla çalışmaz$$, FALSE, 2),
    ($$response.ok, hiçbir kod gerekmeden fetch'in kendisi tarafından otomatik olarak kontrol edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'fetching-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR react-rest-api quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir React uygulaması genellikle kendi verisini nerede saklar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir React uygulaması genellikle kendi verisini nerede saklar?$$,
           NULL, NULL,
           $$Bir React uygulaması genellikle kendi verisini saklamaz -- bir backend'e HTTP isteği gönderir, backend veritabanından okur ve sonucu JSON olarak döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$React component'leri her render'da rastgele kendi verisini üretir$$, FALSE, 0),
    ($$Genellikle kendi verisini hiç saklamaz -- bir backend'e istek gönderir$$, TRUE, 1),
    ($$Her zaman tarayıcı içinde çalışan kendi kalıcı SQL veritabanını tutar$$, FALSE, 2),
    ($$Her şeyi kalıcı olarak URL'nin query string'inde saklar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$fetch çağrılarını ayrı bir api.js modülünde toplamanın temel amacı nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$fetch çağrılarını ayrı bir api.js modülünde toplamanın temel amacı nedir?$$,
           NULL, NULL,
           $$getCourses(), createCourse(), deleteCourse() gibi fonksiyonlar, fetch'in ayrıntılarını (URL, method, headers) GİZLER -- component'ler yalnızca bu fonksiyonları çağırır, fetch'in kendisiyle hiç uğraşmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$React tarafından zorunlu kılınır -- fetch bir component içinde hiç çağrılamaz$$, FALSE, 0),
    ($$useEffect'in yerini tamamen farklı bir mekanizmayla değiştirmek$$, FALSE, 1),
    ($$fetch'in ayrıntılarını (URL, method, headers) component'lerin doğrudan çağırdığı adlandırılmış fonksiyonların arkasına gizlemek$$, TRUE, 2),
    ($$fetch çağrılarının otomatik olarak iki kat daha hızlı çalışmasını sağlamak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$useEffect'in callback fonksiyonunun kendisi, burada gösterildiği gibi doğrudan async olarak tanımlanabilir mi?$$
      AND code_snippet = $$useEffect(async () => {
    const response = await fetch("/kurslar");
    const data = await response.json();
    kurslarAyarla(data);
}, []);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$useEffect'in callback fonksiyonunun kendisi, burada gösterildiği gibi doğrudan async olarak tanımlanabilir mi?$$,
           $$useEffect(async () => {
    const response = await fetch("/kurslar");
    const data = await response.json();
    kurslarAyarla(data);
}, []);$$, $$jsx$$,
           $$useEffect'in callback'i doğrudan async OLAMAZ -- React bunu desteklemez; bunun yerine içinde ayrı bir async fonksiyon tanımlanıp hemen çağrılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$Evet -- bu, tam olarak bu dersin önerdiği kalıptır$$, FALSE, 0),
    ($$Çalışır, ama yalnızca ilk render'da, sonrasında asla çalışmaz$$, FALSE, 1),
    ($$Çalışır, ama yalnızca dependency array'i tamamen kaldırılırsa$$, FALSE, 2),
    ($$Hayır -- React bunu desteklemez; içinde ayrı bir async fonksiyon tanımlanıp hemen çağrılmalıdır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kurs oluşturma örneğinde onCreated(newCourse) ne için kullanılır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kurs oluşturma örneğinde onCreated(newCourse) ne için kullanılır?$$,
           NULL, NULL,
           $$onCreated(newCourse), parent component'i bu yeni kayıt hakkında bilgilendirmek için kullanılan bir callback prop'udur -- Props'tan gelen "veriyi yukarı taşıma" kalıbı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$Parent component'i yeni oluşturulan kayıt hakkında bilgilendiren bir callback prop$$, TRUE, 0),
    ($$Tüm sayfayı otomatik olarak yenileyen yerleşik bir React hook'u$$, FALSE, 1),
    ($$Kursu oluşturulduktan hemen sonra silen bir fonksiyon$$, FALSE, 2),
    ($$Bir kurs eklendiğinde tetiklenen bir CSS animasyonu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$3 numaralı kurs için DELETE isteği başarılı olduktan sonra, bu kod ekranı güncellemek için ne yapar?$$
      AND code_snippet = $$async function handleDelete(id) {
    await fetch(`/kurslar/${id}`, { method: "DELETE" });
    kurslarAyarla(kurslar.filter((k) => k.id !== id));
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$3 numaralı kurs için DELETE isteği başarılı olduktan sonra, bu kod ekranı güncellemek için ne yapar?$$,
           $$async function handleDelete(id) {
    await fetch(`/kurslar/${id}`, { method: "DELETE" });
    kurslarAyarla(kurslar.filter((k) => k.id !== id));
}$$, $$jsx$$,
           $$State'ten gelen immutability kuralını izleyerek, filter() silinen kaydı çıkarır ve YENİ bir dizi oluşturur -- dizi asla (splice ile olduğu gibi) doğrudan mutate edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$Tüm listeyi sıfırdan yeniden getirmek için ikinci bir GET isteği gönderir$$, FALSE, 0),
    ($$filter() aracılığıyla, silinen kursu hariç tutan yepyeni bir dizi oluşturur ve bunu yeni state olarak ayarlar$$, TRUE, 1),
    ($$Mevcut kurslar dizisini splice() ile yerinde mutate eder, sonra yeniden render eder$$, FALSE, 2),
    ($$Hiçbir şey yapmaz -- ekran yalnızca bir sonraki sayfa yenilemesinde güncellenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yeni bir kayıt oluşturduktan sonra kurslarAyarla([...kurslar, yeniKurs])'u aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Yeni bir kayıt oluşturduktan sonra kurslarAyarla([...kurslar, yeniKurs])'u aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu, eski listeyi kopyalayıp yeni kaydı ekleyen spread kalıbını kullanır -- ekran, sunucuya ikinci bir istek göndermeden HEMEN güncellenir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$Ekran, tüm listeyi yeniden getirmek için ikinci bir istek göndermeden hemen güncellenir$$, TRUE, 0),
    ($$Ekranı güncellemenin tek geçerli yoludur -- yeniden getirmek asla kabul edilemez$$, FALSE, 1),
    ($$Mevcut kurslar dizisini üzerine push yaparak doğrudan mutate eder$$, FALSE, 2),
    ($$Eski listeyi kopyalayıp yeni kaydı ekleyen spread kalıbını kullanır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-rest-api')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste json-server'ın rolünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste json-server'ın rolünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu ders gerçek bir Spring Boot backend kurmaz -- bunun yerine aynı REST kurallarını (GET/POST/DELETE, JSON, HTTP durum kodları) izleyen sahte bir sunucu olan json-server'ı kullanır; gerçek bir backend'e bağlanırken React tarafındaki kod tamamen aynı olurdu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'react-rest-api'
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
    ($$Gerçek bir Spring Boot backend kurmak yerine kullanılan sahte bir sunucudur$$, TRUE, 0),
    ($$Gerçek bir backend'e bağlanırken React tarafındaki kod tamamen aynı olurdu$$, TRUE, 1),
    ($$json-server, gerçek bir REST backend'inden tamamen farklı, uyumsuz bir kurallar kümesi izler$$, FALSE, 2),
    ($$json-server, PostgreSQL'in yerini tamamen alan bir veritabanı motorudur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-rest-api'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

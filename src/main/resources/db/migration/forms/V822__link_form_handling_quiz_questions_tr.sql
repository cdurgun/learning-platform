-- Promotion-style migration linking TR form-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir formun input'u kontrollü olduğu için, form gönderildiği anda değeri nereden gelir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir formun input'u kontrollü olduğu için, form gönderildiği anda değeri nereden gelir?$$,
           NULL, NULL,
           $$Input kontrollü olduğu için, form gönderildiği anda state zaten günceldir -- değeri DOM'dan okumaya gerek yoktur, doğrudan state kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$Kontrollü bir formda, form değerleri submit anında hiçbir zaman erişilebilir değildir$$, FALSE, 0),
    ($$Doğrudan state'ten -- zaten günceldir, DOM'dan okumaya gerek yoktur$$, TRUE, 1),
    ($$Submit handler içinde taze bir document.querySelector(...) çağrısından$$, FALSE, 2),
    ($$Event nesnesinin event.formValue alanından$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir formda birden fazla input olduğunda, bu ders her alan için ayrı bir useState yerine neyi önerir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir formda birden fazla input olduğunda, bu ders her alan için ayrı bir useState yerine neyi önerir?$$,
           NULL, NULL,
           $$Hepsini TEK bir state nesnesinde tutmak daha yönetilebilirdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$Her tek alanın state'i için ayrı bir component kullanmayı$$, FALSE, 0),
    ($$State hiç kullanmadan, submit anında her alanın değerini DOM'dan taze okumayı$$, FALSE, 1),
    ($$Hepsini tek bir state nesnesinde tutmayı$$, TRUE, 2),
    ($$Her alanın değerini doğrudan window nesnesinde saklamayı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kullanıcı "eposta" adlı input'a yazıyor. handleChange gerçekte neyi günceller?$$
      AND code_snippet = $$const [formVerisi, formVerisiAyarla] = useState({ ad: "", eposta: "" });

function handleChange(event) {
    const { name, value } = event.target;
    formVerisiAyarla({ ...formVerisi, [name]: value });
}

// <input name="eposta" value={formVerisi.eposta} onChange={handleChange} />$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kullanıcı "eposta" adlı input'a yazıyor. handleChange gerçekte neyi günceller?$$,
           $$const [formVerisi, formVerisiAyarla] = useState({ ad: "", eposta: "" });

function handleChange(event) {
    const { name, value } = event.target;
    formVerisiAyarla({ ...formVerisi, [name]: value });
}

// <input name="eposta" value={formVerisi.eposta} onChange={handleChange} />$$, $$jsx$$,
           $$event.target.name, hangi input değiştiyse onun name attribute'unu verir ("eposta") -- [name]: value (bir computed property name) ile, bu tek handleChange yalnızca eposta alanını günceller, ad'a dokunmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$Yalnızca formVerisi.eposta güncellenir; formVerisi.ad dokunulmadan kalır$$, TRUE, 0),
    ($$Hem formVerisi.ad hem formVerisi.eposta boş string'lere sıfırlanır$$, FALSE, 1),
    ($$formVerisi'ne, yazılan metni tutan, gerçekten "name" adında yeni bir alan eklenir$$, FALSE, 2),
    ($$handleChange hangi input'un onu tetiklediğini bilmediği için hiçbir şey güncellenmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$handleChange neden formVerisi'ni doğrudan mutate etmek yerine { ...formVerisi, [name]: value } yazar?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$handleChange neden formVerisi'ni doğrudan mutate etmek yerine { ...formVerisi, [name]: value } yazar?$$,
           NULL, NULL,
           $$Bu, State'ten gelen immutability kuralını izler: { ...formVerisi, [name]: value }, eski nesneyi kopyalar ve yalnızca o alan değişmiş yeni bir nesne oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$State'ten gelen immutability kuralını izler -- eski nesneyi, yalnızca o alan değişmiş yeni bir nesneye kopyalar$$, TRUE, 0),
    ($$Doğrudan mutasyon bir JavaScript sözdizimi hatasıdır ve derlenmez$$, FALSE, 1),
    ($$Spread sözdizimi yalnızca formVerisi'nin tam olarak iki alanı olduğu için gereklidir$$, FALSE, 2),
    ($$Gerçek bir nedeni yoktur -- doğrudan mutasyon tam olarak aynı şekilde çalışırdı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin basit doğrulama örneği, bir alanın boş olup olmadığını nerede kontrol eder?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin basit doğrulama örneği, bir alanın boş olup olmadığını nerede kontrol eder?$$,
           NULL, NULL,
           $$Değer, submit anında, handleSubmit içinde kontrol edilir -- boşsa, error state'ine bir mesaj yazılır ve fonksiyon, formu gerçekten "göndermeden", erken çıkar (return).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$onSubmit hiç çalışmadan önce tarayıcı tarafından otomatik olarak kontrol edilir$$, FALSE, 0),
    ($$Submit anında, handleSubmit içinde -- boşsa, bir hata mesajı ayarlanır ve fonksiyon erken döner$$, TRUE, 1),
    ($$handleChange içinde, her tek tuş vuruşunda$$, FALSE, 2),
    ($$Component mount olduğunda bir kez çalışan ayrı bir useEffect içinde$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$hata boş bir string (""). {hata && <p>{hata}</p>} ne render eder?$$
      AND code_snippet = $$const [hata, hataAyarla] = useState("");
// ...
return <div>{hata && <p>{hata}</p>}</div>;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$hata boş bir string (""). {hata && <p>{hata}</p>} ne render eder?$$,
           $$const [hata, hataAyarla] = useState("");
// ...
return <div>{hata && <p>{hata}</p>}</div>;$$, $$jsx$$,
           $$hata boş değilse, ifade hata mesajını render eder; hata boşsa (burada olduğu gibi), boş bir string falsy'dir, bu yüzden hiçbir şey render edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$Literal "hata" metni render edilir$$, FALSE, 0),
    ($$hata bir boolean değil boş bir string olduğu için React bir hata fırlatır$$, FALSE, 1),
    ($$Hiçbir şey render edilmez -- boş bir string falsy'dir, bu yüzden &&'in sağ tarafı asla render edilmez$$, TRUE, 2),
    ($$Ekranda boş bir <p></p> tag'i render edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'form-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, birden fazla alanlı tüm bir formu doğrulamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, birden fazla alanlı tüm bir formu doğrulamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir validate() fonksiyonu, her alan için ayrı bir hata mesajı üretir, bunlar TEK bir yeniHatalar nesnesinde toplanır; bu nesnenin hiç key'i yoksa form geçerlidir; her input yalnızca kendi hatasını gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'form-handling'
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
    ($$Bir validate() fonksiyonu, her alan için ayrı bir hata mesajı üretir, tek bir yeniHatalar nesnesinde toplanır$$, TRUE, 0),
    ($$yeniHatalar'ın hiç key'i yoksa (Object.keys(yeniHatalar).length === 0), form geçerli sayılır$$, TRUE, 1),
    ($$Her input, yalnızca kendi hatasını değil, her alanın hatasını aynı anda gösterir$$, FALSE, 2),
    ($$Tüm form doğrulaması, tek bir alan için kullanılan && kalıbından tamamen farklı bir render tekniği gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'form-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

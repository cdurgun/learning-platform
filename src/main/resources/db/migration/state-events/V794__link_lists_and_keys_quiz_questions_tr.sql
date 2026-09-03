-- Promotion-style migration linking TR lists-and-keys quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir diziyi ekranda JSX elementlerine dönüştürmek için hangi JavaScript fonksiyonunu kullanırsın?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir diziyi ekranda JSX elementlerine dönüştürmek için hangi JavaScript fonksiyonunu kullanırsın?$$,
           NULL, NULL,
           $$map() -- dizideki her elemanı başka bir şeye dönüştürür ve yeni bir dizi döndürür, burada her öğeyi React'in render edebileceği bir JSX elementine çevirir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$forEach()$$, FALSE, 0),
    ($$map()$$, TRUE, 1),
    ($$filter()$$, FALSE, 2),
    ($$reduce()$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$map() ile bir liste render ederken her elemana ne vermen gerekir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$map() ile bir liste render ederken her elemana ne vermen gerekir?$$,
           NULL, NULL,
           $$Bir key prop'u -- map() ile bir liste render ederken, her elemana bir key prop'u vermen gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$Her tek öğe için benzersiz bir CSS class adı$$, FALSE, 0),
    ($$Ekstra hiçbir şey -- map() kimliği hiçbir prop'a gerek kalmadan otomatik olarak halleder$$, FALSE, 1),
    ($$Bir key prop'u$$, TRUE, 2),
    ($$Hiçbir şey tıklanabilir olmasa bile, ayrı bir onClick handler'ı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$key ne olmalıdır ve bunun için tercih edilen kaynak nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$key ne olmalıdır ve bunun için tercih edilen kaynak nedir?$$,
           NULL, NULL,
           $$key, o öğeyi liste içinde benzersiz şekilde tanımlayan bir string ya da sayıdır; mümkün olduğunda, öğenin adı ya da index'i değil, veritabanından gelen bir id gibi stabil bir tanımlayıcı kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$Rastgele herhangi bir değer -- key bir string olduğu sürece benzersiz olması gerekmez$$, FALSE, 0),
    ($$Öğenin görüntülenen metni, key için her zaman doğru ve tek geçerli seçimdir$$, FALSE, 1),
    ($$Öğenin şu anda görünür olup olmadığını belirten bir boolean$$, FALSE, 2),
    ($$Öğeyi benzersiz şekilde tanımlayan bir string ya da sayı, tercihen stabil bir id, öğenin adı ya da index'i değil$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$key aslında React'e ne söyler?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$key aslında React'e ne söyler?$$,
           NULL, NULL,
           $$key, bir sonraki render'daki hangi liste öğesinin, önceki render'daki hangi öğeyle AYNI olduğunu React'e söyler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$Bir sonraki render'daki hangi liste öğesinin, önceki render'daki hangi öğeyle aynı olduğunu$$, TRUE, 0),
    ($$Listenin ekranda görsel olarak nasıl sıralanacağını$$, FALSE, 1),
    ($$O belirli öğeye hangi CSS stillerinin uygulanacağını$$, FALSE, 2),
    ($$Öğenin diziye dahil edilip edilmeyeceğini$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir görev listesi, key olarak dizi index'ini kullanıyor. Listeden ilk öğe kaldırılıyor. Bu hangi soruna yol açabilir?$$
      AND code_snippet = $${gorevler.map((gorev, index) => (
    <GorevOgesi key={index} gorev={gorev} />
))}
// gorevler dizisinden ilk gorev kaldiriliyor$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir görev listesi, key olarak dizi index'ini kullanıyor. Listeden ilk öğe kaldırılıyor. Bu hangi soruna yol açabilir?$$,
           $${gorevler.map((gorev, index) => (
    <GorevOgesi key={index} gorev={gorev} />
))}
// gorevler dizisinden ilk gorev kaldiriliyor$$, $$jsx$$,
           $$Bir öğe kaldırıldığında, kalan her öğenin index'i kayar -- React, yalnızca index'e bakarak artık aynı öğe mi yoksa farklı bir öğe mi olduğunu ayırt edemez, bu da yanlış öğenin güncellenmesine yol açabilir (örneğin yanlış checkbox'lar).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$index key'leri geçersiz bir sözdizimi olduğu için React bir derleme zamanı hatası fırlatır$$, FALSE, 0),
    ($$Kalan her öğenin index'i kayar, ve React yanlış öğeyi (örneğin yanlış checkbox'ı) güncelleyebilir$$, TRUE, 1),
    ($$Hiçbir sorun yoktur -- index tabanlı key'ler her zaman stabil id tabanlı key'lerle birebir aynı davranır$$, FALSE, 2),
    ($$Liste tamamen render edilmeyi bırakır, boş bir ekran gösterir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, dizi index'ini key olarak kullanmak hiç kabul edilebilir bir seçim midir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, dizi index'ini key olarak kullanmak hiç kabul edilebilir bir seçim midir?$$,
           NULL, NULL,
           $$Gerçekten stabil bir tanımlayıcın yoksa ve liste asla yeniden sıralanmıyor ya da değiştirilmiyorsa, index bir son çare olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$Evet, ve aslında stabil bir id'ye karşı resmi olarak tercih edilen seçimdir$$, FALSE, 0),
    ($$Yalnızca tam olarak bir öğe içeren listeler için$$, FALSE, 1),
    ($$Bir son çare olarak, eğer gerçekten stabil bir tanımlayıcı yoksa ve liste asla yeniden sıralanmıyor ya da değiştirilmiyorsa$$, TRUE, 2),
    ($$Asla -- her koşulda kesinlikle yasaktır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists-and-keys')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, key ve React'in reconciliation süreciyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, key ve React'in reconciliation süreciyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$key, React'in tüm listeyi yeniden inşa etmek yerine yalnızca gerçekten değişen kısmı güncellemesini sağlar; liste hiç değişmediği sürece key önemli görünmez; sorunlar özellikle öğeler eklendiğinde, kaldırıldığında ya da sıra değiştiğinde ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists-and-keys'
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
    ($$key, React'in tüm listeyi yeniden inşa etmek yerine yalnızca gerçekten değişen kısmı güncellemesini sağlar$$, TRUE, 0),
    ($$Liste hiç değişmediği sürece, key önemli görünmez$$, TRUE, 1),
    ($$key ile ilgili sorunlar özellikle öğeler eklendiğinde, kaldırıldığında ya da sıra değiştiğinde ortaya çıkar$$, TRUE, 2),
    ($$key yalnızca bir for döngüsüyle render edilen listeler için geçerlidir, map() ile asla geçerli değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists-and-keys'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

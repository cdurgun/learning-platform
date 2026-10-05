-- Links the TR while-do-while questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki işlerden hangisi `for` yerine `while` ile daha doğal ifade edilir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki işlerden hangisi `for` yerine `while` ile daha doğal ifade edilir?$$,
           NULL, NULL,
           $$Bir bağlantı başarılı olana kadar yeniden denemek bir sayaca değil bir duruma bağlıdır: kaç adım süreceği bilinmez, yalnızca ne zaman duracağı bilinir. `while` tam olarak bu "yalnızca bir koşulum var" durumu içindir. Diğer üç iş adım sayısı belli olan, sayaçla yürüyen tekrarlar olduğu için `for`'a uygundur.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Bir işlemi tam 10 kez tekrarlamak$$, FALSE, 0),
        ($$Bir dizinin elemanlarını indeksleriyle sırayla gezmek$$, FALSE, 1),
        ($$Bir bağlantı başarılı olana kadar yeniden denemek$$, TRUE, 2),
        ($$1'den 100'e kadar olan sayıları toplamak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int sayac = 3;

while (sayac > 0) {
    System.out.println(sayac);
    sayac--;
}

System.out.println("Kalkış");$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int sayac = 3;

while (sayac > 0) {
    System.out.println(sayac);
    sayac--;
}

System.out.println("Kalkış");$$, $$java$$,
           $$Koşul her adımdan önce kontrol edilir. `sayac` 3, 2 ve 1 iken koşul doğrudur ve değer yazdırılır; 0 olduğunda `sayac > 0` yanlış olur ve gövde bir daha çalışmaz. Bu yüzden 0 yazdırılmaz; döngüden sonra yalnızca `Kalkış` yazdırılır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$`3`, `2`, `1`, `0`, sonra `Kalkış`$$, FALSE, 0),
        ($$`2`, `1`, `0`, sonra `Kalkış`$$, FALSE, 1),
        ($$Yalnızca `Kalkış`$$, FALSE, 2),
        ($$`3`, `2`, `1`, sonra `Kalkış`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`do-while` döngüsünde koşul en baştan `false` ise ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`do-while` döngüsünde koşul en baştan `false` ise ne olur?$$,
           NULL, NULL,
           $$`do-while` koşulu gövdeden sonra kontrol eder; bu yüzden koşul baştan `false` olsa bile gövde bir kez çalışır, ardından koşul kontrol edilir ve döngü biter. Gövdenin hiç çalışmaması, koşulu gövdeden önce kontrol eden `while`'ın davranışıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Gövde bir kez çalışır, sonra döngü biter$$, TRUE, 0),
        ($$Gövde hiç çalışmaz$$, FALSE, 1),
        ($$Gövde, bir `break` ile durdurulana kadar çalışır$$, FALSE, 2),
        ($$Kod derlenmez, çünkü koşul hiçbir zaman `true` olamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int kalan = 0;

do {
    System.out.println("Deneme");
    kalan--;
} while (kalan > 0);

System.out.println("Bitti");$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int kalan = 0;

do {
    System.out.println("Deneme");
    kalan--;
} while (kalan > 0);

System.out.println("Bitti");$$, $$java$$,
           $$`kalan > 0` baştan yanlıştır, ama `do-while` koşulu gövdeden sonra kontrol ettiği için `Deneme` bir kez yazdırılır. Ardından koşul yanlış çıkar, döngü biter ve `Bitti` yazdırılır. Aynı döngü `while` ile yazılsaydı gövde hiç çalışmaz, yalnızca `Bitti` yazdırılırdı.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Yalnızca `Bitti`$$, FALSE, 0),
        ($$`Deneme`, sonra `Bitti`$$, TRUE, 1),
        ($$`Deneme`, `Deneme`, sonra `Bitti`$$, FALSE, 2),
        ($$`Deneme` durmadan yazdırılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bir derleme hatasına ya da istenmeyen bir sonsuz döngüye yol açar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir derleme hatasına ya da istenmeyen bir sonsuz döngüye yol açar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$`do-while`'ın kapanış satırı `} while (kosul);` biçimindedir; sondaki `;` yazılmazsa kod derlenmez. Koşulun bağlı olduğu değişken gövdede hiç güncellenmezse koşul değişmez ve döngü bitmez. Koşulu baştan `false` olan bir `while` ise yalnızca gövdesini hiç çalıştırmaz; `break` ile erken çıkmak da geçerli bir kullanımdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Koşulu en baştan `false` olan bir `while` yazmak$$, FALSE, 0),
        ($$Bir `while` döngüsünü `break` ile erken bitirmek$$, FALSE, 1),
        ($$`do-while`'ın sonundaki `while (kosul)` ifadesinden sonra `;` yazmamak$$, TRUE, 2),
        ($$Koşulun bağlı olduğu değişkeni gövdede hiç güncellememek$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

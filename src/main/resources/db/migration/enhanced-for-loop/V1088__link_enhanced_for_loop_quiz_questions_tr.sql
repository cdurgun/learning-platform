-- Links the TR enhanced-for-loop questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Enhanced for döngüsü, klasik `for`'un sağladığı hangi bilgiyi vermez?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Enhanced for döngüsü, klasik `for`'un sağladığı hangi bilgiyi vermez?$$,
           NULL, NULL,
           $$Enhanced for her elemanın değerini sırayla verir, ama o elemanın kaçıncı sırada olduğunu vermez. Konum gerekiyorsa ya elle bir sayaç tutulur ya da indeksi her adımda elinde bulunduran klasik `for` kullanılır. Değerlerin tamamını gezmek ise enhanced for'un zaten yaptığı iştir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$Elemanın değerini$$, FALSE, 0),
        ($$Dizinin son elemanına kadar gidilmesini$$, FALSE, 1),
        ($$Elemanın konumunu (indeksini)$$, TRUE, 2),
        ($$`List` gibi koleksiyonlar üzerinde çalışabilmeyi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int[] puanlar = {50, 60};

for (int puan : puanlar) {
    puan = 100;
}

for (int puan : puanlar) {
    System.out.println(puan);
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int[] puanlar = {50, 60};

for (int puan : puanlar) {
    puan = 100;
}

for (int puan : puanlar) {
    System.out.println(puan);
}$$, $$java$$,
           $$Döngü değişkeni `puan`, her elemanın yalnızca bir kopyasıdır. Ona 100 atamak diziyi etkilemez; bu yüzden ikinci döngü dizideki özgün değerleri, 50 ve 60'ı yazdırır. Döngü değişkenine atama yapmak geçerli bir Java kodudur, yalnızca beklenen etkiyi yaratmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$`100`, sonra `100`$$, FALSE, 0),
        ($$`100`, sonra `60`$$, FALSE, 1),
        ($$Kod derlenmez, çünkü döngü değişkenine atama yapılamaz$$, FALSE, 2),
        ($$`50`, sonra `60`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `List` üzerinde gezinirken eleman silmenin güvenli yolu hangisidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir `List` üzerinde gezinirken eleman silmenin güvenli yolu hangisidir?$$,
           NULL, NULL,
           $$Güvenli silme `Iterator.remove()` ile yapılır. Enhanced for içinde doğrudan `list.remove(...)` çağırmak listenin yapısını döngü sürerken değiştirir ve genellikle `ConcurrentModificationException` fırlatır. Döngü değişkeni yalnızca bir kopya olduğu için ona `null` atamak da listeden hiçbir şey silmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$`Iterator.remove()` kullanmak$$, TRUE, 0),
        ($$Enhanced for içinde doğrudan `list.remove(...)` çağırmak$$, FALSE, 1),
        ($$Enhanced for içinde döngü değişkenine `null` atamak$$, FALSE, 2),
        ($$Enhanced for içindeki silme satırını `try`/`catch` ile sarmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki işlerden hangisinde enhanced for tercih edilmelidir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki işlerden hangisinde enhanced for tercih edilmelidir?$$,
           NULL, NULL,
           $$İsimleri sırayla yazdırmak yalnızca değerleri okur; konum gerekmediği için enhanced for daha kısa ve hataya daha kapalıdır. Yerinde değişiklik, sıra numarası ve iki dizinin aynı konumdaki elemanlarını birlikte gezmek ise indeks gerektirir ve klasik `for` ister.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$Bir dizinin her elemanını yerinde iki katına çıkarmak$$, FALSE, 0),
        ($$Bir listedeki tüm isimleri sırayla yazdırmak$$, TRUE, 1),
        ($$Her elemanı sıra numarasıyla birlikte yazdırmak$$, FALSE, 2),
        ($$İki dizinin aynı konumdaki elemanlarını birlikte işlemek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$String[] sehirler = {"Ankara", "Bursa"};
int[] plakalar = {6, 16};

for (int i = 0; i < sehirler.length; i++) {
    System.out.println(sehirler[i] + ": " + plakalar[i]);
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$String[] sehirler = {"Ankara", "Bursa"};
int[] plakalar = {6, 16};

for (int i = 0; i < sehirler.length; i++) {
    System.out.println(sehirler[i] + ": " + plakalar[i]);
}$$, $$java$$,
           $$Klasik `for`, tek bir ortak indeksle iki diziyi aynı konumdan okur; bu yüzden her şehir yalnızca kendi plakasıyla eşleşir. Her şehrin her plakayla eşleştiği dört satırlık çıktı, iki enhanced for'u iç içe yazmanın sonucu olurdu: paralel gezme değil, kartezyen çarpım.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$`Ankara: 6`, `Ankara: 16`, `Bursa: 6`, sonra `Bursa: 16`$$, FALSE, 0),
        ($$`Ankara: 16`, sonra `Bursa: 6`$$, FALSE, 1),
        ($$`Ankara: 6`, sonra `Bursa: 16`$$, TRUE, 2),
        ($$Yalnızca `Ankara: 6`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

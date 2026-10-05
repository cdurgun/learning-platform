-- Links the TR nested-loops questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$for (int satir = 1; satir <= 2; satir++) {
    for (int sutun = 1; sutun <= 3; sutun++) {
        System.out.print(satir * sutun + " ");
    }
    System.out.println();
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$for (int satir = 1; satir <= 2; satir++) {
    for (int sutun = 1; sutun <= 3; sutun++) {
        System.out.print(satir * sutun + " ");
    }
    System.out.println();
}$$, $$java$$,
           $$Dış döngünün her adımında iç döngü baştan sona çalışır: `satir` 1 iken `sutun` 1, 2, 3 değerlerini alır ve `1 2 3` yazdırılır; satır sonu basıldıktan sonra `satir` 2 olur ve iç döngü yeniden baştan başlayarak `2 4 6` yazdırır. İç döngü her dış adımda sıfırlandığı için çıktı iki satır, üçer sayıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$İlk satırda `1 2`, ikinci satırda `2 4`, üçüncü satırda `3 6`$$, FALSE, 0),
        ($$Tek satırda `1 2 3 2 4 6`$$, FALSE, 1),
        ($$İlk satırda `1 2 3`, ikinci satırda `2 4 6`$$, TRUE, 2),
        ($$İlk satırda `1 2 3`, ikinci satırda `4 5 6`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int[][] tablo = {{1, 2, 3}, {4, 5}};

System.out.println(tablo.length);
System.out.println(tablo[1].length);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int[][] tablo = {{1, 2, 3}, {4, 5}};

System.out.println(tablo.length);
System.out.println(tablo[1].length);$$, $$java$$,
           $$`tablo.length` satır sayısını verir: 2. `tablo[1].length` ise ikinci satırın kendi uzunluğudur ve o satırda iki eleman vardır. Satırlar farklı uzunlukta olabildiği için iç döngünün sınırı sabit bir sayı ya da ilk satırın uzunluğu değil, her satırın kendi `length` değeri olmalıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$`2`, sonra `3`$$, FALSE, 0),
        ($$`5`, sonra `2`$$, FALSE, 1),
        ($$`3`, sonra `2`$$, FALSE, 2),
        ($$`2`, sonra `2`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == 2) {
            continue;
        }
        System.out.println(i + "" + j);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$for (int i = 1; i <= 2; i++) {
    for (int j = 1; j <= 3; j++) {
        if (j == 2) {
            continue;
        }
        System.out.println(i + "" + j);
    }
}$$, $$java$$,
           $$Etiketsiz `continue` yalnızca yazıldığı iç döngünün o adımını atlar. `j` 2 olduğunda yazdırma atlanır, ama iç döngü 3 ile sürer; dış döngü de hiçbir adımını atlamadan iki kez çalışır. `j` 2'ye gelince iç döngünün tamamen bitmesi `break`'in davranışı olurdu.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$`11`, `13`, `21`, sonra `23`$$, TRUE, 0),
        ($$`11`, sonra `21`$$, FALSE, 1),
        ($$`11`, sonra `13`$$, FALSE, 2),
        ($$`11`, `12`, `13`, `21`, `22`, sonra `23`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İç döngüde yazılmış `continue satirDongusu;` ifadesi ne yapar? (`satirDongusu` dış döngünün etiketidir.)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$İç döngüde yazılmış `continue satirDongusu;` ifadesi ne yapar? (`satirDongusu` dış döngünün etiketidir.)$$,
           NULL, NULL,
           $$Etiketli `continue`, iç döngünün kalanını bırakıp doğrudan dış döngünün bir sonraki adımına atlar. Döngüleri sonlandırmaz; ikisini birden bitiren etiketli `break`'tir. Etiketsiz `continue` ise yalnızca iç döngünün o adımını atlar ve iç döngü kaldığı yerden sürer.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$Hem iç hem dış döngüyü tamamen sonlandırır$$, FALSE, 0),
        ($$İç döngünün kalanını bırakıp dış döngünün bir sonraki adımına geçer$$, TRUE, 1),
        ($$Yalnızca iç döngünün o adımını atlar; iç döngü sürer$$, FALSE, 2),
        ($$Dış döngüyü ilk adımından yeniden başlatır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`n` elemanlı bir veri üzerinde aynı boyutta iki iç içe döngü çalışıyor. `n` iki katına çıkarsa gövdenin çalışma sayısı nasıl değişir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`n` elemanlı bir veri üzerinde aynı boyutta iki iç içe döngü çalışıyor. `n` iki katına çıkarsa gövdenin çalışma sayısı nasıl değişir?$$,
           NULL, NULL,
           $$Gövde `n × n` kez çalışır. `n` iki katına çıkınca bu sayı (2n) × (2n), yani dört katı olur. İki katına çıkmak tek bir döngünün davranışıdır; iç içe döngülerde artış doğrusal değil kareseldir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$İki katına çıkar$$, FALSE, 0),
        ($$Üç katına çıkar$$, FALSE, 1),
        ($$Dört katına çıkar$$, TRUE, 2),
        ($$Sekiz katına çıkar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

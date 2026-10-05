-- Links the TR for-loop questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`for (int i = 0; i < 3; i++)` döngüsünde `int i = 0` kısmı kaç kez çalışır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`for (int i = 0; i < 3; i++)` döngüsünde `int i = 0` kısmı kaç kez çalışır?$$,
           NULL, NULL,
           $$Başlangıç kısmı döngü başlamadan önce yalnızca bir kez çalışır. Her adımda tekrarlananlar koşul kontrolü (`i < 3`) ve adımın sonundaki güncellemedir (`i++`); başlangıç her adımda yeniden çalışsaydı sayaç hiç ilerleyemezdi.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$Her adımın başında bir kez$$, FALSE, 0),
        ($$Her adımın sonunda bir kez$$, FALSE, 1),
        ($$Yalnızca bir kez, döngü başlamadan önce$$, TRUE, 2),
        ($$Koşul her kontrol edildiğinde$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 TR, quiz position 2, MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`for` döngüsünün kısımları hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`for` döngüsünün kısımları hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$`for`'un üç kısmı da esnektir: sayaç `i--` ile geriye doğru sayabilir, adım büyüklüğü de `i += 2` gibi farklı bir değer olabilir. Sayacın `0`'dan başlaması yalnızca en yaygın biçimdir, zorunluluk değildir; koşulda da `<` dışında `<=` gibi başka karşılaştırmalar kullanılabilir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$Sayaç her zaman `0`'dan başlamak zorundadır$$, FALSE, 0),
        ($$Sayaç `i--` ile geriye doğru sayabilir$$, TRUE, 1),
        ($$Koşulda yalnızca `<` operatörü kullanılabilir$$, FALSE, 2),
        ($$Adım büyüklüğü 1 olmak zorunda değildir; `i += 2` yazılabilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 TR, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int[] sayilar = {4, 9, 7, 2};

for (int i = 0; i < sayilar.length; i++) {
    if (sayilar[i] == 7) {
        System.out.println("Bulundu: " + i);
        break;
    }
    System.out.println("Kontrol: " + sayilar[i]);
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int[] sayilar = {4, 9, 7, 2};

for (int i = 0; i < sayilar.length; i++) {
    if (sayilar[i] == 7) {
        System.out.println("Bulundu: " + i);
        break;
    }
    System.out.println("Kontrol: " + sayilar[i]);
}$$, $$java$$,
           $$Döngü 4 ve 9 için `Kontrol` satırını yazdırır. 7'ye gelindiğinde indeksi olan 2 yazdırılır ve `break` döngüyü tamamen sonlandırır; bu yüzden ne 7 için `Kontrol` satırı ne de kalan eleman olan 2 işlenir. Aranan bulunduktan sonra kalan elemanlara bakmamak, `break`'in aramalardaki tipik kullanımıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`Kontrol: 4`, `Kontrol: 9`, sonra `Bulundu: 2`$$, TRUE, 0),
        ($$`Kontrol: 4`, `Kontrol: 9`, `Bulundu: 2`, sonra `Kontrol: 2`$$, FALSE, 1),
        ($$`Kontrol: 4`, `Kontrol: 9`, `Kontrol: 7`, sonra `Bulundu: 2`$$, FALSE, 2),
        ($$Yalnızca `Bulundu: 2`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 TR, quiz position 4, CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int toplam = 0;

for (int i = 1; i <= 4; i++) {
    if (i == 2) {
        continue;
    }
    toplam += i;
}

System.out.println(toplam);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int toplam = 0;

for (int i = 1; i <= 4; i++) {
    if (i == 2) {
        continue;
    }
    toplam += i;
}

System.out.println(toplam);$$, $$java$$,
           $$`i` 2 olduğunda `continue` o adımın kalanını atlar, yani 2 toplama eklenmez; döngü ise sürer ve 3 ile 4 eklenir: 1 + 3 + 4 = 8. Sonucun 10 olması hiçbir adımın atlanmadığı, 1 olması ise döngünün `break` ile tamamen bittiği anlamına gelirdi.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`10`$$, FALSE, 0),
        ($$`8`$$, TRUE, 1),
        ($$`1`$$, FALSE, 2),
        ($$`3`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İstenmeden oluşan bir sonsuz `for` döngüsünün en yaygın sebebi hangisidir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$İstenmeden oluşan bir sonsuz `for` döngüsünün en yaygın sebebi hangisidir?$$,
           NULL, NULL,
           $$Güncelleme adımı koşulu hiçbir zaman `false` yapmıyorsa, örneğin `i++` yazılmamışsa, döngü kendiliğinden bitemez ve program takılır. Sayacı `for`'un kendi başlangıç kısmında tanımlamak ise tam tersine önerilen bir pratiktir; yalnızca sayacın kapsamını daraltır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$Sayaç değişkenini `for`'un kendi başlangıç kısmında tanımlamak$$, FALSE, 0),
        ($$Koşulda `<=` yerine `<` kullanmak$$, FALSE, 1),
        ($$Güncelleme adımının koşulu hiçbir zaman `false` yapmaması, örneğin `i++` yazmayı unutmak$$, TRUE, 2),
        ($$Döngüyü `break` ile erken bitirmek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 TR, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`i` sayacı `0`'dan başlıyorsa, bir dizinin tüm elemanlarını tam olarak bir kez gezen koşul hangisidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`i` sayacı `0`'dan başlıyorsa, bir dizinin tüm elemanlarını tam olarak bir kez gezen koşul hangisidir?$$,
           NULL, NULL,
           $$Geçerli indeksler `0` ile `length - 1` arasındadır, bu yüzden doğru koşul `i < dizi.length`'tir. `i <= dizi.length` bir adım fazla çalışır ve var olmayan bir indekse erişerek `ArrayIndexOutOfBoundsException` fırlatır; `i < dizi.length - 1` ise son elemanı atlar.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`i <= dizi.length`$$, FALSE, 0),
        ($$`i < dizi.length - 1`$$, FALSE, 1),
        ($$`i <= dizi.length + 1`$$, FALSE, 2),
        ($$`i < dizi.length`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

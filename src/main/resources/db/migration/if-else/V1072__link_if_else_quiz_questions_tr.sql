-- Links the TR if-else questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`int sayi = 5;` tanımlandıktan sonra aşağıdaki `if` satırlarından hangisi Java'da derlenir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`int sayi = 5;` tanımlandıktan sonra aşağıdaki `if` satırlarından hangisi Java'da derlenir?$$,
           NULL, NULL,
           $$`sayi > 0` bir `boolean` üretir, bu yüzden koşul olarak geçerlidir. Java sayısal bir değeri `boolean`'a kendiliğinden çevirmez: `if (sayi)` ve `if (1)` derlenmez. `if (sayi = 0)` de derlenmez, çünkü bu bir karşılaştırma değil atamadır ve sonucu `int`'tir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`if (sayi)`$$, FALSE, 0),
        ($$`if (sayi = 0)`$$, FALSE, 1),
        ($$`if (sayi > 0)`$$, TRUE, 2),
        ($$`if (1)`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int sicaklik = 35;

if (sicaklik > 20) {
    System.out.println("Ilık");
} else if (sicaklik > 30) {
    System.out.println("Sıcak");
} else {
    System.out.println("Soğuk");
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int sicaklik = 35;

if (sicaklik > 20) {
    System.out.println("Ilık");
} else if (sicaklik > 30) {
    System.out.println("Sıcak");
} else {
    System.out.println("Soğuk");
}$$, $$java$$,
           $$Koşullar yukarıdan aşağıya kontrol edilir ve `true` olan ilk koşulun bloğu çalışır. `35 > 20` zaten `true` olduğu için `Ilık` yazdırılır ve zincirin kalanı atlanır. `35 > 30` da doğrudur ama o koşula hiç gelinmez; bir zincirde en fazla bir blok çalıştığı için iki satır birden de yazdırılmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`Sıcak`$$, FALSE, 0),
        ($$Önce `Ilık`, sonra `Sıcak`$$, FALSE, 1),
        ($$`Soğuk`$$, FALSE, 2),
        ($$`Ilık`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 TR, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$boolean uye = false;

if (uye)
    System.out.println("Hoş geldin");
    System.out.println("İndirim uygulandı");

System.out.println("Bitti");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$boolean uye = false;

if (uye)
    System.out.println("Hoş geldin");
    System.out.println("İndirim uygulandı");

System.out.println("Bitti");$$, $$java$$,
           $$Süslü parantez olmadığında `if` yalnızca hemen ardından gelen tek ifadeyi kapsar. Koşul `false` olduğu için `Hoş geldin` atlanır; ikinci `println` ise girintisine rağmen `if`'in dışındadır ve her zaman çalışır. Bu yüzden yalnızca `Bitti` yazdırılmaz, `İndirim uygulandı` da yazdırılır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$Önce `İndirim uygulandı`, sonra `Bitti`$$, TRUE, 0),
        ($$Yalnızca `Bitti`$$, FALSE, 1),
        ($$`Hoş geldin`, `İndirim uygulandı` ve `Bitti`$$, FALSE, 2),
        ($$Hiçbir şey yazdırmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 TR, quiz position 4, MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kontrollerden hangileri `==` ile yapıldığında beklenmedik sonuç verebilir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki kontrollerden hangileri `==` ile yapıldığında beklenmedik sonuç verebilir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ondalıklı sayılar ikili kayan nokta ile tam olarak saklanamadığı için `double` değerleri `==` ile karşılaştırmak risklidir; bunun yerine farkın küçük bir eşikten az olup olmadığına bakılır. `String` gibi nesnelerde `==` içeriği değil referansı karşılaştırır, içerik için `.equals()` gerekir. `int` gibi ilkel tiplerde ise `==` doğrudan değeri karşılaştırır ve güvenlidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$İki `double` değerin eşit olup olmadığını kontrol etmek$$, TRUE, 0),
        ($$İki `String`'in içeriğinin aynı olup olmadığını kontrol etmek$$, TRUE, 1),
        ($$İki `int` değerin eşit olup olmadığını kontrol etmek$$, FALSE, 2),
        ($$Bir `int` değerin sıfıra eşit olup olmadığını kontrol etmek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`girisYapti() || misafirModuAcik()` ifadesinde `girisYapti()` `true` döndürürse ne olur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`girisYapti() || misafirModuAcik()` ifadesinde `girisYapti()` `true` döndürürse ne olur?$$,
           NULL, NULL,
           $$`||` kısa devre değerlendirilir: sol taraf `true` ise sonuç zaten bellidir ve sağ taraf hiç çalıştırılmaz. Bu yüzden `misafirModuAcik()` çağrılmaz. Sağ tarafın çağrılıp sonucunun yok sayılması gibi bir durum yoktur; metot hiç çalışmadığı için varsa yan etkisi de gerçekleşmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`misafirModuAcik()` çağrılır ama döndürdüğü değer yok sayılır$$, FALSE, 0),
        ($$Her iki metot da çağrılır ve sonuçları birleştirilir$$, FALSE, 1),
        ($$`misafirModuAcik()` hiç çağrılmaz, çünkü sonuç zaten `true` olarak bellidir$$, TRUE, 2),
        ($$Önce `misafirModuAcik()`, ardından `girisYapti()` çağrılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 TR, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Üçlü (ternary) operatör hangi durumda bir `if`/`else` yerine uygun bir tercihtir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Üçlü (ternary) operatör hangi durumda bir `if`/`else` yerine uygun bir tercihtir?$$,
           NULL, NULL,
           $$Üçlü operatör doğrudan bir değere değerlendirilen bir ifadedir; basit bir koşula göre tek bir değer seçmek, örneğin bir atama yapmak için uygundur. İkiden fazla sonuç gerektiğinde iç içe yazmak teknik olarak çalışır ama okunabilirliği hızla bozar; o durumda `else if` zinciri tercih edilir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$İkiden fazla sonuç arasında seçim yapılacağında, iç içe yazılarak$$, FALSE, 0),
        ($$Her dalda birden fazla satır kod çalıştırılacağında$$, FALSE, 1),
        ($$Koşul `boolean` değil de sayısal bir değer olduğunda$$, FALSE, 2),
        ($$Basit bir koşula göre tek bir değer üretmek gerektiğinde, örneğin bir atamada$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

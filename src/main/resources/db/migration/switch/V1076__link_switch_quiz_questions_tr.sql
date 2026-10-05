-- Links the TR switch questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 TR, quiz position 1, MULTIPLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Klasik `switch` sözdiziminde `default` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Klasik `switch` sözdiziminde `default` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$`default`, hiçbir `case` eşleşmediğinde çalışan daldır. Yazılması zorunlu değildir; `default` olmayan bir `switch` de derlenir, ama beklenmeyen değerlerin sessizce atlanmaması için eklenmesi iyi bir pratiktir. Yerinin de bir kısıtı yoktur, ilk dal olmak zorunda değildir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$Hiçbir `case` eşleşmediğinde çalışır$$, TRUE, 0),
        ($$Yazılmazsa kod derlenmez$$, FALSE, 1),
        ($$Yalnızca `switch`'in ilk dalı olarak yazılabilir$$, FALSE, 2),
        ($$Yazılması zorunlu değildir, ama eklenmesi iyi bir pratiktir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int gun = 6;

switch (gun) {
    case 6:
        System.out.println("Cumartesi");
    case 7:
        System.out.println("Pazar");
    default:
        System.out.println("Hafta içi");
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int gun = 6;

switch (gun) {
    case 6:
        System.out.println("Cumartesi");
    case 7:
        System.out.println("Pazar");
    default:
        System.out.println("Hafta içi");
}$$, $$java$$,
           $$Eşleşen `case 6` çalışır ve `Cumartesi` yazdırılır. Hiçbir dalda `break` olmadığı için çalışma, eşleşip eşleşmediğine bakılmadan sonraki dallara düşer: önce `case 7`, sonra `default`. `switch` yalnızca bir `break`'e ya da kendi sonuna gelindiğinde biter; bu yüzden çıktı `Cumartesi` ile sınırlı kalmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$Yalnızca `Cumartesi`$$, FALSE, 0),
        ($$`Cumartesi`, `Pazar` ve `Hafta içi`$$, TRUE, 1),
        ($$`Cumartesi` ve `Pazar`$$, FALSE, 2),
        ($$Yalnızca `Hafta içi`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 TR, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$int puan = 1;

switch (puan) {
    case 1 -> System.out.println("Zayıf");
    case 2 -> System.out.println("Orta");
    case 3 -> System.out.println("İyi");
}

System.out.println("Bitti");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$int puan = 1;

switch (puan) {
    case 1 -> System.out.println("Zayıf");
    case 2 -> System.out.println("Orta");
    case 3 -> System.out.println("İyi");
}

System.out.println("Bitti");$$, $$java$$,
           $$Ok sözdiziminde her dal bağımsız çalışır; fall-through yoktur ve `break` yazmak gerekmez. Bu yüzden yalnızca eşleşen dal `Zayıf` yazdırır, ardından `switch`'ten sonraki satır `Bitti` yazdırır. `Orta` ve `İyi`'nin de yazdırılması, `break` unutulmuş klasik sözdiziminin davranışı olurdu.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`Zayıf`, `Orta`, `İyi`, sonra `Bitti`$$, FALSE, 0),
        ($$Yalnızca `Zayıf`$$, FALSE, 1),
        ($$`Zayıf`, sonra `Bitti`$$, TRUE, 2),
        ($$Kod derlenmez, çünkü dallarda `break` yok$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `switch` ifadesinde bir dal süslü parantezli bir blok olarak yazıldığında, bloğun ürettiği değer nasıl belirtilir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir `switch` ifadesinde bir dal süslü parantezli bir blok olarak yazıldığında, bloğun ürettiği değer nasıl belirtilir?$$,
           NULL, NULL,
           $$Blok gövdeli bir dalda üretilen değer `yield` anahtar kelimesiyle belirtilir; `yield` yazılmazsa derleyici bloğun hangi değeri üreteceğini bilemez ve kod derlenmez. `return` metottan çıkmak içindir ve bir `switch` ifadesinin içinden kullanılamaz; bloğun son satırı da kendiliğinden değer sayılmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`return` anahtar kelimesiyle$$, FALSE, 0),
        ($$`yield` anahtar kelimesiyle$$, TRUE, 1),
        ($$`break` anahtar kelimesiyle$$, FALSE, 2),
        ($$Bloğun son satırındaki ifade kendiliğinden değer olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir enum üzerindeki `switch`'te derleyicinin tüm sabitlerin ele alınıp alınmadığını denetlemesi hangi durumda geçerlidir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir enum üzerindeki `switch`'te derleyicinin tüm sabitlerin ele alınıp alınmadığını denetlemesi hangi durumda geçerlidir?$$,
           NULL, NULL,
           $$Bu denetim yalnızca `switch` değer üreten bir ifade olarak yazıldığında yapılır. `switch` bir deyim olarak kullanıldığında, ok sözdizimiyle yazılmış olsa bile, derleyici eksik sabitleri zorunlu tutmaz; bu yüzden belirleyici olan `->` değil, `switch`'in bir değer üretip üretmediğidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`switch` ok (`->`) sözdizimiyle yazıldığı her durumda$$, FALSE, 0),
        ($$Klasik sözdizimi dahil her `switch`'te$$, FALSE, 1),
        ($$`switch` değer üreten bir ifade olarak yazıldığında$$, TRUE, 2),
        ($$Yalnızca bir `default` dalı eklendiğinde$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 TR, quiz position 6, CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$String rol = new String("admin");

String etiket = switch (rol) {
    case "admin" -> "Yönetici";
    case "user" -> "Kullanıcı";
    default -> "Bilinmiyor";
};

System.out.println(etiket);$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$String rol = new String("admin");

String etiket = switch (rol) {
    case "admin" -> "Yönetici";
    case "user" -> "Kullanıcı";
    default -> "Bilinmiyor";
};

System.out.println(etiket);$$, $$java$$,
           $$`String` üzerindeki bir `switch`, `.equals()` gibi içeriği karşılaştırır. `rol`, `new` ile oluşturulmuş ayrı bir nesne olsa da içeriği `admin`'dir ve ilk dalla eşleşir. `Bilinmiyor` sonucu, karşılaştırma `==` gibi referans üzerinden yapılsaydı çıkardı; `switch`'te bu tuzak geçerli değildir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`Bilinmiyor`$$, FALSE, 0),
        ($$`Kullanıcı`$$, FALSE, 1),
        ($$Hiçbir şey, çünkü kod derlenmez$$, FALSE, 2),
        ($$`Yönetici`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

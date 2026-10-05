-- Links the TR introduction-to-exceptions questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Exception'lar, başarısızlığı `-1` gibi özel bir dönüş değeriyle bildirmeye göre hangi avantajı sağlar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Exception'lar, başarısızlığı `-1` gibi özel bir dönüş değeriyle bildirmeye göre hangi avantajı sağlar?$$,
           NULL, NULL,
           $$Özel bir dönüş değeri, çağıran her seferinde onu kontrol etmeyi hatırlarsa işe yarar; unutulduğunda hata sessizce kaybolur. Exception ise göz ardı edilemez: kimse ele almazsa program gürültülü biçimde durur. Bu, hata yönetimi yazma gereğini ortadan kaldırmaz; yalnızca hatanın fark edilmeden geçmesini önler.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$Çağıran kodun artık hata yönetimi yazması gerekmez$$, FALSE, 0),
        ($$Başarısız olan metot daha hızlı çalışır$$, FALSE, 1),
        ($$Başarısızlık sessizce göz ardı edilemez; ele alınmazsa program durur$$, TRUE, 2),
        ($$Hatalar derleme sırasında kendiliğinden düzeltilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir exception nesnesi hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir exception nesnesi hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Stack trace, nesne oluşturulduğu anda hangi metotların hangi sırayla etkin olduğunun otomatik bir kaydıdır; `getMessage()`, `getCause()` ve `getStackTrace()` de `Throwable`'dan gelir, çünkü her exception sınıfı sonuçta onu genişletir. `cause` ise isteğe bağlıdır, her exception'da bulunmaz; hatanın yerini gösteren de mesaj değil stack trace'tir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$Her exception'ın bir `cause` değeri olmak zorundadır$$, FALSE, 0),
        ($$Stack trace, nesne oluşturulduğu anda etkin olan metotları gösterir$$, TRUE, 1),
        ($$Hatanın hangi metotta oluştuğunu yalnızca mesaj gösterir$$, FALSE, 2),
        ($$Her exception sınıfı sonuçta `Throwable`'ı genişletir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştırıldığında ne olur?$$
      AND code_snippet = $$System.out.println("Başladı");

String metin = null;
System.out.println(metin.length());

System.out.println("Bitti");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştırıldığında ne olur?$$,
           $$System.out.println("Başladı");

String metin = null;
System.out.println(metin.length());

System.out.println("Bitti");$$, $$java$$,
           $$`Başladı` yazdırılır; ardından `null` olan bir referans üzerinde metot çağrıldığı için JVM `NullPointerException` fırlatır. Onu yakalayan bir şey olmadığından program tam o satırda sonlanır ve `Bitti` hiç yazdırılmaz. Yakalanmayan bir exception, hata mesajı basıp kaldığı yerden devam etmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$`Başladı` yazdırılır, sonra program `NullPointerException` ile sonlanır$$, TRUE, 0),
        ($$`Başladı` yazdırılır, bir hata mesajı basılır ve ardından `Bitti` yazdırılır$$, FALSE, 1),
        ($$`Başladı`, `0` ve `Bitti` yazdırılır, çünkü `null` metnin uzunluğu `0` sayılır$$, FALSE, 2),
        ($$Hiçbir şey yazdırılmaz, çünkü kod derlenmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yakalanmayan bir exception, onu fırlatan metottan sonra nereye gider?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Yakalanmayan bir exception, onu fırlatan metottan sonra nereye gider?$$,
           NULL, NULL,
           $$Exception, fırlatıldığı metottan başlayarak onu çağıran metotlara doğru, her seferinde bir çağrı yukarı yayılır; biri ele alana ya da en üste ulaşana kadar. Yol üzerindeki her metotta fırlatma noktasından sonraki satırlar çalışmaz; yani çağıran metotlar kaldıkları yerden devam etmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$Yalnızca fırlatıldığı metodu durdurur; çağıran metot kaldığı yerden sürer$$, FALSE, 0),
        ($$Kendisini çağıran metotlara doğru, biri ele alana ya da en üste ulaşana kadar yayılır$$, TRUE, 1),
        ($$Fırlatıldığı metodun sonuna gider ve metot normal biçimde döner$$, FALSE, 2),
        ($$Doğrudan `main`'in ilk satırına döner ve program baştan çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`int[] sayilar = new int[3];` tanımından sonra `sayilar[3]` ifadesine erişmek hangi exception'ı fırlatır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`int[] sayilar = new int[3];` tanımından sonra `sayilar[3]` ifadesine erişmek hangi exception'ı fırlatır?$$,
           NULL, NULL,
           $$Üç elemanlı bir dizinin geçerli indeksleri 0, 1 ve 2'dir; 3 dizinin sınırı dışındadır ve `ArrayIndexOutOfBoundsException` fırlatılır. Dizi `null` olmadığı için `NullPointerException` söz konusu değildir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'introduction-to-exceptions'
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
        ($$`NullPointerException`$$, FALSE, 0),
        ($$`ArithmeticException`$$, FALSE, 1),
        ($$`ArrayIndexOutOfBoundsException`$$, TRUE, 2),
        ($$`NumberFormatException`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Links the TR exception-handling-best-practices questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Exception'lar hangi tür durumlar için kullanılmalıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Exception'lar hangi tür durumlar için kullanılmalıdır?$$,
           NULL, NULL,
           $$Exception'lar, bir metodun normal ve beklenen işleyişinin parçası olmayan istisnai durumlar içindir. Bir döngüden çıkmak ya da bir değeri dışarı taşımak sıradan kontrol akışıdır; bunları `return` ve `break` zaten yapar ve stack trace oluşturmanın maliyetini de getirmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Aranan değer bulunduğunda bir döngüden erken çıkmak için$$, FALSE, 0),
        ($$İç içe çağrıların derinliklerinden bir değeri dışarı taşımak için$$, FALSE, 1),
        ($$Bir metodun normal, beklenen işleyişinin parçası olmayan istisnai durumlar için$$, TRUE, 2),
        ($$Beklenen, gündelik sonuçları çağırana bildirmek için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Demo {
    public static void main(String[] args) {
        int toplam = 0;
        String[] girdiler = {"5", "x", "7"};

        for (String girdi : girdiler) {
            try {
                toplam += Integer.parseInt(girdi);
            } catch (NumberFormatException e) {
            }
        }

        System.out.println(toplam);
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Demo {
    public static void main(String[] args) {
        int toplam = 0;
        String[] girdiler = {"5", "x", "7"};

        for (String girdi : girdiler) {
            try {
                toplam += Integer.parseInt(girdi);
            } catch (NumberFormatException e) {
            }
        }

        System.out.println(toplam);
    }
}$$, $$java$$,
           $$`x` sayıya çevrilemez ve `NumberFormatException` fırlatılır, ama boş `catch` bloğu onu iz bırakmadan yutar; döngü sürer ve 5 ile 7 toplanır. Sonuç 12 olarak yazdırılır ve girdilerden birinin atlandığına dair hiçbir işaret kalmaz. Program sonlanmaz, hata mesajı da basılmaz; sorun tam olarak budur.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$`5`$$, FALSE, 0),
        ($$`0`$$, FALSE, 1),
        ($$Hiçbir şey, çünkü program `NumberFormatException` ile sonlanır$$, FALSE, 2),
        ($$`12`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Alışkanlık olarak her yerde `catch (Exception e)` yazmanın sakıncası nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Alışkanlık olarak her yerde `catch (Exception e)` yazmanın sakıncası nedir?$$,
           NULL, NULL,
           $$Geniş bir `catch`, birbirinden tamamen farklı tepkiler gerektiren hataları tek bir genel tepkide toplar. Her `catch` bloğu adını taşıdığı hataya tepki vermelidir; `Exception`'ı yakalamak ancak bilinçli bir son çare olarak, en sonda anlamlıdır. Kod derlenir, sorun derleme değil tasarımdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Farklı tepki gerektiren hataları tek bir genel tepkide toplar$$, TRUE, 0),
        ($$Kod derlenmez, çünkü `Exception` doğrudan yakalanamaz$$, FALSE, 1),
        ($$Yakalanan exception'ın stack trace'i kendiliğinden silinir$$, FALSE, 2),
        ($$Aynı `try` için başka bir `catch` bloğu yazılmasını engeller$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metodun, karşılaştığı exception'a verebileceği anlamlı bir tepki yoksa ne yapması gerekir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir metodun, karşılaştığı exception'a verebileceği anlamlı bir tepki yoksa ne yapması gerekir?$$,
           NULL, NULL,
           $$Yeniden deneme, varsayılana düşme ya da hatayı çağırana daha açık biçimde aktarma gibi bir tepkisi olmayan metot exception'ı yakalamamalı, onu ele alabilecek katmana yayılmasına izin vermelidir. Boş bir `catch` hatayı gizler; hiçbir şey eklemeden yeniden fırlatmak ise yalnızca gereksiz kod üretir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$Boş bir `catch` bloğuyla yakalayıp çalışmaya devam etmelidir$$, FALSE, 0),
        ($$Yakalamamalı; exception'ın onu ele alabilecek bir katmana yayılmasına izin vermelidir$$, TRUE, 1),
        ($$Yakalayıp aynı exception'ı hiçbir şey eklemeden yeniden fırlatmalıdır$$, FALSE, 2),
        ($$Yakalayıp varsayılan değer olarak `0` döndürmelidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri kaçınılması gereken alışkanlıklardır? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri kaçınılması gereken alışkanlıklardır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Geniş bir üst türü daha dar olandan önce yakalamak, farklı hataları tek bir genel tepkide eritir. Bir exception'ı yalnızca loglayıp aynen yeniden fırlatmak için yakalamak ise çağıranın zaten yapabileceği bir şeyi tekrar eder. `catch` bloklarını spesifikten genele sıralamak ve sararken özgün exception'ı `cause` olarak korumak önerilen pratiklerdir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'exception-handling-best-practices'
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
        ($$`catch` bloklarını en spesifikten en genele doğru sıralamak$$, FALSE, 0),
        ($$Başka bir türe sararken özgün exception'ı `cause` olarak korumak$$, FALSE, 1),
        ($$Daha dar bir türü hiç düşünmeden geniş bir üst türü yakalamak$$, TRUE, 2),
        ($$Bir exception'ı yalnızca loglayıp aynen yeniden fırlatmak için yakalamak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling-best-practices'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

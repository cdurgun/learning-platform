-- Promotion-style migration linking TR try-catch-finally quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki kod parçası için ne söylenebilir?$$
      AND code_snippet = $$try {
    String s = null;
    s.length();
} catch (Exception e) {
    System.out.println("genel");
} catch (NullPointerException e) {
    System.out.println("null");
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki kod parçası için ne söylenebilir?$$,
           $$try {
    String s = null;
    s.length();
} catch (Exception e) {
    System.out.println("genel");
} catch (NullPointerException e) {
    System.out.println("null");
}$$, $$java$$,
           $$Bir süper sınıf (Exception) için catch bloğu, alt sınıfından (NullPointerException) biri için catch bloğundan ÖNCE geldiği için, ikinci catch bloğu erişilemez olur -- derleyici bunu hata olarak reddeder, "Birden Fazla catch Bloğu: Sırayla Eşleşme" bölümünde anlatıldığı gibi.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$Derlenir ve "genel" yazdırır.$$, FALSE, 0),
    ($$Derlenir ve "null" yazdırır.$$, FALSE, 1),
    ($$İkinci catch bloğu erişilemez olduğu için derlenmez.$$, TRUE, 2),
    ($$Derlenir ama çalışma zamanında hata fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Ornek {
    static String islem() {
        try {
            System.out.println("deneme");
            return "tamam";
        } finally {
            System.out.println("temizlik");
        }
    }
    public static void main(String[] args) {
        System.out.println("sonuc: " + islem());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static String islem() {
        try {
            System.out.println("deneme");
            return "tamam";
        } finally {
            System.out.println("temizlik");
        }
    }
    public static void main(String[] args) {
        System.out.println("sonuc: " + islem());
    }
}$$, $$java$$,
           $$finally, try bloğu zaten bir return içerse bile her zaman çalışır -- return değeri değerlendirildikten sonra ama kontrol metottan gerçekten çıkmadan önce çalışır, bu yüzden "temizlik" "sonuc: tamam"dan önce yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$deneme / temizlik / sonuc: tamam$$, TRUE, 0),
    ($$deneme / sonuc: tamam / temizlik$$, FALSE, 1),
    ($$temizlik / deneme / sonuc: tamam$$, FALSE, 2),
    ($$deneme / sonuc: tamam (temizlik hiç çalışmaz)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Ornek {
    static int hesapla() {
        try {
            return 10;
        } finally {
            return 20;
        }
    }
    public static void main(String[] args) {
        System.out.println(hesapla());
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static int hesapla() {
        try {
            return 10;
        } finally {
            return 20;
        }
    }
    public static void main(String[] args) {
        System.out.println(hesapla());
    }
}$$, $$java$$,
           $$finally'nin kendisi bir return içerdiğinde, try bloğunun döndürmek üzere olduğu her şeyi sessizce ezer -- try'ın 10 döndürme girişimi tamamen atılır, yalnızca finally'nin 20'si döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$10$$, FALSE, 0),
    ($$20$$, TRUE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$Önce 10 sonra 20 yazdırılır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Multi-catch (`|`) kullanımı için doğru gerekçe hangisidir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Multi-catch (`|`) kullanımı için doğru gerekçe hangisidir?$$,
           NULL, NULL,
           $$Multi-catch, iki ya da daha fazla farklı exception tipi gerçekten aynı handling koduna ihtiyaç duyduğunda ayrı, yinelenen catch bloklarının kod tekrarını önlemek için kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$İki farklı exception tipi aynı handling koduna ihtiyaç duyduğunda kod tekrarını önlemek için.$$, TRUE, 0),
    ($$Bir catch bloğunun birden fazla kez çalışmasını sağlamak için.$$, FALSE, 1),
    ($$finally bloğunu atlamak için.$$, FALSE, 2),
    ($$Checked exception'ları unchecked yapmak için.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`catch (IOException hata) { ... }` bloğundaki `hata` parametresi için ne söylenebilir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`catch (IOException hata) { ... }` bloğundaki `hata` parametresi için ne söylenebilir?$$,
           NULL, NULL,
           $$catch bloğundaki parametre, yalnızca o catch bloğuna scope'lanmış gerçek, sıradan bir yerel değişkendir -- üzerinde Throwable'ın tanımladığı herhangi bir metot çağrılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$Yalnızca o catch bloğuna scope'lu, Throwable'ın tanımladığı herhangi bir metodun çağrılabildiği sıradan bir yerel değişkendir.$$, TRUE, 0),
    ($$Statik bir alandır.$$, FALSE, 1),
    ($$Yalnızca toString() çağrılabilir.$$, FALSE, 2),
    ($$Metot dışından da erişilebilir bir global değişkendir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`finally` bloğuyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`finally` bloğuyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$finally, try bloğu başarılı olsa da, bir exception yakalansa da, ya da bir exception hiç yakalanmadan geçip gitse de her durumda koşulsuz olarak çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$try bloğu başarıyla tamamlansa bile finally çalışır.$$, TRUE, 0),
    ($$Bir exception hiçbir catch bloğu tarafından yakalanmadan geçip gitse bile finally çalışır.$$, TRUE, 1),
    ($$finally, yalnızca bir catch bloğu gerçekten çalıştıysa tetiklenir.$$, FALSE, 2),
    ($$Bir try-with-resources kullanılıyorsa finally asla çalışmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$finally içine return ya da throw koymak, try/catch'in üretmek üzere olduğu her şeyi sessizce ezer; finally'nin bir try bloğu return ettiğinde çalışmadığını varsaymak da yanlıştır, çünkü finally her durumda çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$Bir finally bloğunun içine return ya da throw koymak.$$, TRUE, 0),
    ($$finally'nin, try bloğu return ettiğinde çalışmadığını varsaymak.$$, TRUE, 1),
    ($$Özdeş handling mantığı için multi-catch kullanmak.$$, FALSE, 2),
    ($$catch bloklarını en spesifikten en genele sıralamak.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

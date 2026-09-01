-- Promotion-style migration linking TR throw-and-throws quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`throws` bildirimi tek başına çalıştırıldığında ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`throws` bildirimi tek başına çalıştırıldığında ne olur?$$,
           NULL, NULL,
           $$throws, tek başına, hiçbir şey fırlatmaz ya da hiçbir kod çalıştırmaz -- yalnızca derleyiciye ve metodu okuyan herkese o metottan hangi checked exception'ların çıkabileceğini söyler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$Belirtilen exception türünü hemen fırlatır.$$, FALSE, 0),
    ($$Hiçbir şey -- yalnızca derleyiciye hangi checked exception'ların metottan çıkabileceğini söyler, kod çalıştırmaz.$$, TRUE, 1),
    ($$Metodun içindeki tüm exception'ları otomatik olarak yakalar.$$, FALSE, 2),
    ($$throw ifadesiyle aynı çalışma zamanı davranışına sahiptir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Ornek {
    static double indirimUygula(double fiyat, int yuzde) {
        if (yuzde < 0 || yuzde > 100) {
            throw new IllegalArgumentException("gecersiz yuzde: " + yuzde);
        }
        return fiyat - (fiyat * yuzde / 100);
    }
    public static void main(String[] args) {
        try {
            System.out.println(indirimUygula(200.0, 150));
        } catch (IllegalArgumentException e) {
            System.out.println("hata: " + e.getMessage());
        }
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
    static double indirimUygula(double fiyat, int yuzde) {
        if (yuzde < 0 || yuzde > 100) {
            throw new IllegalArgumentException("gecersiz yuzde: " + yuzde);
        }
        return fiyat - (fiyat * yuzde / 100);
    }
    public static void main(String[] args) {
        try {
            System.out.println(indirimUygula(200.0, 150));
        } catch (IllegalArgumentException e) {
            System.out.println("hata: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$applyDiscount fail-fast validasyon yapar: yuzde 150, geçerli aralığın (0-100) dışında olduğu için gerçek hesaplama yapılmadan IllegalArgumentException fırlatılır, mesajıyla birlikte yakalanıp yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$hata: gecersiz yuzde: 150$$, TRUE, 0),
    ($$-100.0$$, FALSE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$hata: null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kodun çalışma davranışı nedir?$$
      AND code_snippet = $$public class Ornek {
    static void adim1() throws java.io.FileNotFoundException {
        adim2();
    }
    static void adim2() throws java.io.FileNotFoundException {
        throw new java.io.FileNotFoundException("dosya yok");
    }
    public static void main(String[] args) throws java.io.FileNotFoundException {
        adim1();
        System.out.println("bitti");
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kodun çalışma davranışı nedir?$$,
           $$public class Ornek {
    static void adim1() throws java.io.FileNotFoundException {
        adim2();
    }
    static void adim2() throws java.io.FileNotFoundException {
        throw new java.io.FileNotFoundException("dosya yok");
    }
    public static void main(String[] args) throws java.io.FileNotFoundException {
        adim1();
        System.out.println("bitti");
    }
}$$, $$java$$,
           $$adim1 ve adim2 yalnızca throws bildirir, hiçbiri catch etmez; main de yalnızca throws bildirdiği için exception hiçbir yerde yakalanmadan yayılır ve program bir stack trace ile sonlanır -- "bitti" hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$"bitti" yazdırılır, sonra program biter.$$, FALSE, 0),
    ($$Program, exception yakalanmadığı için bir stack trace ile sonlanır, "bitti" hiç yazdırılmaz.$$, TRUE, 1),
    ($$Derlenmez çünkü adim2() exception'ı catch etmiyor.$$, FALSE, 2),
    ($$adim1() exception'ı otomatik olarak yutar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`throw` ve `throws` arasındaki farkla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`throw` ve `throws` arasındaki farkla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$throw, bir metodun gövdesinin yaptığı bir şeydir, belirli bir satırda, çalışma zamanında çalışır; throws ise bir metodun imzasının bildirdiği bir şeydir ve tek bir metot, hiç throw çağırmadan bile ihtiyaç duyduğu kadar çok exception türünü virgülle ayırarak bildirebilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$throw, çalışma zamanında belirli bir satırda çalışan bir ifadedir.$$, TRUE, 0),
    ($$throws, aynı metotta hiç throw çağrısı olmadan bile birden fazla exception türünü virgülle bildirebilir.$$, TRUE, 1),
    ($$throws, metot çalıştığında JVM'e bir Throwable nesnesi teslim eder.$$, FALSE, 2),
    ($$throw, bir metot imzasında yer alan derleme-zamanı bir bildirimdir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangisi yaygın bir hatadır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangisi yaygın bir hatadır?$$,
           NULL, NULL,
           $$Ne olduğunu gerçekten anlatan bir tür ve mesaj yerine genel, düşük bilgili bir exception fırlatmak (throw new RuntimeException("error") gibi) bu derste açıkça bir yaygın hata olarak belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$throw new RuntimeException("error") gibi genel, düşük bilgili bir exception fırlatmak.$$, TRUE, 0),
    ($$Bir metodun en başında argümanları doğrulayıp fırlatmak.$$, FALSE, 1),
    ($$Yeniden fırlatırken orijinal exception'ı cause olarak geçirmek.$$, FALSE, 2),
    ($$Yalnızca gerçekten üretilebilecek checked exception'lar için throws eklemek.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`throw` ile `throws` arasındaki "kaç kez/kaç tür" farkı için hangisi doğrudur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`throw` ile `throws` arasındaki "kaç kez/kaç tür" farkı için hangisi doğrudur?$$,
           NULL, NULL,
           $$throw, ona ulaşan bir çalışma yolu başına yalnızca bir kez görünebilir; throws ise tek bir metotta ihtiyaç duyduğu kadar çok exception türünü (virgülle ayırarak) bildirebilir, hiç throw çağırmasa bile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$throw, bir çalışma yoluna ulaşan yol başına yalnızca bir kez çalışır; throws birden fazla exception türünü listeleyebilir.$$, TRUE, 0),
    ($$İkisi de yalnızca bir tür belirtebilir.$$, FALSE, 1),
    ($$throws, bir çalışma yolu başına yalnızca bir kez çalışabilir.$$, FALSE, 2),
    ($$throw, virgülle ayrılmış birden fazla tür alabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`throw` olmadan, kodun "bir şey ters gitti" demesinin geleneksel yolu neydi?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`throw` olmadan, kodun "bir şey ters gitti" demesinin geleneksel yolu neydi?$$,
           NULL, NULL,
           $$throw olmasaydı, kodun "bir şey ters gitti" demesinin tek yolu sihirli bir dönüş değeri olurdu (-1 ya da null gibi) -- "Exception'lara Giriş"in açtığı tam olarak bu sorundu.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'throw-and-throws'
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
    ($$Sihirli bir dönüş değeri kullanmak (örneğin -1 ya da null).$$, TRUE, 0),
    ($$Programı doğrudan sonlandırmak.$$, FALSE, 1),
    ($$Bir log dosyasına yazmak.$$, FALSE, 2),
    ($$Statik bir hata bayrağı (flag) ayarlamak.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'throw-and-throws'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

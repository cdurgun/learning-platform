-- Promotion-style migration linking TR custom-exceptions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir custom exception `RuntimeException`'ı genişletirse ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir custom exception `RuntimeException`'ı genişletirse ne olur?$$,
           NULL, NULL,
           $$Custom exception RuntimeException'ı genişletirse unchecked olur -- throws bildirmek ya da catch etmek zorunlu değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Checked bir exception olur, throws bildirmek zorunludur.$$, FALSE, 0),
    ($$Unchecked bir exception olur, throws bildirmek ya da catch etmek zorunlu değildir.$$, TRUE, 1),
    ($$Artık Throwable'ın metotlarını miras almaz.$$, FALSE, 2),
    ($$Derleyici onu otomatik olarak Exception'a dönüştürür.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class YetersizBakiyeException extends Exception {
    YetersizBakiyeException(String mesaj) {
        super(mesaj);
    }
}

public class Ornek {
    static void cek(double bakiye, double miktar) throws YetersizBakiyeException {
        if (miktar > bakiye) {
            throw new YetersizBakiyeException("yetersiz bakiye: " + miktar);
        }
    }
    public static void main(String[] args) {
        try {
            cek(100.0, 150.0);
        } catch (YetersizBakiyeException e) {
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
           $$class YetersizBakiyeException extends Exception {
    YetersizBakiyeException(String mesaj) {
        super(mesaj);
    }
}

public class Ornek {
    static void cek(double bakiye, double miktar) throws YetersizBakiyeException {
        if (miktar > bakiye) {
            throw new YetersizBakiyeException("yetersiz bakiye: " + miktar);
        }
    }
    public static void main(String[] args) {
        try {
            cek(100.0, 150.0);
        } catch (YetersizBakiyeException e) {
            System.out.println("hata: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$YetersizBakiyeException, Exception'ı genişlettiği için checked'tir -- cek() throws bildirir, miktar bakiyeyi aştığı için exception fırlatılır ve mesajıyla birlikte yakalanıp yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$hata: yetersiz bakiye: 150.0$$, TRUE, 0),
    ($$hata: yetersiz bakiye: 100.0$$, FALSE, 1),
    ($$Derleme hatası -- cek() throws bildirmeli değil.$$, FALSE, 2),
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
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Custom exception sınıf adlarının `Exception` sonekiyle bitmesi kuralı için ne söylenebilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Custom exception sınıf adlarının `Exception` sonekiyle bitmesi kuralı için ne söylenebilir?$$,
           NULL, NULL,
           $$Bu kural derleyici tarafından zorlanmaz, ama her Java kod tabanının beklediği güçlü bir okunabilirlik kuralıdır -- InsufficientFunds değil, InsufficientFundsException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Derleyici tarafından zorunlu tutulur, aksi halde derleme hatası alınır.$$, FALSE, 0),
    ($$Derleyici tarafından zorlanmaz, ama her Java kod tabanının beklediği güçlü bir okunabilirlik kuralıdır.$$, TRUE, 1),
    ($$Yalnızca unchecked custom exception'lar için geçerlidir.$$, FALSE, 2),
    ($$Exception'ı genişletenler için zorunlu, RuntimeException için isteğe bağlıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class OdemeException extends RuntimeException {
    OdemeException(String mesaj) { super(mesaj); }
}
class KartReddiException extends OdemeException {
    KartReddiException(String mesaj) { super(mesaj); }
}
class BaglantiZamanAsimiException extends OdemeException {
    BaglantiZamanAsimiException(String mesaj) { super(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new BaglantiZamanAsimiException("baglanti zaman asimi");
        } catch (KartReddiException e) {
            System.out.println("kart reddi: " + e.getMessage());
        } catch (OdemeException e) {
            System.out.println("odeme hatasi: " + e.getMessage());
        }
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class OdemeException extends RuntimeException {
    OdemeException(String mesaj) { super(mesaj); }
}
class KartReddiException extends OdemeException {
    KartReddiException(String mesaj) { super(mesaj); }
}
class BaglantiZamanAsimiException extends OdemeException {
    BaglantiZamanAsimiException(String mesaj) { super(mesaj); }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new BaglantiZamanAsimiException("baglanti zaman asimi");
        } catch (KartReddiException e) {
            System.out.println("kart reddi: " + e.getMessage());
        } catch (OdemeException e) {
            System.out.println("odeme hatasi: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$BaglantiZamanAsimiException, KartReddiException'ın bir alt sınıfı değildir (ikisi de OdemeException'ın kardeş alt sınıflarıdır), bu yüzden ilk catch bloğuyla eşleşmez ve daha genel olan ikinci catch (OdemeException) bloğuna düşer.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$kart reddi: baglanti zaman asimi$$, FALSE, 0),
    ($$odeme hatasi: baglanti zaman asimi$$, TRUE, 1),
    ($$İkisi de yazdırılır.$$, FALSE, 2),
    ($$Derlenmez, çünkü iki catch bloğu çakışır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class GecersizVeriException extends RuntimeException {
    GecersizVeriException(String mesaj) {
        // super(mesaj) cagrisi unutuldu
    }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new GecersizVeriException("beklenmeyen deger");
        } catch (GecersizVeriException e) {
            System.out.println("mesaj: " + e.getMessage());
        }
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class GecersizVeriException extends RuntimeException {
    GecersizVeriException(String mesaj) {
        // super(mesaj) cagrisi unutuldu
    }
}

public class Ornek {
    public static void main(String[] args) {
        try {
            throw new GecersizVeriException("beklenmeyen deger");
        } catch (GecersizVeriException e) {
            System.out.println("mesaj: " + e.getMessage());
        }
    }
}$$, $$java$$,
           $$Constructor super(mesaj)'ı çağırmadığı için mesaj parametresi hiçbir yere kaydedilmez ve RuntimeException'ın no-arg constructor'ı otomatik olarak çalışır -- getMessage() bu yüzden null döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$mesaj: beklenmeyen deger$$, FALSE, 0),
    ($$mesaj: null$$, TRUE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$NullPointerException fırlatılır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, ne zaman custom bir exception türü OLUŞTURMAMAK daha doğrudur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ne zaman custom bir exception türü OLUŞTURMAMAK daha doğrudur?$$,
           NULL, NULL,
           $$Hazır bir exception (IllegalArgumentException gibi) zaten tam olarak gerekeni söylerken custom bir exception'a başvurmak gereksizdir -- her hata yepyeni bir tür gerektirmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Hazır bir exception (IllegalArgumentException gibi) zaten tam olarak gerekeni söylediğinde.$$, TRUE, 0),
    ($$Bir catch bloğunun yapılandırılmış veriye ihtiyacı olduğunda.$$, FALSE, 1),
    ($$Bir hatayı uygulamanın kendi kelime dağarcığıyla tanımlamak gerektiğinde.$$, FALSE, 2),
    ($$Birden fazla ilgili hatayı ortak bir base sınıfla gruplamak gerektiğinde.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Custom exception hiyerarşisi kurmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Custom exception hiyerarşisi kurmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Ortak bir custom base sınıfı çağırana geniş ya da dar yakalama şansı verir; "ne olur ne olmaz" diye derin bir hiyerarşi kurmak yerine gerçek bir ihtiyaç ortaya çıktığında alt sınıf eklenmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Ortak bir custom base sınıfı, çağırana geniş ya da dar yakalama arasında seçim şansı verir.$$, TRUE, 0),
    ($$"Ne olur ne olmaz" diye derin bir hiyerarşi kurmak yerine, gerçek bir ihtiyaç ortaya çıktığında alt sınıf eklenmelidir.$$, TRUE, 1),
    ($$Her custom exception mutlaka Throwable'ı doğrudan genişletmelidir.$$, FALSE, 2),
    ($$Bir custom base sınıfı yalnızca checked exception'lar için kurulabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

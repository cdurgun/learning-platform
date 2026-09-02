-- Promotion-style migration linking TR interface quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$interface Bildirici {
    void bildir();
}

class SessizBildirici implements Bildirici {
    private void bildir() { System.out.println("bildirim"); }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$interface Bildirici {
    void bildir();
}

class SessizBildirici implements Bildirici {
    private void bildir() { System.out.println("bildirim"); }
}$$, $$java$$,
           $$Bir interface metodu örtük olarak public'tir, bu yüzden bir override implementasyonu erişim belirleyicisini asla daraltamaz -- interface metodu kadar erişilebilir olmak zorundadır. private, public'ten çok daha dar olduğu için bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Derlenir çünkü private, bir interface metodu için daha katı, geçerli bir seçimdir.$$, FALSE, 0),
    ($$Derlenmez -- bir override metodu, implement ettiği interface metodundan asla daha az erişilebilir olamaz.$$, TRUE, 1),
    ($$Derlenir ve "bildirim" yazdırır.$$, FALSE, 2),
    ($$Derlenir ama çalışma zamanında IllegalAccessException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Sabitler {
    int MAKS = 50;
}

class Aracim implements Sabitler {
    void goster() { System.out.println(MAKS); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Sabitler.MAKS);
        new Aracim().goster();
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Sabitler {
    int MAKS = 50;
}

class Aracim implements Sabitler {
    void goster() { System.out.println(MAKS); }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Sabitler.MAKS);
        new Aracim().goster();
    }
}$$, $$java$$,
           $$Interface alanları örtük olarak public static final'dır -- bir instance'a gerek kalmadan doğrudan Sabitler.MAKS olarak erişilebilir, ve her implementasyon örnek başına bir kopya değil, tam olarak aynı paylaşılan değeri görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Derleme hatası -- MAKS, Sabitler.MAKS olarak erişilebilir değildir.$$, FALSE, 0),
    ($$50
0$$, FALSE, 1),
    ($$Derleme hatası -- Aracim, MAKS'ı yeniden bildirmelidir.$$, FALSE, 2),
    ($$50
50$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir sınıf aynı anda kaç interface implement edebilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir sınıf aynı anda kaç interface implement edebilir?$$,
           NULL, NULL,
           $$Bir sınıf yalnızca bir sınıfı extends edebilir, ama istediği kadar interface'i virgülle ayırarak aynı anda implements edebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Yalnızca hepsi functional interface ise.$$, FALSE, 0),
    ($$Virgülle ayırarak istediği kadar -- sınıfların yalnızca bir sınıfı extends edebilmesinin aksine.$$, TRUE, 1),
    ($$extends ile aynı sınırla, yalnızca bir tane.$$, FALSE, 2),
    ($$En fazla iki.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Arac {
    default void selVer() { System.out.println("Bip"); }
}

class Otomobil implements Arac {}

class SporArac implements Arac {
    public void selVer() { System.out.println("Vinn-bip"); }
}

public class Ornek {
    public static void main(String[] args) {
        Arac a1 = new Otomobil();
        Arac a2 = new SporArac();
        a1.selVer();
        a2.selVer();
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Arac {
    default void selVer() { System.out.println("Bip"); }
}

class Otomobil implements Arac {}

class SporArac implements Arac {
    public void selVer() { System.out.println("Vinn-bip"); }
}

public class Ornek {
    public static void main(String[] args) {
        Arac a1 = new Otomobil();
        Arac a2 = new SporArac();
        a1.selVer();
        a2.selVer();
    }
}$$, $$java$$,
           $$Otomobil kendi selVer()'ını hiç sağlamaz, bu yüzden default implementasyonu otomatik olarak miras alır. SporArac ise kendi @Override'ıyla değiştirir -- bir default metot, sıradan bir instance metodu gibi polimorfik olarak çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Bip
Bip$$, FALSE, 0),
    ($$Derleme hatası -- Otomobil selVer()'ı kendisi implement etmelidir.$$, FALSE, 1),
    ($$Vinn-bip
Vinn-bip$$, FALSE, 2),
    ($$Bip
Vinn-bip$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir interface'in static metodu için hangi ifade doğrudur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir interface'in static metodu için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir default metodun aksine, bir static metot hiçbir implementasyona ait değildir -- doğrudan interface adı üzerinden çağrılır ve asla override edilemez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Örtük olarak abstract'tır ve implement eden her sınıf tarafından implement edilmelidir.$$, FALSE, 0),
    ($$Hiçbir implementasyona ait değildir, doğrudan interface adı üzerinden çağrılır ve asla override edilemez.$$, TRUE, 1),
    ($$Her implement eden sınıf tarafından miras alınır ve tıpkı bir default metot gibi override edilebilir.$$, FALSE, 2),
    ($$Yalnızca implement eden bir sınıfın instance'ı üzerinden çağrılabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Ucan {
    default String hareket() { return "ucuyor"; }
}

interface Yuzen {
    default String hareket() { return "yuzuyor"; }
}

class Ordek implements Ucan, Yuzen {
    public String hareket() {
        return Ucan.super.hareket() + "+" + Yuzen.super.hareket();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Ordek().hareket());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Ucan {
    default String hareket() { return "ucuyor"; }
}

interface Yuzen {
    default String hareket() { return "yuzuyor"; }
}

class Ordek implements Ucan, Yuzen {
    public String hareket() {
        return Ucan.super.hareket() + "+" + Yuzen.super.hareket();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Ordek().hareket());
    }
}$$, $$java$$,
           $$Ordek, hem Ucan'dan hem Yuzen'den çakışan bir hareket() default'u miras alır, bu yüzden Java açık bir override'ı zorunlu kılar. InterfaceAdi.super.metotAdi(), Ordek'in üst interface'lerden hangisini -- burada ikisini birden -- kullanacağını seçmesini sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$Derleme hatası -- Ordek hareket()'i kendisi override etmemelidir.$$, FALSE, 0),
    ($$ucuyor$$, FALSE, 1),
    ($$yuzuyor$$, FALSE, 2),
    ($$ucuyor+yuzuyor$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'interface')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Functional interface'ler hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Functional interface'ler hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir functional interface tam olarak bir abstract metoda sahiptir -- default ve static metotlar bu sayıya dahil değildir. Bir lambda ifadesi, bir functional interface'in instance'ı olarak doğrudan kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'interface'
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
    ($$@FunctionalInterface annotation'ı, bir interface'in lambda hedefi olarak kullanılabilmesi için zorunludur.$$, FALSE, 0),
    ($$Bir functional interface tam olarak bir abstract metoda sahiptir -- default ve static metotlar bu sayıya dahil değildir.$$, TRUE, 1),
    ($$Bir lambda ifadesi, bir functional interface'in instance'ı olarak doğrudan kullanılabilir.$$, TRUE, 2),
    ($$Bir functional interface'e ikinci bir abstract metot eklemek, var olan lambda tabanlı kodun değişmeden derlenmeye devam etmesine izin verir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'interface'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

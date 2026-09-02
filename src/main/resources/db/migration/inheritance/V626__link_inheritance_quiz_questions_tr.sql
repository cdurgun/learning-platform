-- Promotion-style migration linking TR inheritance quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir alt sınıf constructor'ı hiçbir zaman açıkça `super(...)` çağırmazsa, derleyici ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir alt sınıf constructor'ı hiçbir zaman açıkça `super(...)` çağırmazsa, derleyici ne yapar?$$,
           NULL, NULL,
           $$Bir alt sınıf constructor'ında hiç super(...) yazmazsan, derleyici ilk ifade olarak üst sınıfın parametresiz constructor'ını örtük olarak çağırmaya çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$Her durumda bir derleme hatasına neden olur.$$, FALSE, 0),
    ($$İlk ifade olarak üst sınıfın parametresiz constructor'ını örtük olarak çağırır.$$, TRUE, 1),
    ($$Üst sınıfı tamamen başlatılmamış bırakır.$$, FALSE, 2),
    ($$Bunun yerine alt sınıfın kendi parametresiz constructor'ını çağırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Sekil {
    double alan() { return 0; }
}

class Kare extends Sekil {
    double alan() { return 25.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Kare();
        System.out.println(s.alan());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Sekil {
    double alan() { return 0; }
}

class Kare extends Sekil {
    double alan() { return 25.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Kare();
        System.out.println(s.alan());
    }
}$$, $$java$$,
           $$Override edilmiş bir metodun hangi implementasyonunun çalışacağı, çalışma zamanında nesnenin gerçek sınıfına göre belirlenir -- s'nin statik tipi Sekil'dir, ama runtime tipi Kare'dir, bu yüzden Kare'nin alan()'ı çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$0.0$$, FALSE, 0),
    ($$Derleme hatası -- s, Kare değil Sekil olarak bildirilmiştir.$$, FALSE, 1),
    ($$0$$, FALSE, 2),
    ($$25.0$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Calisan {
    String tanimla() { return "Calisan"; }
}

class Yonetici extends Calisan {
    String tanimla() { return super.tanimla() + " + Yonetici"; }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Yonetici().tanimla());
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Calisan {
    String tanimla() { return "Calisan"; }
}

class Yonetici extends Calisan {
    String tanimla() { return super.tanimla() + " + Yonetici"; }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(new Yonetici().tanimla());
    }
}$$, $$java$$,
           $$super.metod(), üst sınıftaki override edilen metodu açıkça çağırır -- Yonetici, Calisan'ın orijinal davranışını atmaz, önce super.tanimla()'yı çağırarak onun üzerine inşa eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$Derleme hatası -- super.tanimla(), override eden bir metottan çağrılamaz.$$, FALSE, 0),
    ($$Calisan + Yonetici$$, TRUE, 1),
    ($$Yonetici$$, FALSE, 2),
    ($$Calisan$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir üst sınıfın `private` bir alanı var. Bir alt sınıfın bununla ilişkisi için hangi ifade doğrudur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir üst sınıfın `private` bir alanı var. Bir alt sınıfın bununla ilişkisi için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir private alan, teknik olarak bir alt sınıf tarafından miras alınır (alt sınıf instance'ının bellek düzeninin bir parçasıdır), ama alt sınıf ona doğrudan isimle erişemez -- yalnızca üst sınıfın sağladığı public/protected bir erişimci üzerinden.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$Alt sınıf alanı hiç miras almaz.$$, FALSE, 0),
    ($$Alt sınıf ona doğrudan erişebilir, çünkü kalıtım erişim belirleyiciden bağımsız olarak tüm üyeleri kapsar.$$, FALSE, 1),
    ($$Alan, miras alındığında otomatik olarak protected hâle gelir.$$, FALSE, 2),
    ($$Alan teknik olarak miras alınır, ama alt sınıf ona doğrudan isimle erişemez -- yalnızca public/protected bir erişimci üzerinden.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Hayvan {
    String etiket = "Hayvan";
}

class Kopek extends Hayvan {
    String etiket = "Kopek";
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kopek();
        Kopek k = new Kopek();
        System.out.println(h.etiket);
        System.out.println(k.etiket);
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {
    String etiket = "Hayvan";
}

class Kopek extends Hayvan {
    String etiket = "Kopek";
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kopek();
        Kopek k = new Kopek();
        System.out.println(h.etiket);
        System.out.println(k.etiket);
    }
}$$, $$java$$,
           $$Method overriding'in aksine, alan erişimi polimorfik değildir -- hangi alanın döneceği, nesnenin runtime tipine değil değişkenin derleme-zamanı statik tipine göre belirlenir. h statik olarak Hayvan tipindedir, bu yüzden Hayvan'ın etiket'ini görür; k ise Kopek'inkini görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$Derleme hatası -- Kopek, Hayvan'la aynı isimde bir alanı yeniden bildiremez.$$, FALSE, 0),
    ($$Hayvan
Kopek$$, TRUE, 1),
    ($$Kopek
Kopek$$, FALSE, 2),
    ($$Hayvan
Hayvan$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kalıtım bağlamında `final` anahtar kelimesi hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Kalıtım bağlamında `final` anahtar kelimesi hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Final bir sınıf asla extend edilemez. Final bir metot asla override edilemez, ama bir alt sınıf onu normal şekilde miras alıp kullanabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$Final bir metot asla override edilemez, ama bir alt sınıf onu normal şekilde miras alıp kullanabilir.$$, TRUE, 0),
    ($$Final bir metot bir alt sınıf tarafından hiç miras alınamaz.$$, FALSE, 1),
    ($$Final bir sınıf, aynı paket içindeki sınıflar tarafından yine de extend edilebilir.$$, FALSE, 2),
    ($$Final bir sınıf asla extend edilemez.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inheritance')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Hayvan {}
class Kopek extends Hayvan { void havla() { System.out.println("Hav"); } }
class Kus extends Hayvan {}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kus();
        if (h instanceof Kopek k) {
            k.havla();
        } else {
            System.out.println("kopek degil");
        }
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {}
class Kopek extends Hayvan { void havla() { System.out.println("Hav"); } }
class Kus extends Hayvan {}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kus();
        if (h instanceof Kopek k) {
            k.havla();
        } else {
            System.out.println("kopek degil");
        }
    }
}$$, $$java$$,
           $$h'nin runtime tipi Kopek değil Kus'tur, bu yüzden pattern-matching instanceof kontrolü başarısız olur ve else dalı çalışır -- ClassCastException fırlamaz, çünkü cast yalnızca tip kontrolü başarılı olursa denenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inheritance'
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
    ($$ClassCastException fırlatır.$$, FALSE, 0),
    ($$kopek degil$$, TRUE, 1),
    ($$Hav$$, FALSE, 2),
    ($$Derleme hatası -- pattern-matching instanceof önce açık bir cast gerektirir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inheritance'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

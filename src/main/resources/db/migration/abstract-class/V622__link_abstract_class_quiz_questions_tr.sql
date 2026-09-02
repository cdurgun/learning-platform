-- Promotion-style migration linking TR abstract-class quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$abstract class Sekil {
    double alan() { return 0.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Sekil();
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$abstract class Sekil {
    double alan() { return 0.0; }
}

public class Ornek {
    public static void main(String[] args) {
        Sekil s = new Sekil();
    }
}$$, $$java$$,
           $$Bir sınıfın doğrudan örneklenip örneklenemeyeceğine karar veren şey, bir abstract metoda sahip olup olmadığı değil, sınıfın kendisinin abstract işaretlenip işaretlenmediğidir. Sekil'in hiç abstract metodu yok, ama new Sekil() yine de derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$Derlenir çünkü alan()'ın tam bir gövdesi var.$$, FALSE, 0),
    ($$Derlenmez -- Sekil abstract'tır, bu yüzden abstract metodu olsun ya da olmasın asla doğrudan örneklenemez.$$, TRUE, 1),
    ($$Derlenir ve sorunsuz çalışır, çünkü Sekil'in hiç abstract metodu yok.$$, FALSE, 2),
    ($$Derlenir ama çalışma zamanında InstantiationException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Abstract bir sınıf olan `B`, abstract bir sınıf olan `A`'yı extends ediyor. `B`, `A`'nın abstract metotlarından birini implement etmiyor. `B` hangi koşulda yine de derlenir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Abstract bir sınıf olan `B`, abstract bir sınıf olan `A`'yı extends ediyor. `B`, `A`'nın abstract metotlarından birini implement etmiyor. `B` hangi koşulda yine de derlenir?$$,
           NULL, NULL,
           $$Yalnızca somut (concrete) bir sınıf, miras aldığı bir abstract metodu implement etmeye zorlanır; ara seviyedeki bir abstract sınıf onu implement etmeden bırakıp hiyerarşide daha aşağıya erteleyebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$B abstract olsun ya da olmasın her zaman derlenir.$$, FALSE, 0),
    ($$B boş bir varsayılan implementasyon sağlamadıkça asla derlenmez.$$, FALSE, 1),
    ($$Yalnızca B abstract metodun adını değiştirirse derlenir.$$, FALSE, 2),
    ($$B'nin kendisi de abstract olarak bildirildiği sürece -- yalnızca somut bir alt sınıf, miras aldığı tüm abstract metotları implement etmek zorundadır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$abstract class Hayvan {
    void uyu() { System.out.println("sessizce uyuyor"); }
    abstract void sesCikar();
}

class Kedi extends Hayvan {
    void sesCikar() { System.out.println("Miyav"); }
    @Override
    void uyu() { System.out.println("kestiriyor"); }
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kedi();
        h.uyu();
        h.sesCikar();
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$abstract class Hayvan {
    void uyu() { System.out.println("sessizce uyuyor"); }
    abstract void sesCikar();
}

class Kedi extends Hayvan {
    void sesCikar() { System.out.println("Miyav"); }
    @Override
    void uyu() { System.out.println("kestiriyor"); }
}

public class Ornek {
    public static void main(String[] args) {
        Hayvan h = new Kedi();
        h.uyu();
        h.sesCikar();
    }
}$$, $$java$$,
           $$uyu(), tam bir gövdeye sahip concrete bir metottur, ama bir alt sınıf yine de onu override edebilir -- Kedi bunu yapar, ve dynamic dispatch sayesinde bir Hayvan referansı üzerinden bile override edilen versiyon çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$kestiriyor
sessizce uyuyor$$, FALSE, 0),
    ($$kestiriyor
Miyav$$, TRUE, 1),
    ($$sessizce uyuyor
Miyav$$, FALSE, 2),
    ($$Derleme hatası -- miras alınan concrete bir metot abstract olmadan override edilemez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$abstract class Hesap {
    Hesap(String sahip) {
        System.out.println(sahip + " icin hesap acildi");
    }
}

class VadeliHesap extends Hesap {
    VadeliHesap(String sahip) {
        super(sahip);
        System.out.println("VadeliHesap hazir");
    }
}

public class Ornek {
    public static void main(String[] args) {
        new VadeliHesap("Ayse");
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$abstract class Hesap {
    Hesap(String sahip) {
        System.out.println(sahip + " icin hesap acildi");
    }
}

class VadeliHesap extends Hesap {
    VadeliHesap(String sahip) {
        super(sahip);
        System.out.println("VadeliHesap hazir");
    }
}

public class Ornek {
    public static void main(String[] args) {
        new VadeliHesap("Ayse");
    }
}$$, $$java$$,
           $$Abstract bir sınıfın bir constructor'ı olabilir, hiçbir zaman doğrudan new ile çağrılamasa da -- yalnızca bir super(...) çağrısı aracılığıyla çalışır. Üst sınıfın constructor'ı, alt sınıfın kendi ek işini yapmadan önce her zaman tamamlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$VadeliHesap hazir
Ayse icin hesap acildi$$, FALSE, 0),
    ($$Derleme hatası -- abstract bir sınıfın constructor'ı olamaz.$$, FALSE, 1),
    ($$Ayse icin hesap acildi$$, FALSE, 2),
    ($$Ayse icin hesap acildi
VadeliHesap hazir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metot üzerinde aşağıdaki modifier kombinasyonlarından hangileri yasaktır ve neden? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir metot üzerinde aşağıdaki modifier kombinasyonlarından hangileri yasaktır ve neden? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$private abstract yasaktır çünkü private bir metot zaten alt sınıflara görünmez, bu yüzden override edilemez. final abstract yasaktır çünkü final bir metot asla override edilemez, bu da abstract'ın gerektirdiğiyle doğrudan çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$public abstract -- public metotlar asla abstract olarak bildirilemez.$$, FALSE, 0),
    ($$private abstract -- private bir metot zaten alt sınıflara görünmez, bu yüzden asla override edilemez.$$, TRUE, 1),
    ($$final abstract -- final bir metot asla override edilemez, bu abstract'ın gerektirdiğiyle doğrudan çelişir.$$, TRUE, 2),
    ($$protected abstract -- protected metotlar asla alt sınıflar tarafından miras alınamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Denetlenebilir {
    String denetimKaydi();
}

abstract class Belge implements Denetlenebilir {
    abstract String icerik();
}

class Rapor extends Belge {
    String icerik() { return "rapor icerigi"; }
    public String denetimKaydi() { return "denetlendi: " + icerik(); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge b = new Rapor();
        System.out.println(b.denetimKaydi());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Denetlenebilir {
    String denetimKaydi();
}

abstract class Belge implements Denetlenebilir {
    abstract String icerik();
}

class Rapor extends Belge {
    String icerik() { return "rapor icerigi"; }
    public String denetimKaydi() { return "denetlendi: " + icerik(); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge b = new Rapor();
        System.out.println(b.denetimKaydi());
    }
}$$, $$java$$,
           $$Belge, Denetlenebilir'i implement eder ama denetimKaydi()'yi hiç yazmaz -- tıpkı kendi icerik()'ini ertelediği gibi, denetimKaydi()'yi de bir alt sınıfa erteler. Rapor ikisini de implement eder, bu yüzden çağrı normal şekilde çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$Derleme hatası -- Belge denetimKaydi()'yi kendisi implement etmelidir.$$, FALSE, 0),
    ($$Derleme hatası -- Rapor ayrıca implements Denetlenebilir bildirmelidir.$$, FALSE, 1),
    ($$null$$, FALSE, 2),
    ($$denetlendi: rapor icerigi$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Template Method deseninde, iskelet metodun (`run()` gibi) genellikle `final` işaretlenmesinin nedeni nedir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Template Method deseninde, iskelet metodun (`run()` gibi) genellikle `final` işaretlenmesinin nedeni nedir?$$,
           NULL, NULL,
           $$İskelet metodu final işaretlemek, alt sınıfların yalnızca ayrı adımların içeriğini doldurabilmesini garanti eder -- üst sınıfın tanımladığı sabit sırayı asla yeniden düzenleyemez ya da değiştiremezler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'abstract-class'
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
    ($$Metodun bir instance oluşturmadan çağrılabilmesine izin vermek için.$$, FALSE, 0),
    ($$Alt sınıfların yalnızca adımların içeriğini doldurabilmesini, sabit sırayı asla değiştirememesini garanti etmek için.$$, TRUE, 1),
    ($$Metodun hiç miras alınmasını önlemek için.$$, FALSE, 2),
    ($$Çünkü abstract metotların final bir metottan çağrılması zorunludur.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'abstract-class'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR polymorphism quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Compile-time polymorphism ile runtime polymorphism arasındaki fark için hangi ifade doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Compile-time polymorphism ile runtime polymorphism arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Compile-time polymorphism (overloading), derleyici tarafından çağrı noktasındaki argüman tiplerinden çözümlenir; runtime polymorphism (overriding) ise JVM tarafından nesnenin gerçek tipine göre çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$İkisi de farklı mekanizmalarla olsa da tamamen derleme zamanında çözümlenir.$$, FALSE, 0),
    ($$Compile-time polymorphism (overloading), derleme zamanında argüman tiplerinden çözümlenir; runtime polymorphism (overriding), çalışma zamanında nesnenin gerçek tipinden çözümlenir.$$, TRUE, 1),
    ($$Compile-time polymorphism nesnenin gerçek tipine göre çözümlenir; runtime polymorphism argüman tiplerine göre.$$, FALSE, 2),
    ($$İkisi de farklı mekanizmalarla olsa da tamamen çalışma zamanında çözümlenir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Hesapla {
    int topla(int a, int b) { return a + b; }
    double topla(double a, double b) { return a + b; }
}

public class Ornek {
    public static void main(String[] args) {
        Hesapla h = new Hesapla();
        System.out.println(h.topla(4, 6));
        System.out.println(h.topla(4.5, 5.5));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hesapla {
    int topla(int a, int b) { return a + b; }
    double topla(double a, double b) { return a + b; }
}

public class Ornek {
    public static void main(String[] args) {
        Hesapla h = new Hesapla();
        System.out.println(h.topla(4, 6));
        System.out.println(h.topla(4.5, 5.5));
    }
}$$, $$java$$,
           $$Derleyici, çağrı noktasında verilen argümanların sayısına ve tipine bakarak overload'ı seçer -- topla(4, 6), int overload'ı ile eşleşir, topla(4.5, 5.5) ise double overload'ı ile eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$10.0
10.0$$, FALSE, 0),
    ($$10
10$$, FALSE, 1),
    ($$Derleme hatası -- topla belirsizdir.$$, FALSE, 2),
    ($$10
10.0$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Yardimci {
    static String isle(long x) { return "long"; }
    static String isle(Integer x) { return "Integer"; }
    static String isle(int... x) { return "varargs"; }
}

public class Ornek {
    public static void main(String[] args) {
        int i = 7;
        System.out.println(Yardimci.isle(i));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static String isle(long x) { return "long"; }
    static String isle(Integer x) { return "Integer"; }
    static String isle(int... x) { return "varargs"; }
}

public class Ornek {
    public static void main(String[] args) {
        int i = 7;
        System.out.println(Yardimci.isle(i));
    }
}$$, $$java$$,
           $$Derleyici önce tam eşleşmeyi dener (int için yok), sonra widening'i -- int, doğrudan long'a genişler, bu yüzden isle(long) uygulanabilir. Widening, autoboxing'den (isle(Integer)) önce denendiği için isle(long) kazanır; varargs ise yalnızca son çare olarak denenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Derleme hatası -- çağrı belirsizdir.$$, FALSE, 0),
    ($$long$$, TRUE, 1),
    ($$Integer$$, FALSE, 2),
    ($$varargs$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Hayvan {
    Hayvan uret() { return new Hayvan(); }
}

class Kedi extends Hayvan {
    @Override
    Kedi uret() { return new Kedi(); }
}

public class Ornek {
    public static void main(String[] args) {
        Kedi k = new Kedi();
        Kedi yavru = k.uret();
        System.out.println(yavru.getClass().getSimpleName());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Hayvan {
    Hayvan uret() { return new Hayvan(); }
}

class Kedi extends Hayvan {
    @Override
    Kedi uret() { return new Kedi(); }
}

public class Ornek {
    public static void main(String[] args) {
        Kedi k = new Kedi();
        Kedi yavru = k.uret();
        System.out.println(yavru.getClass().getSimpleName());
    }
}$$, $$java$$,
           $$Override eden bir metot, üst sınıf metodunun döndürdüğünün bir alt türünü döndürebilir -- Kedi'nin uret()'i Hayvan yerine Kedi döner, geçerli bir covariant return type'tır, bu yüzden yavru hiçbir cast gerekmeden doğrudan atanabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Hayvan$$, FALSE, 0),
    ($$Derleme hatası -- uret()'in dönüş tipi tam olarak Hayvan ile eşleşmelidir.$$, FALSE, 1),
    ($$Derleme hatası -- yavru, Kedi değil Hayvan olarak bildirilmelidir.$$, FALSE, 2),
    ($$Kedi$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kalıtım ile polimorfizm arasındaki ilişki hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kalıtım ile polimorfizm arasındaki ilişki hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Kalıtım yapısal bir ilişkidir; polimorfizm ise çalışma zamanı davranışıdır -- kalıtım polimorfizmi mümkün kılar ama garanti etmez. Bir alt sınıf miras aldığı bir metodu hiç override etmiyorsa, o metodu çağırmak gerçek bir polimorfizm üretmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Her alt sınıf, miras aldığı her metot için otomatik olarak polimorfik davranış sergiler.$$, FALSE, 0),
    ($$Kalıtım yapısal bir ilişkidir; polimorfizm ise çalışma zamanı davranışıdır -- kalıtım polimorfizmi mümkün kılar ama garanti etmez.$$, TRUE, 1),
    ($$Bir alt sınıf miras aldığı hiçbir metodu override etmiyorsa, o metodu alt sınıf üzerinden çağırmak gerçek bir polimorfizm üretmez.$$, TRUE, 2),
    ($$Polimorfizm yalnızca extends ile kurulan bir sınıf hiyerarşisi söz konusu olduğunda gerçekleşebilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Bicimlendirici {
    String bicimlendir(String s);
}

class Belge {
    private Bicimlendirici bicimlendirici;
    Belge(Bicimlendirici b) { this.bicimlendirici = b; }
    void bicimlendiriciyiDegistir(Bicimlendirici b) { this.bicimlendirici = b; }
    String goster(String s) { return bicimlendirici.bicimlendir(s); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge belge = new Belge(s -> s.toLowerCase());
        System.out.println(belge.goster("MERHABA"));
        belge.bicimlendiriciyiDegistir(s -> "<" + s + ">");
        System.out.println(belge.goster("MERHABA"));
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Bicimlendirici {
    String bicimlendir(String s);
}

class Belge {
    private Bicimlendirici bicimlendirici;
    Belge(Bicimlendirici b) { this.bicimlendirici = b; }
    void bicimlendiriciyiDegistir(Bicimlendirici b) { this.bicimlendirici = b; }
    String goster(String s) { return bicimlendirici.bicimlendir(s); }
}

public class Ornek {
    public static void main(String[] args) {
        Belge belge = new Belge(s -> s.toLowerCase());
        System.out.println(belge.goster("MERHABA"));
        belge.bicimlendiriciyiDegistir(s -> "<" + s + ">");
        System.out.println(belge.goster("MERHABA"));
    }
}$$, $$java$$,
           $$Belge, bir Bicimlendirici'yi extend etmek yerine referans olarak tutar (composition) -- bicimlendiriciyiDegistir(...), davranışı çalışma zamanında değiştirir, bu kalıtımın asla yapamayacağı bir şeydir çünkü bir nesnenin sınıfı oluşturulduktan sonra değişemez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$merhaba
merhaba$$, FALSE, 0),
    ($$<MERHABA>
<MERHABA>$$, FALSE, 1),
    ($$Derleme hatası -- Belge, oluşturulduktan sonra bicimlendiricisini değiştiremez.$$, FALSE, 2),
    ($$merhaba
<MERHABA>$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, giderek büyüyen bir `if (obj instanceof TipA) {...} else if (obj instanceof TipB) {...}` zinciri genellikle neyin işaretidir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, giderek büyüyen bir `if (obj instanceof TipA) {...} else if (obj instanceof TipB) {...}` zinciri genellikle neyin işaretidir?$$,
           NULL, NULL,
           $$Her yeni tür eklendikçe büyüyen bir instanceof kontrol zinciri görüyorsan, bu genellikle polimorfizmin kullanılmadığının bir işaretidir -- iyi tasarlanmış bir sistemde çağıran kod hiçbir zaman "bu hangi tür?" diye sormaz, doğrudan polimorfik metodu çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'polymorphism'
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
    ($$Kodun zaten polimorfizmi doğru kullandığının işareti.$$, FALSE, 0),
    ($$Polimorfizmin kullanılmadığının bir işareti -- iyi tasarlanmış bir sistemde çağıran kod, tür kontrolü yapmak yerine doğrudan polimorfik bir metot çağırır.$$, TRUE, 1),
    ($$Birden fazla ilgili tür var olduğunda her zaman kullanılması gereken, gerekli ve deyimsel bir desen.$$, FALSE, 2),
    ($$İlgili türlerin ortak bir interface'i paylaşmadığının ve asla paylaşamayacağının işareti.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'polymorphism'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

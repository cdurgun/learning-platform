-- Promotion-style migration linking TR bounded-type-parameters quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$class Yardimci {
    static <T> int uzunlukVer(T deger) {
        return deger.length();
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Yardimci {
    static <T> int uzunlukVer(T deger) {
        return deger.length();
    }
}$$, $$java$$,
           $$Sınırsız bir T kesinlikle her şey olabilir, bu yüzden derleyici yalnızca her Object'in sahip olduğu metotlara sahip olduğunu varsayabilir -- toString(), equals() ve daha spesifik hiçbir şey. length() her Object'te garanti edilmez, bu yüzden bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$Derlenmez -- length(), her Object'in garanti ettiği bir metot değildir.$$, TRUE, 0),
    ($$Derlenir çünkü T her zaman String olduğu varsayılır.$$, FALSE, 1),
    ($$Derlenir ve sayısal olmayan her argüman için 0 döner.$$, FALSE, 2),
    ($$Derlenir ama çalışma zamanında NoSuchMethodException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Yardimci {
    static <T extends Number> double ortalama(List<T> sayilar) {
        double toplam = 0;
        for (T n : sayilar) toplam += n.doubleValue();
        return toplam / sayilar.size();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ortalama(List.of(10, 20, 30)));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T extends Number> double ortalama(List<T> sayilar) {
        double toplam = 0;
        for (T n : sayilar) toplam += n.doubleValue();
        return toplam / sayilar.size();
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ortalama(List.of(10, 20, 30)));
    }
}$$, $$java$$,
           $$T extends Number, olası her T'nin -- Integer, Double, Long ya da başka bir Number alt türü -- doubleValue()'ya sahip olduğunu garanti eder. List.of(10, 20, 30) bir List<Integer>'dır, Integer bir Number olduğu için kabul edilir ve sonuç 20.0 olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$20.0$$, TRUE, 0),
    ($$Derleme hatası -- ortalama yalnızca List<Number> kabul eder, List<Integer> değil.$$, FALSE, 1),
    ($$20$$, FALSE, 2),
    ($$Derleme hatası -- T extends Number açık bir tür tanığı gerektirir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hem `Number` hem `Comparable<T>` ile sınırlanmış bir tür parametresini doğru bildiren hangisidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Hem `Number` hem `Comparable<T>` ile sınırlanmış bir tür parametresini doğru bildiren hangisidir?$$,
           NULL, NULL,
           $$Birden fazla sınır & ile birleştirilir. En fazla bir sınır bir sınıf olabilir, ve varsa, ilk sırada gelmelidir, ardından interface'ler -- bu yüzden <T extends Number & Comparable<T>> doğrudur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$<T extends Number & Comparable<T>>$$, TRUE, 0),
    ($$<T extends Comparable<T> & Number>$$, FALSE, 1),
    ($$<T extends Number, Comparable<T>>$$, FALSE, 2),
    ($$<T extends Number | Comparable<T>>$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$class SayisalKutu<T extends Number> {
    private T deger;
    void koy(T deger) { this.deger = deger; }
}

public class Ornek {
    public static void main(String[] args) {
        SayisalKutu<Boolean> kutu = new SayisalKutu<>();
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class SayisalKutu<T extends Number> {
    private T deger;
    void koy(T deger) { this.deger = deger; }
}

public class Ornek {
    public static void main(String[] args) {
        SayisalKutu<Boolean> kutu = new SayisalKutu<>();
    }
}$$, $$java$$,
           $$SayisalKutu<T extends Number>, SayisalKutu<Boolean>'ın basitçe yazılamayacağı anlamına gelir -- derlenmez, çünkü Boolean sınırı karşılamaz (bir Number değildir).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$Derlenmez -- Boolean, T extends Number sınırını karşılamaz.$$, TRUE, 0),
    ($$Derlenir çünkü SayisalKutu aslında hiçbir şey saklamaz.$$, FALSE, 1),
    ($$Derlenir ama koy(...) çağrıldığında ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derlenir, Boolean'ı kutulanmış sayısal bir tür olarak ele alır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Yardimci {
    static <T extends Comparable<T>> T minimum(List<T> ogeler) {
        T en = ogeler.get(0);
        for (T oge : ogeler) {
            if (oge.compareTo(en) < 0) en = oge;
        }
        return en;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.minimum(List.of("muz", "armut", "elma")));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T extends Comparable<T>> T minimum(List<T> ogeler) {
        T en = ogeler.get(0);
        for (T oge : ogeler) {
            if (oge.compareTo(en) < 0) en = oge;
        }
        return en;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.minimum(List.of("muz", "armut", "elma")));
    }
}$$, $$java$$,
           $$<T extends Comparable<T>>, kendisini aynı türden bir başkasıyla karşılaştırabilen herhangi bir türü kabul eder -- String bu koşulu sağlar, Number ile hiçbir ilişki gerekmez. "armut" leksikografik sırada en küçüktür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$armut$$, TRUE, 0),
    ($$Derleme hatası -- minimum yalnızca List<T extends Number> kabul eder.$$, FALSE, 1),
    ($$elma$$, FALSE, 2),
    ($$muz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir tür parametresi `<T extends Comparable<T> & Number>` (interface, sınıftan önce) şeklinde yazılıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir tür parametresi `<T extends Comparable<T> & Number>` (interface, sınıftan önce) şeklinde yazılıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Sınırlardan en fazla biri bir sınıf olabilir, ve varsa, ilk sırada gelmelidir, ardından interface'ler. <T extends Comparable & Number> yazmak, interface'i sınıf sınırı olan Number'dan önce koyar -- bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$Bu derlenmez, çünkü bir sınıf sınırı her zaman herhangi bir interface sınırından önce gelmelidir.$$, TRUE, 0),
    ($$Bunun yerine <T extends Number & Comparable<T>> şeklinde yazmak sorunu çözer.$$, TRUE, 1),
    ($$Birden fazla sınır bildiriminde interface'ler ve sınıflar herhangi bir sırada görünebilir.$$, FALSE, 2),
    ($$Derleyici, hangisi ikinci sırada geliyorsa o sınırı sessizce yok sayar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir sınıf ya da metot üzerindeki `<T extends Comparable<T>>` gerçekte neyi kısıtlar?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir sınıf ya da metot üzerindeki `<T extends Comparable<T>>` gerçekte neyi kısıtlar?$$,
           NULL, NULL,
           $$Yaygın Hatalar bunu açıkça belirtir: sınır, hangi türlerin tür parametresinin yerine geçebileceğini tanımlar -- sınıfın ya da metodun kendisinin ne yapabileceğini KISITLAMAZ, ve generic sınıfın kendi davranışıyla ilgili bir ifade değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$T'nin yerine hangi türlerin geçebileceğini -- sınıfın ya da metodun kendisinin ne yapabileceğini değil.$$, TRUE, 0),
    ($$Generic sınıftan aynı anda kaç instance oluşturulabileceğini.$$, FALSE, 1),
    ($$Generic sınıfın kendisinin Comparable implement etmesine izin verilip verilmediğini.$$, FALSE, 2),
    ($$Sınıfın kendi metotlarının derlenme sırasını.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

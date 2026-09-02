-- Promotion-style migration linking TR lambda-expressions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki lambda ifadelerinden hangisi derlenmez?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki lambda ifadelerinden hangisi derlenmez?$$,
           NULL, NULL,
           $$Tam olarak bir parametre için parantezler isteğe bağlıdır, ama iki ya da daha fazla parametre için parantezler tekrar zorunlu hale gelir -- a, b -> a + b derlenmez, (a, b) -> a + b yazman gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$`() -> 42`$$, FALSE, 0),
    ($$`a, b -> a + b`$$, TRUE, 1),
    ($$`(a, b) -> a + b`$$, FALSE, 2),
    ($$`x -> x * 2`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> kare = x -> {
            x * x;
        };
        System.out.println(kare.apply(5));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> kare = x -> {
            x * x;
        };
        System.out.println(kare.apply(5));
    }
}$$, $$java$$,
           $$Bir lambda gövdesi { } içine alındığı anda, değer üreten her yolda return açık ve zorunlu hale gelir. Bu olmadan x * x; tek başına geçerli bir ifade bile değildir, bu yüzden bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Derlenir ve 25 yazdırır.$$, FALSE, 0),
    ($$Derlenir ve 0 yazdırır.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında bir istisna fırlatır.$$, FALSE, 2),
    ($$Derlenmez.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Ornek {
    public static void main(String[] args) {
        Comparator<String> karsilastir = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> islev = (a, b) -> a.length() - b.length();
        System.out.println(karsilastir.compare("ev", "araba"));
        System.out.println(islev.apply("ev", "araba"));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Ornek {
    public static void main(String[] args) {
        Comparator<String> karsilastir = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> islev = (a, b) -> a.length() - b.length();
        System.out.println(karsilastir.compare("ev", "araba"));
        System.out.println(islev.apply("ev", "araba"));
    }
}$$, $$java$$,
           $$Bir lambda'nın kendine ait bir türü yoktur -- derleyici ona bağlamdan bir tür atar. Comparator'ın compare'i ile BiFunction'ın apply'ı tam olarak aynı şekle sahip olduğu için (iki String girer, bir sonuç çıkar), aynı lambda ifadesi ikisine de uyar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$3
3$$, FALSE, 0),
    ($$-3
-3$$, TRUE, 1),
    ($$Derleme hatası -- aynı lambda iki farklı interface'i implement edemez.$$, FALSE, 2),
    ($$-3
Derleme hatası.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$import java.util.function.Supplier;

public class Ornek {
    public static void main(String[] args) {
        int adet = 3;
        Supplier<Integer> tedarikci = () -> adet * 10;
        adet = 7;
        System.out.println(tedarikci.get());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$import java.util.function.Supplier;

public class Ornek {
    public static void main(String[] args) {
        int adet = 3;
        Supplier<Integer> tedarikci = () -> adet * 10;
        adet = 7;
        System.out.println(tedarikci.get());
    }
}$$, $$java$$,
           $$Bir lambda yalnızca effectively final olan bir yerel değişkeni yakalayabilir -- ilk atamasından sonra asla yeniden atanmamış olması gerekir. adet, lambda onu yakaladıktan sonra 7'ye yeniden atanıyor, bu yüzden bu derlenmez, yeniden atama lambda tanımlandıktan sonra gerçekleşse bile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Derlenir ve 70 yazdırır.$$, FALSE, 0),
    ($$Derlenir ve 30 yazdırır.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında bir istisna fırlatır.$$, FALSE, 2),
    ($$Derlenmez.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Anonymous inner class ile lambda arasındaki fark hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Anonymous inner class ile lambda arasındaki fark hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir anonymous inner class'ın içinde this, o anonymous class'ın kendi instance'ına işaret eder. Bir lambda'nın içinde ise this, sanki lambda'nın gövdesi çevreleyen metoda doğrudan yapıştırılmış gibi, çevreleyen nesneye işaret eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Bir lambda'nın içinde `this`, lambda'nın kendi instance'ına işaret eder, çevreleyen nesneye ulaşmak için `OuterClass.this` gerekir.$$, FALSE, 0),
    ($$Bir anonymous inner class'ın içinde `this`, o anonymous class'ın kendi instance'ına işaret eder.$$, TRUE, 1),
    ($$Bir lambda'nın içinde `this`, sanki lambda'nın gövdesi çevreleyen metoda doğrudan yapıştırılmış gibi, çevreleyen nesneye işaret eder.$$, TRUE, 2),
    ($$Bir lambda, tıpkı bir anonymous inner class gibi ayrı, derlenmiş bir sınıf üretir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aynı `(a, b) -> a.length() - b.length()` lambda ifadesi neden hem `Comparator<String>`'a hem `BiFunction<String, String, Integer>`'a atanabilir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aynı `(a, b) -> a.length() - b.length()` lambda ifadesi neden hem `Comparator<String>`'a hem `BiFunction<String, String, Integer>`'a atanabilir?$$,
           NULL, NULL,
           $$Her iki interface'in de tek abstract metodu tam olarak aynı şekle sahiptir -- iki String girer, bir Integer/int sonuç çıkar -- bu yüzden aynı lambda ifadesi her iki hedef türe de uyar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Çünkü Comparator ve BiFunction aslında farklı isimler altında aynı interface'tir.$$, FALSE, 0),
    ($$Çünkü derleyici herhangi iki functional interface arasında otomatik dönüşüm yapar.$$, FALSE, 1),
    ($$Çünkü lambda'lar çalışma zamanında dinamik olarak tiplendirilir, bu yüzden hedef interface önemli değildir.$$, FALSE, 2),
    ($$Çünkü her iki interface'in de tek abstract metodu tam olarak aynı şekle sahiptir -- iki String girer, bir Integer/int sonuç çıkar.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Java'da lambda'lar var olmadan önce "bir davranışı parametre olarak geçirmenin" birincil yolu neydi?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Java'da lambda'lar var olmadan önce "bir davranışı parametre olarak geçirmenin" birincil yolu neydi?$$,
           NULL, NULL,
           $$Lambda'lardan önce, bir davranışı parametre olarak geçirmenin tek aracı anonymous inner class'tı -- tek satırlık bir mantık için bile etrafında birkaç satır boilerplate gerekiyordu.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Java 8'den önce bunu yapmanın hiçbir yolu yoktu.$$, FALSE, 0),
    ($$Tek satırlık bir mantık için bile birkaç satır boilerplate gerektiren bir anonymous inner class.$$, TRUE, 1),
    ($$Bugünkü method reference'larla aynı, statik bir yardımcı metot referansı.$$, FALSE, 2),
    ($$Reflection tabanlı dinamik metot çağrısı.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

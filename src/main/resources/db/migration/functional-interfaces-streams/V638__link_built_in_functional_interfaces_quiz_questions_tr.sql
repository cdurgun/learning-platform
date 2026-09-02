-- Promotion-style migration linking TR built-in-functional-interfaces quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.function.Predicate;

public class Ornek {
    public static void main(String[] args) {
        Predicate<String> uzunMu = s -> s.length() > 4;
        Predicate<String> mIleBasliyorMu = s -> s.startsWith("M");
        Predicate<String> birlesik = uzunMu.and(mIleBasliyorMu);
        System.out.println(birlesik.test("Merhaba"));
        System.out.println(birlesik.test("Masa"));
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Predicate;

public class Ornek {
    public static void main(String[] args) {
        Predicate<String> uzunMu = s -> s.length() > 4;
        Predicate<String> mIleBasliyorMu = s -> s.startsWith("M");
        Predicate<String> birlesik = uzunMu.and(mIleBasliyorMu);
        System.out.println(birlesik.test("Merhaba"));
        System.out.println(birlesik.test("Masa"));
    }
}$$, $$java$$,
           $$and(), iki predicate'i birleştirir, ikisinin de true olması gerekir. "Merhaba"nın uzunluğu 7 (>4) ve "M" ile başlıyor -- true. "Masa"nın uzunluğu 4, ilk kontrolü geçemiyor -- false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$false
false$$, FALSE, 0),
    ($$true
false$$, TRUE, 1),
    ($$false
true$$, FALSE, 2),
    ($$true
true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> birEkle = x -> x + 1;
        Function<Integer, Integer> ucKatla = x -> x * 3;
        System.out.println(birEkle.andThen(ucKatla).apply(2));
        System.out.println(birEkle.compose(ucKatla).apply(2));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<Integer, Integer> birEkle = x -> x + 1;
        Function<Integer, Integer> ucKatla = x -> x * 3;
        System.out.println(birEkle.andThen(ucKatla).apply(2));
        System.out.println(birEkle.compose(ucKatla).apply(2));
    }
}$$, $$java$$,
           $$f.andThen(g), önce f'i çalıştırır, sonucunu g'ye verir: (2+1)*3=9. f.compose(g), önce g'yi çalıştırır, sonucunu f'e verir: (2*3)+1=7.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$7
9$$, FALSE, 0),
    ($$9
9$$, FALSE, 1),
    ($$7
7$$, FALSE, 2),
    ($$9
7$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Consumer<T>` ile `Supplier<T>` arasındaki fark için hangi ifade doğrudur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`Consumer<T>` ile `Supplier<T>` arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Consumer'ın accept(T)'si bir değer alır ve bir yan etki uygular, hiçbir şey döndürmez. Supplier'ın get()'i ise hiçbir girdi almadan bir değer üretir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Consumer ve Supplier, yalnızca isim olarak farklı, birbirinin yerine geçebilir arayüzlerdir.$$, FALSE, 0),
    ($$Consumer'ın accept(T)'si bir değer alır ve bir yan etki uygular, hiçbir şey döndürmez; Supplier'ın get()'i hiçbir girdi almadan bir değer üretir.$$, TRUE, 1),
    ($$Consumer hiçbir girdi olmadan bir değer üretir; Supplier bir değer alıp yan etki uygular.$$, FALSE, 2),
    ($$İkisi de bir değer alıp dönüştürülmüş bir değer döner.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`UnaryOperator<T>` ile `Function<T, T>` arasındaki ilişki nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`UnaryOperator<T>` ile `Function<T, T>` arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$UnaryOperator<T>, Function<T, T>'yi extends eder -- yalnızca okunabilirlik için vardır, girdi ve çıktının aynı tür olduğunu ifade eder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$UnaryOperator<T>, farklı bir abstract metot imzasına sahip, tamamen ilgisiz bir interface'tir.$$, FALSE, 0),
    ($$Function<T, T>, UnaryOperator<T>'yi extends eder.$$, FALSE, 1),
    ($$UnaryOperator<T> yalnızca primitive türlerle kullanılabilir, nesnelerle asla kullanılamaz.$$, FALSE, 2),
    ($$UnaryOperator<T>, Function<T, T>'yi extends eder -- yalnızca okunabilirlik için vardır, girdi ve çıktının aynı tür olduğunu ifade eder.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<String, Integer> ayristir = Integer::parseInt;
        BiFunction<String, String, Boolean> icerirMi = String::contains;
        System.out.println(ayristir.apply("99"));
        System.out.println(icerirMi.apply("merhaba", "hab"));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Ornek {
    public static void main(String[] args) {
        Function<String, Integer> ayristir = Integer::parseInt;
        BiFunction<String, String, Boolean> icerirMi = String::contains;
        System.out.println(ayristir.apply("99"));
        System.out.println(icerirMi.apply("merhaba", "hab"));
    }
}$$, $$java$$,
           $$Integer::parseInt bir Class::staticMethod referansıdır. String::contains ise unbound bir Class::instanceMethod referansıdır -- BiFunction'ın ilk argümanı ("merhaba") receiver olur, ikincisi ("hab") contains'in parametresi olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Derleme hatası -- BiFunction bir method reference kabul edemez.$$, FALSE, 0),
    ($$99
true$$, TRUE, 1),
    ($$Derleme hatası -- String::contains'in bağlanacağı var olan bir String nesnesine ihtiyacı var.$$, FALSE, 2),
    ($$99
false$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        Supplier<List<Integer>> listeUretici = ArrayList::new;
        List<Integer> liste = listeUretici.get();
        liste.add(5);
        liste.add(10);
        System.out.println(liste.size());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        Supplier<List<Integer>> listeUretici = ArrayList::new;
        List<Integer> liste = listeUretici.get();
        liste.add(5);
        liste.add(10);
        System.out.println(liste.size());
    }
}$$, $$java$$,
           $$Class::new bir constructor'ı işaret eder -- burada ArrayList::new bir Supplier<List<Integer>> olarak kullanılır, bu yüzden get() çağrısı her seferinde yeni, boş bir ArrayList oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$0$$, FALSE, 0),
    ($$Derleme hatası -- ArrayList::new bir Supplier'a atanamaz.$$, FALSE, 1),
    ($$UnsupportedOperationException fırlatır.$$, FALSE, 2),
    ($$2$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bound ve unbound method reference'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bound ve unbound method reference'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bound bir referans (object::instanceMethod), belirli, zaten var olan bir nesne üzerindeki bir instance metodunu işaret eder ve o nesneyi yakalar. Unbound bir referans (Class::instanceMethod) ise functional interface'in ilk parametresini metodun receiver'ı, geri kalanını argümanları olarak kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Unbound bir referans, tıpkı bound bir referans gibi, zaten var olan bir nesnenin yakalanmasını gerektirir.$$, FALSE, 0),
    ($$Bound bir referans (object::instanceMethod), belirli, zaten var olan bir nesne üzerindeki bir instance metodunu işaret eder ve o nesneyi yakalar.$$, TRUE, 1),
    ($$Unbound bir referans (Class::instanceMethod), functional interface'in ilk parametresini metodun receiver'ı, geri kalanını ise argümanları olarak kullanır.$$, TRUE, 2),
    ($$Bound ve unbound method reference'lar her zaman aynı hedef-interface imzasına sahiptir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

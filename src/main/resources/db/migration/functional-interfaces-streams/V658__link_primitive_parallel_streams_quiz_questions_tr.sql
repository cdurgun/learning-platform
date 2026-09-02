-- Promotion-style migration linking TR primitive-parallel-streams quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 4).sum());
        System.out.println(IntStream.rangeClosed(1, 4).sum());
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 4).sum());
        System.out.println(IntStream.rangeClosed(1, 4).sum());
    }
}$$, $$java$$,
           $$IntStream.range(baslangic, bitis), bitisi hariç tutar: 1+2+3=6. IntStream.rangeClosed(baslangic, bitis) ise dahil eder: 1+2+3+4=10.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$10
10$$, FALSE, 0),
    ($$6
10$$, TRUE, 1),
    ($$10
6$$, FALSE, 2),
    ($$6
6$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        IntStream bosStream = IntStream.of();
        System.out.println(bosStream.sum());
        OptionalDouble ortalama = IntStream.of().average();
        System.out.println(ortalama.isPresent());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        IntStream bosStream = IntStream.of();
        System.out.println(bosStream.sum());
        OptionalDouble ortalama = IntStream.of().average();
        System.out.println(ortalama.isPresent());
    }
}$$, $$java$$,
           $$sum(), boş bir stream için doğrudan 0 döner. average() ise OptionalDouble döner -- boş bir stream için bu boştur, bu yüzden isPresent() false'tur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$Derleme hatası -- IntStream.of() en az bir argüman gerektirir.$$, FALSE, 0),
    ($$0
true$$, FALSE, 1),
    ($$sum()'da NoSuchElementException fırlatır.$$, FALSE, 2),
    ($$0
false$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> liste = IntStream.rangeClosed(5, 7)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(liste);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> liste = IntStream.rangeClosed(5, 7)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(liste);
    }
}$$, $$java$$,
           $$boxed(), bir IntStream'i doğrudan bir Stream<Integer>'a dönüştürür, her primitive değeri kendi kutulanmış türüne sarar -- collect()/Collectors yalnızca object stream'lerle çalıştığı için burada gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$18$$, FALSE, 0),
    ($$[5, 6, 7]$$, TRUE, 1),
    ($$Derleme hatası -- IntStream bir List<Integer>'a collect edilemez.$$, FALSE, 2),
    ($$[5, 6, 7, 8]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Assosiyatif (associative) bir işlem için, `stream()` yerine `parallelStream()` kullandığında ne değişir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Assosiyatif (associative) bir işlem için, `stream()` yerine `parallelStream()` kullandığında ne değişir?$$,
           NULL, NULL,
           $$Yalnızca çalıştırma stratejisi değişir -- sonuç aynıdır, ama iş ortak ForkJoinPool içinde birden fazla thread'e bölünür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$Elemanlar farklı bir matematiksel sırayla işlendiği için sonuç farklı olur.$$, FALSE, 0),
    ($$parallelStream() yalnızca primitive stream'lerle çalışır, object stream'lerle asla çalışmaz.$$, FALSE, 1),
    ($$parallelStream(), stream()'den farklı olarak her zaman sıralı bir sonuç üretir.$$, FALSE, 2),
    ($$Yalnızca çalıştırma stratejisi değişir -- sonuç aynıdır, ama iş birden fazla thread'e bölünür.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir parallel stream'de, `forEach()` ile `forEachOrdered()` arasındaki temel fark nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir parallel stream'de, `forEach()` ile `forEachOrdered()` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$forEach(), elemanları her thread'in ele geçirdiği sırayla işler, hiçbir sıra garantisi yoktur; forEachOrdered() ise sonucu encounter order'a geri zorlar, ama paralelliğin sağladığı hız avantajının çoğunu kaybettirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$İkisi bir parallel stream'de işlevsel olarak birebir aynıdır.$$, FALSE, 0),
    ($$forEach()'in sıra garantisi yoktur; forEachOrdered() encounter order'ı zorlar, ama paralellik avantajının çoğunu kaybettirir.$$, TRUE, 1),
    ($$forEach() her zaman encounter order'ı korur; forEachOrdered() korumaz.$$, FALSE, 2),
    ($$forEachOrdered(), thread koordinasyonunu atladığı için forEach()'ten daha hızlı çalışır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir parallel `forEach()` içinden düz bir `ArrayList`'e yazmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir parallel `forEach()` içinden düz bir `ArrayList`'e yazmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Hiçbir istisna fırlatmadan, beklenenden daha az eleman sessizce üretebilen gerçek bir data race yaratır. Doğru çözüm, thread-safety'yi içeride kendisi halleden collect(Collectors.toList())'i kullanmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$Doğru çözüm, thread-safety'yi içeride kendisi halleden collect(Collectors.toList())'i kullanmaktır.$$, TRUE, 0),
    ($$Bu hata her tek çalıştırmada birebir aynı şekilde ortaya çıkar, bu da test etmeyi kolaylaştırır.$$, FALSE, 1),
    ($$Java, bir parallel stream'den yapılan ArrayList.add() çağrılarını otomatik olarak senkronize eder.$$, FALSE, 2),
    ($$Hiçbir istisna fırlatmadan, beklenenden daha az eleman sessizce üretebilen gerçek bir data race yaratır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir parallel stream'in kullanmaya değer olması için hangi koşul(lar) sağlanmalıdır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir parallel stream'in kullanmaya değer olması için hangi koşul(lar) sağlanmalıdır?$$,
           NULL, NULL,
           $$Parallel stream'ler, tüm koşullar birlikte sağlandığında karşılığını verir: veri kümesi büyük olmalı, işlem CPU-yoğun olmalı, ve işlem assosiyatif/stateless olmalı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$Parallel stream'ler, elemanlar int ya da long gibi primitive türler olduğunda her zaman kullanılmalıdır.$$, FALSE, 0),
    ($$Veri kümesi büyük olmalı, işlem CPU-yoğun olmalı, ve işlem assosiyatif/stateless olmalı -- üçü birlikte.$$, TRUE, 1),
    ($$İşlemin yan etkisi olmadığı sürece, her veri kümesi boyutu parallelStream()'den fayda görür.$$, FALSE, 2),
    ($$Parallel stream'ler, veri kümesi boyutundan ya da işlem maliyetinden bağımsız olarak her zaman daha hızlıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

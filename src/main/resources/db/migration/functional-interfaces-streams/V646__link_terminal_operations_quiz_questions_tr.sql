-- Promotion-style migration linking TR terminal-operations quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`forEach(Consumer<T>)` neden bir stream pipeline'ını yalnızca sonlandırabilir, asla devam ettiremez?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`forEach(Consumer<T>)` neden bir stream pipeline'ını yalnızca sonlandırabilir, asla devam ettiremez?$$,
           NULL, NULL,
           $$forEach() void döner -- üzerine başka bir operation zincirleyebileceğin bir sonuç yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$Çünkü forEach(), daha fazla zincirlenirse her zaman bir istisna fırlatır.$$, FALSE, 0),
    ($$Çünkü void döner -- üzerine başka bir operation zincirleyebileceğin bir sonuç yoktur.$$, TRUE, 1),
    ($$Çünkü Stream API'deki tek lazy operation'dır.$$, FALSE, 2),
    ($$Çünkü Consumer nesneleri bir çağrıdan sonra yeniden kullanılamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(1, 2, 5);
        int toplam = sayilar.stream().reduce(0, Integer::sum);
        Optional<Integer> carpim = sayilar.stream().reduce((a, b) -> a * b);
        System.out.println(toplam);
        System.out.println(carpim.get());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(1, 2, 5);
        int toplam = sayilar.stream().reduce(0, Integer::sum);
        Optional<Integer> carpim = sayilar.stream().reduce((a, b) -> a * b);
        System.out.println(toplam);
        System.out.println(carpim.get());
    }
}$$, $$java$$,
           $$reduce(identity, accumulator), 0'dan başlayarak her zaman düz bir değer döner: 0+1+2+5=8. reduce(accumulator) ise başlangıç değeri olmadan Optional<T> döner: 1*2*5=10.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$10
8$$, FALSE, 0),
    ($$8
Optional[10]$$, FALSE, 1),
    ($$Derleme hatası -- reduce her zaman bir identity gerektirir.$$, FALSE, 2),
    ($$8
10$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "uzum", "karpuz");
        Optional<String> enUzun = kelimeler.stream().max(Comparator.comparing(String::length));
        System.out.println(enUzun.orElse("yok"));
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
import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "uzum", "karpuz");
        Optional<String> enUzun = kelimeler.stream().max(Comparator.comparing(String::length));
        System.out.println(enUzun.orElse("yok"));
    }
}$$, $$java$$,
           $$max(), bir Comparator gerektirir, çünkü bir stream'in eleman türünün Comparable olacağı garanti edilmez. Uzunluğa göre karşılaştırınca: elma(4), uzum(4), karpuz(6) -- en uzun karpuz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$Derleme hatası -- max(), Comparable elemanlar için argümansız çağrılmalıdır.$$, FALSE, 0),
    ($$karpuz$$, TRUE, 1),
    ($$elma$$, FALSE, 2),
    ($$yok$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Sıralı (sequential) bir stream'de, bu derse göre `findFirst()` ve `findAny()` genellikle nasıl davranır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Sıralı (sequential) bir stream'de, bu derse göre `findFirst()` ve `findAny()` genellikle nasıl davranır?$$,
           NULL, NULL,
           $$Sequential bir stream'de aynı şekilde davranırlar -- aralarındaki fark yalnızca parallel stream'lerde ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$findAny() her zaman findFirst()'ten farklı bir eleman döner.$$, FALSE, 0),
    ($$findFirst(), sequential bir stream'de çağrılırsa istisna fırlatır.$$, FALSE, 1),
    ($$findAny(), sequential stream'lerde hiç kullanılamaz.$$, FALSE, 2),
    ($$Aynı şekilde davranırlar -- aralarındaki fark yalnızca parallel stream'lerde ortaya çıkar.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(3, 6, 9, 12);
        System.out.println(sayilar.stream().allMatch(n -> n % 3 == 0));
        System.out.println(sayilar.stream().anyMatch(n -> n > 10));
        System.out.println(sayilar.stream().noneMatch(n -> n < 0));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(3, 6, 9, 12);
        System.out.println(sayilar.stream().allMatch(n -> n % 3 == 0));
        System.out.println(sayilar.stream().anyMatch(n -> n > 10));
        System.out.println(sayilar.stream().noneMatch(n -> n < 0));
    }
}$$, $$java$$,
           $$allMatch, her elemanın 3'e bölünüp bölünmediğini kontrol eder -- true. anyMatch, en az bir elemanın 10'dan büyük olup olmadığını kontrol eder -- 12 uyar, true. noneMatch, hiçbir elemanın negatif olmadığını kontrol eder -- true.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$true
true
false$$, FALSE, 0),
    ($$true
true
true$$, TRUE, 1),
    ($$true
false
true$$, FALSE, 2),
    ($$false
true
true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("a", "b").stream().toList();
        harfler.add("c");
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("a", "b").stream().toList();
        harfler.add("c");
    }
}$$, $$java$$,
           $$Stream.toList(), collect(Collectors.toList())'in aksine, değiştirilemez (unmodifiable) bir liste döner. Üzerinde add() çağırmak UnsupportedOperationException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$Sorunsuz çalışır ve "c"yi ekler.$$, FALSE, 0),
    ($$Derlenmez.$$, FALSE, 1),
    ($$ConcurrentModificationException fırlatır.$$, FALSE, 2),
    ($$UnsupportedOperationException fırlatır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre `count()`'un davranışı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `count()`'un davranışı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bazı durumlarda JDK, sayıyı doğrudan kaynağın bilinen boyutundan hesaplayabilir ve pipeline'ı hiç çalıştırmayabilir. Bu optimizasyon uygulandığında, pipeline'daki daha önceki bir peek() çağrısı bile hiç tetiklenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$Bu davranış, gelecekteki bir Java sürümünde düzeltilecek bir hatadır.$$, FALSE, 0),
    ($$Bazı durumlarda JDK, sayıyı doğrudan kaynağın bilinen boyutundan hesaplayabilir ve pipeline'ı hiç çalıştırmayabilir.$$, TRUE, 1),
    ($$Bu optimizasyon uygulandığında, pipeline'daki daha önceki bir `peek()` çağrısı bile hiç tetiklenmez.$$, TRUE, 2),
    ($$count(), hiçbir istisna olmadan her zaman pipeline'daki her elemanı işler.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR collectors quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("x", "y").stream().collect(Collectors.toList());
        harfler.add("z");
        System.out.println(harfler);
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("x", "y").stream().collect(Collectors.toList());
        harfler.add("z");
        System.out.println(harfler);
    }
}$$, $$java$$,
           $$Stream.toList()'in aksine, collect(Collectors.toList())'in döndürdüğü liste mutable'dır -- add() sorunsuz çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$Derleme hatası.$$, FALSE, 0),
    ($$[x, y, z]$$, TRUE, 1),
    ($$UnsupportedOperationException fırlatır.$$, FALSE, 2),
    ($$[x, y]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi `Collectors.joining()`'in geçerli bir overload'u DEĞİLDİR?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangisi `Collectors.joining()`'in geçerli bir overload'u DEĞİLDİR?$$,
           NULL, NULL,
           $$Collectors.joining()'in tam olarak üç overload'u vardır: argümansız, bir delimiter, ve bir delimiter ile prefix/suffix. limit alan dört argümanlı bir form yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$Argümansız `joining()`$$, FALSE, 0),
    ($$`joining(delimiter)`$$, FALSE, 1),
    ($$`joining(delimiter, prefix, suffix)`$$, FALSE, 2),
    ($$`joining(delimiter, prefix, suffix, limit)`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "kopek", "araba");
        Map<Character, List<String>> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0)));
        System.out.println(ilkHarfeGore.get('k'));
        System.out.println(ilkHarfeGore.get('a'));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "kopek", "araba");
        Map<Character, List<String>> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0)));
        System.out.println(ilkHarfeGore.get('k'));
        System.out.println(ilkHarfeGore.get('a'));
    }
}$$, $$java$$,
           $$groupingBy(), her elemandan bir anahtar türetir (burada ilk karakter) ve aynı anahtara sahip elemanları bir List'te gruplar, bir Map<K, List<T>> üretir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$Derleme hatası.$$, FALSE, 0),
    ($$[kedi, kus, kopek]
[araba]$$, TRUE, 1),
    ($$[araba]
[kedi, kus, kopek]$$, FALSE, 2),
    ($$[kedi, kus, kopek, araba]
null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "elbise", "uzum", "erik");
        Map<Character, Long> sayimIlkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0), Collectors.counting()));
        System.out.println(sayimIlkHarfeGore.get('e'));
        System.out.println(sayimIlkHarfeGore.get('u'));
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "elbise", "uzum", "erik");
        Map<Character, Long> sayimIlkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0), Collectors.counting()));
        System.out.println(sayimIlkHarfeGore.get('e'));
        System.out.println(sayimIlkHarfeGore.get('u'));
    }
}$$, $$java$$,
           $$Bir downstream collector, her grubun elemanlarına varsayılan List yerine ne olacağını belirler. Collectors.counting(), her grubu doğrudan boyutuna indirger.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$1
3$$, FALSE, 0),
    ($$[elma, elbise, erik]
[uzum]$$, FALSE, 1),
    ($$Derleme hatası -- groupingBy() yalnızca bir argüman kabul eder.$$, FALSE, 2),
    ($$3
1$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Collectors.partitioningBy(predicate)`, garanti edilen map anahtarları açısından `Collectors.groupingBy()`'dan nasıl farklıdır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`Collectors.partitioningBy(predicate)`, garanti edilen map anahtarları açısından `Collectors.groupingBy()`'dan nasıl farklıdır?$$,
           NULL, NULL,
           $$partitioningBy(), bir grup boş olsa bile sonuç Map'inde her zaman hem true hem false anahtarını üretir; groupingBy() ise yalnızca gerçekten eşleşen elemanı olan anahtarları içerir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$İkisi de sonuçta belirli bir anahtar kümesini garanti etmez.$$, FALSE, 0),
    ($$partitioningBy(), bir grup boş olsa bile her zaman hem true hem false anahtarını üretir; groupingBy() yalnızca gerçekten eşleşen elemanı olan anahtarları içerir.$$, TRUE, 1),
    ($$groupingBy(), tıpkı partitioningBy() gibi her zaman tam olarak iki anahtar üretir.$$, FALSE, 2),
    ($$partitioningBy(), tıpkı groupingBy() gibi, bir grup boşsa o anahtarı tamamen atlar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "araba");
        Map<Character, String> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.toMap(k -> k.charAt(0), k -> k));
        System.out.println(ilkHarfeGore);
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "araba");
        Map<Character, String> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.toMap(k -> k.charAt(0), k -> k));
        System.out.println(ilkHarfeGore);
    }
}$$, $$java$$,
           $$Collectors.toMap()'in en sivri noktası: iki farklı eleman aynı anahtarı üretirse, varsayılan olarak IllegalStateException fırlatır. Burada "kedi" ve "kus" ikisi de 'k' anahtarına eşlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$Map yalnızca "kus"u tutar (son kazanır).$$, FALSE, 0),
    ($$Map yalnızca "kedi"yi tutar (ilk kazanır).$$, FALSE, 1),
    ($$Derlenir ama sessizce boş bir map üretir.$$, FALSE, 2),
    ($$IllegalStateException fırlatır, çünkü "kedi" ve "kus" ikisi de 'k' anahtarına eşlenir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `Collector`'ı oluşturan üç fonksiyonu doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir `Collector`'ı oluşturan üç fonksiyonu doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir supplier, sonucu tutacak boş bir konteyner oluşturur, boş bir ArrayList gibi. Bir accumulator, her elemanı o konteynere ekler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$Collectors sınıfındaki her static metot, bu üç fonksiyonu kendi başına tanımlamanı gerektirir.$$, FALSE, 0),
    ($$Bir supplier, sonucu tutacak boş bir konteyner oluşturur, boş bir ArrayList gibi.$$, TRUE, 1),
    ($$Bir accumulator, her elemanı o konteynere ekler.$$, TRUE, 2),
    ($$Bir combiner yalnızca sequential stream'ler için kullanılır, parallel olanlar için asla kullanılmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

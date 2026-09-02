-- Promotion-style migration linking TR stream-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `Stream<T>`'in gerçekte ne olduğunu doğru şekilde tanımlayan ifade hangisidir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir `Stream<T>`'in gerçekte ne olduğunu doğru şekilde tanımlayan ifade hangisidir?$$,
           NULL, NULL,
           $$Bir Stream, bir kaynaktan elemanları sırayla işleyen, tek kullanımlık bir pipeline'dır -- List ya da Set gibi bir veri yapısının aksine, verinin kendisini saklamaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$Bir Collection'ın thread-safe erişim için senkronize edilmiş bir sarmalayıcısıdır.$$, FALSE, 0),
    ($$Bir kaynaktan elemanları sırayla işleyen, tek kullanımlık bir pipeline'dır -- verinin kendisini saklamaz.$$, TRUE, 1),
    ($$List'e benzer, elemanlarını içeride saklayan bir veri yapısıdır.$$, FALSE, 2),
    ($$Ayrı terminal operation'lar aracılığıyla birden fazla kez dolaşılabilen, yeniden kullanılabilir bir pipeline'dır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> isimler = List.of("Ali", "Veli", "Ayse", "Can");
        List<String> sonuc = isimler.stream()
                .filter(i -> i.length() > 3)
                .map(String::toUpperCase)
                .toList();
        System.out.println(sonuc);
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

public class Ornek {
    public static void main(String[] args) {
        List<String> isimler = List.of("Ali", "Veli", "Ayse", "Can");
        List<String> sonuc = isimler.stream()
                .filter(i -> i.length() > 3)
                .map(String::toUpperCase)
                .toList();
        System.out.println(sonuc);
    }
}$$, $$java$$,
           $$filter(), yalnızca koşula uyan elemanları tutar -- Ali(3), Veli(4), Ayse(4), Can(3) arasında yalnızca "Veli" ve "Ayse"nin uzunluğu 3'ten büyüktür. map() ise hayatta kalan elemanları büyük harfe dönüştürür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[ALI, VELI, AYSE, CAN]$$, FALSE, 0),
    ($$[]$$, FALSE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$[VELI, AYSE]$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<List<String>> icIce = List.of(List.of("a", "b"), List.of("c"), List.of("d", "e"));
        List<String> duz = icIce.stream()
                .flatMap(List::stream)
                .collect(Collectors.toList());
        System.out.println(duz);
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
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<List<String>> icIce = List.of(List.of("a", "b"), List.of("c"), List.of("d", "e"));
        List<String> duz = icIce.stream()
                .flatMap(List::stream)
                .collect(Collectors.toList());
        System.out.println(duz);
    }
}$$, $$java$$,
           $$flatMap(), her iç List'i bir stream'e dönüştürür ve bu stream'leri tek, düz bir stream'de birleştirir; map()'in üreteceği "stream'lerin stream'i" sorununu önler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[a, b, c, d, e]$$, TRUE, 1),
    ($$[[a, b], [c], [d, e]]$$, FALSE, 2),
    ($$[a, b]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`distinct()`, iki stream elemanının birbirinin yinelenen kopyası olup olmadığını neye göre belirler?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`distinct()`, iki stream elemanının birbirinin yinelenen kopyası olup olmadığını neye göre belirler?$$,
           NULL, NULL,
           $$distinct(), yinelenen elemanları equals()'e göre kaldırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$Yalnızca `==` referans eşitliği$$, FALSE, 0),
    ($$equals() çağırmadan yalnızca `hashCode()`$$, FALSE, 1),
    ($$Comparable'dan gelen `compareTo()`$$, FALSE, 2),
    ($$`equals()`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("a", "b", "c", "d", "e", "f");
        List<String> sayfa = harfler.stream()
                .skip(3)
                .limit(2)
                .toList();
        System.out.println(sayfa);
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("a", "b", "c", "d", "e", "f");
        List<String> sayfa = harfler.stream()
                .skip(3)
                .limit(2)
                .toList();
        System.out.println(sayfa);
    }
}$$, $$java$$,
           $$skip(3), ilk üç elemanı atar, [d, e, f] kalır. limit(2) ise bunların yalnızca ilk ikisini tutar: [d, e].$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[c, d]$$, FALSE, 0),
    ($$[d, e]$$, TRUE, 1),
    ($$[a, b]$$, FALSE, 2),
    ($$[e, f]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`filter()` ve `map()` gibi intermediate operation'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`filter()` ve `map()` gibi intermediate operation'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Intermediate operation'lar lazy'dir -- çağrılmaları henüz hiçbir şey çalıştırmaz, yalnızca pipeline'ın tanımına bir adım ekler. Gerçek iş ancak bir terminal operation çağrıldığında başlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$Gerçek iş ancak bir terminal operation çağrıldığında başlar.$$, TRUE, 0),
    ($$Her intermediate operation, bir sonraki operation başlamadan önce tüm kaynak koleksiyonu tamamen işler.$$, FALSE, 1),
    ($$Bir intermediate operation void döner, bu yüzden daha fazla zincirlenemez.$$, FALSE, 2),
    ($$Lazy'dirler -- çağrılmaları henüz hiçbir şey çalıştırmaz, yalnızca pipeline'ın tanımına bir adım ekler.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Stream;

public class Ornek {
    public static void main(String[] args) {
        Stream<Integer> stream = List.of(1, 2, 3).stream();
        long adet = stream.count();
        System.out.println(adet);
        stream.forEach(System.out::println);
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.List;
import java.util.stream.Stream;

public class Ornek {
    public static void main(String[] args) {
        Stream<Integer> stream = List.of(1, 2, 3).stream();
        long adet = stream.count();
        System.out.println(adet);
        stream.forEach(System.out::println);
    }
}$$, $$java$$,
           $$Bir stream tek kullanımlıktır: count() gibi bir terminal operation çalıştığında stream kapanır, aynı stream referansını yeniden kullanmaya çalışmak IllegalStateException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$3 yazdırır ve ikinci çağrıda sessizce hiçbir şey yapmaz.$$, FALSE, 0),
    ($$3 yazdırır, sonra ikinci kullanımda IllegalStateException fırlatır.$$, TRUE, 1),
    ($$3, sonra 1, 2, 3 yazdırır.$$, FALSE, 2),
    ($$Derlenmez -- bir Stream referansı sözdizimsel olarak bile yeniden kullanılamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

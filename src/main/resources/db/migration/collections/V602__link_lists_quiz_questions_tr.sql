-- Promotion-style migration linking TR lists quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<Integer> sayilar = new ArrayList<>(List.of(5, 15, 25, 35));
sayilar.remove(1);
System.out.println(sayilar);$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> sayilar = new ArrayList<>(List.of(5, 15, 25, 35));
sayilar.remove(1);
System.out.println(sayilar);$$, $$java$$,
           $$Bir List<Integer> üzerinde remove(1), int overload'ı olan remove(int index)'e çözümlenir, remove(Object)'e değil -- 1 burada otomatik kutulanmaz, bu yüzden index 1'deki eleman (değer 15) silinir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$[15, 25, 35]$$, FALSE, 0),
    ($$[5, 25, 35]$$, TRUE, 1),
    ($$[5, 15, 25, 35]$$, FALSE, 2),
    ($$Derleme hatası -- çağrı belirsizdir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ArrayList`'in başına (index 0) eleman eklemenin karmaşıklığı ile `LinkedList`'in başına eklemenin karmaşıklığı için hangisi doğrudur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`ArrayList`'in başına (index 0) eleman eklemenin karmaşıklığı ile `LinkedList`'in başına eklemenin karmaşıklığı için hangisi doğrudur?$$,
           NULL, NULL,
           $$ArrayList'in başına eleman eklemek, sonraki tüm elemanları bir sağa kaydırmayı gerektirir -- O(n). LinkedList'in başına eklemek ise sadece birkaç referansı güncellemektir -- O(1).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$ArrayList O(1)'dir, LinkedList O(n)'dir.$$, FALSE, 0),
    ($$İkisi de O(1)'dir.$$, FALSE, 1),
    ($$İkisi de O(n)'dir.$$, FALSE, 2),
    ($$ArrayList O(n)'dir (sonraki elemanları kaydırmak gerekir), LinkedList O(1)'dir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java'nın immutable liste araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Java'nın immutable liste araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$List.of(...) sıfırdan değiştirilemez yeni bir liste oluşturur. Collections.unmodifiableList(list), var olan bir listenin değiştirilemez bir GÖRÜNÜMÜNÜ döner -- orijinal değişirse görünüm de değişir. List.copyOf(list) ise tamamen bağımsız, ayrı bir immutable kopya oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$Collections.unmodifiableList(list), orijinaldeki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, FALSE, 0),
    ($$List.of(...) sıfırdan değiştirilemez yeni bir liste oluşturur.$$, TRUE, 1),
    ($$Collections.unmodifiableList(list) bir görünüm döner -- orijinal liste değişirse bu da değişir.$$, TRUE, 2),
    ($$List.copyOf(list), orijinale bağlı bir görünüm döner.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$List<String> renkler = new ArrayList<>(List.of("kirmizi", "mavi", "yesil"));
for (String renk : renkler) {
    if (renk.equals("mavi")) {
        renkler.remove(renk);
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$List<String> renkler = new ArrayList<>(List.of("kirmizi", "mavi", "yesil"));
for (String renk : renkler) {
    if (renk.equals("mavi")) {
        renkler.remove(renk);
    }
}$$, $$java$$,
           $$for-each döngüsü arka planda bir Iterator kullanır. Dolaşırken listenin üzerinde doğrudan List.remove() çağırmak ConcurrentModificationException fırlatır, çünkü Iterator listenin "beklenmedik" şekilde değiştiğini fark eder.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$Sorunsuz çalışır ve renkler [kirmizi, yesil] olur.$$, FALSE, 0),
    ($$Sorunsuz çalışır ve renkler değişmez: [kirmizi, mavi, yesil].$$, FALSE, 1),
    ($$IndexOutOfBoundsException fırlatır.$$, FALSE, 2),
    ($$ConcurrentModificationException fırlatır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<String> kelimeler = new ArrayList<>(List.of("elma", "kivi", "uzum", "armut"));
kelimeler.sort(Comparator.comparing(String::length).thenComparing(Comparator.naturalOrder()));
System.out.println(kelimeler);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> kelimeler = new ArrayList<>(List.of("elma", "kivi", "uzum", "armut"));
kelimeler.sort(Comparator.comparing(String::length).thenComparing(Comparator.naturalOrder()));
System.out.println(kelimeler);$$, $$java$$,
           $$Önce uzunluğa göre karşılaştırılır: elma/kivi/uzum 4 harf, armut 5 harf -- armut her zaman son sırada olur. Üç eş-uzunluklu kelime arasında thenComparing devreye girer ve doğal (alfabetik) sıraya göre ayırır: elma < kivi < uzum.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$[kivi, elma, uzum, armut]$$, FALSE, 0),
    ($$[elma, kivi, uzum, armut]$$, TRUE, 1),
    ($$[armut, elma, kivi, uzum]$$, FALSE, 2),
    ($$[elma, armut, kivi, uzum]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<String> harfler = new ArrayList<>(List.of("a", "b", "c", "d", "e"));
List<String> altListe = harfler.subList(1, 3);
altListe.clear();
System.out.println(harfler);$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> harfler = new ArrayList<>(List.of("a", "b", "c", "d", "e"));
List<String> altListe = harfler.subList(1, 3);
altListe.clear();
System.out.println(harfler);$$, $$java$$,
           $$subList(from, to), orijinal listenin bağımsız bir kopyası değil, bir GÖRÜNÜMÜDÜR. Görünüm üzerinde clear() çağırmak, orijinal listedeki o aralığı da (index 1-2: "b", "c") siler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$[a, b, c, d, e]$$, FALSE, 0),
    ($$[b, c]$$, FALSE, 1),
    ($$UnsupportedOperationException fırlatır.$$, FALSE, 2),
    ($$[a, d, e]$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lists')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `List<String>` üzerinde çağrılan hangi `toArray()` kullanımı doğru şekilde bir `Object[]` yerine bir `String[]` üretir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir `List<String>` üzerinde çağrılan hangi `toArray()` kullanımı doğru şekilde bir `Object[]` yerine bir `String[]` üretir?$$,
           NULL, NULL,
           $$Argümansız toArray(), tip bilgisini kaybeden bir Object[] döner; toArray(new String[0]) (ya da Java 11+'ta toArray(String[]::new)) ise doğru tipte bir dizi üretir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lists'
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
    ($$list.toArray(Object.class)$$, FALSE, 0),
    ($$list.toArray(new String[0])$$, TRUE, 1),
    ($$list.toArray()$$, FALSE, 2),
    ($$(String[]) list.toArray()$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lists'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR maps quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Map` ile `Collection` arasındaki ilişki için hangisi doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`Map` ile `Collection` arasındaki ilişki için hangisi doğrudur?$$,
           NULL, NULL,
           $$Map, Collection'ı genişletmez -- Collections Framework'ün ayrı bir dalıdır, çünkü Iterable<E> yerine iki parametreli bir yapıya (Map<K,V>) ihtiyaç duyar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$Collection, Map'i genişletir.$$, FALSE, 0),
    ($$Map, Collection'ı GENİŞLETMEZ -- Collections Framework'ün ayrı bir dalıdır.$$, TRUE, 1),
    ($$Map, tıpkı List ve Set gibi Collection'ı genişletir.$$, FALSE, 2),
    ($$Map, anahtarlar benzersiz olduğu için Set'i genişletir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Map<String, String> baskentler = new HashMap<>();
baskentler.put("Turkiye", "Ankara");
String baskent = baskentler.get("Almanya");
System.out.println(baskent);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<String, String> baskentler = new HashMap<>();
baskentler.put("Turkiye", "Ankara");
String baskent = baskentler.get("Almanya");
System.out.println(baskent);$$, $$java$$,
           $$get(key), anahtar yoksa null döner -- istisna fırlatmaz. "Almanya" hiç put edilmediği için baskent null olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$NoSuchElementException fırlatır.$$, FALSE, 0),
    ($$"" (boş string)$$, FALSE, 1),
    ($$NullPointerException fırlatır.$$, FALSE, 2),
    ($$null$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hem anahtara hem değere ihtiyaç duyduğunda bir `Map`'i dolaşmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Hem anahtara hem değere ihtiyaç duyduğunda bir `Map`'i dolaşmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$keySet() üzerinde dolaşıp her adımda get(key) çağırmak gereksiz bir ikinci arama yapar. entrySet(), anahtarı ve değeri tek bir adımda, tek bir aramayla verir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$entrySet(), bir for-each döngüsüyle kullanılamaz.$$, FALSE, 0),
    ($$keySet() üzerinde dolaşıp her adımda get(key) çağırmak gereksiz bir ikinci arama yapar.$$, TRUE, 1),
    ($$entrySet(), anahtarı ve değeri tek bir adımda, tek bir aramayla verir.$$, TRUE, 2),
    ($$keySet() + get(), keySet() daha küçük bir koleksiyon olduğu için her zaman entrySet()'ten daha hızlıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Map<String, Integer> harita = new LinkedHashMap<>();
harita.put("z", 1);
harita.put("a", 2);
harita.put("m", 3);
System.out.println(harita.keySet());$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<String, Integer> harita = new LinkedHashMap<>();
harita.put("z", 1);
harita.put("a", 2);
harita.put("m", 3);
System.out.println(harita.keySet());$$, $$java$$,
           $$LinkedHashMap, HashMap'in tüm davranışını korur ve üzerine eklenme sırasını hatırlayan bir bağlı liste ekler -- bu yüzden anahtarlar eklenme sırasıyla yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$[a, m, z]$$, FALSE, 0),
    ($$[m, a, z]$$, FALSE, 1),
    ($$Çalıştırmalar arasında değişebilen, öngörülemez bir sıra.$$, FALSE, 2),
    ($$[z, a, m]$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java'nın immutable `Map` araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Java'nın immutable `Map` araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Collections.unmodifiableMap(map) bir görünüm döner -- orijinal map değişirse görünüm de değişir. Map.copyOf(map), orijinaldeki sonraki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$Map.copyOf(map), orijinale bağlı bir görünüm döner.$$, FALSE, 0),
    ($$Collections.unmodifiableMap(map) bir görünüm döner -- orijinal map değişirse bu da değişir.$$, TRUE, 1),
    ($$Map.copyOf(map), orijinaldeki sonraki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, TRUE, 2),
    ($$Map.of(...), başka bir alternatife hiç gerek kalmadan sınırsız sayıda anahtar-değer çifti tutabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Map<Integer, List<String>> gruplar = new HashMap<>();
String[] kelimeler = {"elma", "armut", "kiraz", "uzum"};
for (String k : kelimeler) {
    gruplar.computeIfAbsent(k.length(), key -> new ArrayList<>()).add(k);
}
System.out.println(gruplar.get(4));$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<Integer, List<String>> gruplar = new HashMap<>();
String[] kelimeler = {"elma", "armut", "kiraz", "uzum"};
for (String k : kelimeler) {
    gruplar.computeIfAbsent(k.length(), key -> new ArrayList<>()).add(k);
}
System.out.println(gruplar.get(4));$$, $$java$$,
           $$computeIfAbsent(), anahtar yoksa yeni bir konteyner oluşturur -- klasik gruplama deseni. "elma" ve "uzum" 4 harflidir, "armut" ve "kiraz" 5 harflidir, bu yüzden 4 anahtarının değeri [elma, uzum] olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$[armut, kiraz]$$, FALSE, 0),
    ($$null$$, FALSE, 1),
    ($$[elma, armut, kiraz, uzum]$$, FALSE, 2),
    ($$[elma, uzum]$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'maps')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Kod {
    int deger;
    Kod(int deger) { this.deger = deger; }
}

Map<Kod, String> harita = new HashMap<>();
harita.put(new Kod(5), "birinci");
harita.put(new Kod(5), "ikinci");
System.out.println(harita.size());$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Kod {
    int deger;
    Kod(int deger) { this.deger = deger; }
}

Map<Kod, String> harita = new HashMap<>();
harita.put(new Kod(5), "birinci");
harita.put(new Kod(5), "ikinci");
System.out.println(harita.size());$$, $$java$$,
           $$Kod, equals()/hashCode()'u override etmez, bu yüzden HashMap iki Kod instance'ını farklı anahtarlar sayar (farklı referanslar), deger alanı aynı olsa bile -- her iki giriş de ayrı ayrı eklenir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'maps'
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
    ($$Derleme hatası.$$, FALSE, 0),
    ($$2$$, TRUE, 1),
    ($$1$$, FALSE, 2),
    ($$0$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'maps'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion-style migration linking TR sets quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `Set`'te zaten bulunan bir elemana eşit bir eleman için `add(x)` çağrıldığında ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir `Set`'te zaten bulunan bir elemana eşit bir eleman için `add(x)` çağrıldığında ne olur?$$,
           NULL, NULL,
           $$add(), zaten var olan bir elemanı eklemeye çalışırsan sessizce false döner (istisna fırlatmaz) -- set'in kendisi değişmeden kalır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$IllegalStateException fırlatır.$$, FALSE, 0),
    ($$false döner ve set değişmez -- hiçbir istisna fırlatılmaz.$$, TRUE, 1),
    ($$IllegalArgumentException fırlatır.$$, FALSE, 2),
    ($$Var olan elemanı değiştirir ve true döner.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`HashSet`'in dolaşma (iteration) sırası için hangisi doğrudur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`HashSet`'in dolaşma (iteration) sırası için hangisi doğrudur?$$,
           NULL, NULL,
           $$HashSet'in dolaşma sırası, elemanların eklenme sırasıyla ilgisizdir -- iç hash tablosundaki konumlarına göre belirlenir ve bu sıra JDK sürümüne, hatta çalışma zamanına göre değişebilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$Her zaman LinkedHashSet gibi eklenme sırasıyla aynıdır.$$, FALSE, 0),
    ($$Her zaman doğal sıraya göre sıralıdır.$$, FALSE, 1),
    ($$Her zaman ters eklenme sırasıdır.$$, FALSE, 2),
    ($$Eklenme sırasıyla ilgisizdir, iç hash tablosundaki konumlara göre belirlenir ve JDK sürümüne ya da çalışma zamanına göre değişebilir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Set<String> sirali = new LinkedHashSet<>();
sirali.add("kedi");
sirali.add("kus");
sirali.add("balik");
sirali.add("kedi");
System.out.println(sirali);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Set<String> sirali = new LinkedHashSet<>();
sirali.add("kedi");
sirali.add("kus");
sirali.add("balik");
sirali.add("kedi");
System.out.println(sirali);$$, $$java$$,
           $$LinkedHashSet, HashSet'in tüm davranışını korur (yinelenenler sessizce yok sayılır) ve üzerine eklenme sırasını hatırlayan bir bağlı liste ekler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$[kus, kedi, balik]$$, FALSE, 0),
    ($$[kedi, kus, balik]$$, TRUE, 1),
    ($$[balik, kedi, kus]$$, FALSE, 2),
    ($$[kedi, kus, balik, kedi]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$TreeSet<Integer> kume = new TreeSet<>(Set.of(7, 3, 9, 1, 5));
System.out.println(kume);
System.out.println(kume.floor(6));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$TreeSet<Integer> kume = new TreeSet<>(Set.of(7, 3, 9, 1, 5));
System.out.println(kume);
System.out.println(kume.floor(6));$$, $$java$$,
           $$TreeSet, elemanları eklenme sırasından bağımsız olarak her zaman sıralı tutar: [1, 3, 5, 7, 9]. floor(6), 6'ya eşit ya da 6'dan küçük en büyük elemanı döner, bu da 5'tir (6 kümede yok).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$[7, 3, 9, 1, 5]
5$$, FALSE, 0),
    ($$[1, 3, 5, 7, 9]
7$$, FALSE, 1),
    ($$[1, 3, 5, 7, 9]
6$$, FALSE, 2),
    ($$[1, 3, 5, 7, 9]
5$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Nokta {
    int x, y;
    Nokta(int x, int y) { this.x = x; this.y = y; }
}

Set<Nokta> noktalar = new HashSet<>();
noktalar.add(new Nokta(3, 4));
noktalar.add(new Nokta(3, 4));
System.out.println(noktalar.size());$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Nokta {
    int x, y;
    Nokta(int x, int y) { this.x = x; this.y = y; }
}

Set<Nokta> noktalar = new HashSet<>();
noktalar.add(new Nokta(3, 4));
noktalar.add(new Nokta(3, 4));
System.out.println(noktalar.size());$$, $$java$$,
           $$Nokta, equals()/hashCode()'u override etmez, bu yüzden Object'in varsayılanı kullanılır -- "eşitlik" yalnızca aynı referans (==) anlamına gelir. İki Nokta instance'ı farklı nesnelerdir, bu yüzden HashSet onları farklı eleman sayar ve ikisini de ekler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$0$$, FALSE, 0),
    ($$2$$, TRUE, 1),
    ($$1$$, FALSE, 2),
    ($$Derleme hatası.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Set<Integer> a = new HashSet<>(Set.of(10, 20, 30, 40));
Set<Integer> b = new HashSet<>(Set.of(30, 40));
a.removeAll(b);
System.out.println(a.size());$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Set<Integer> a = new HashSet<>(Set.of(10, 20, 30, 40));
Set<Integer> b = new HashSet<>(Set.of(30, 40));
a.removeAll(b);
System.out.println(a.size());$$, $$java$$,
           $$removeAll(), fark (difference) hesaplar -- diğer kümede olanları çıkarır. {10,20,30,40}'tan {30,40} çıkarılınca {10,20} kalır, bu yüzden a.size() 2'dir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$4$$, FALSE, 0),
    ($$0$$, FALSE, 1),
    ($$6$$, FALSE, 2),
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
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sets')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Dolaşma sırası önemli değilse HashSet en hızlı seçenektir. TreeSet'in add()/contains()/remove() işlemleri O(log n)'dir, HashSet'in O(1)'inden daha yavaştır -- bu yüzden yalnızca sıralı dolaşmaya gerçekten ihtiyaç varsa tercih edilmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sets'
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
    ($$LinkedHashSet, elemanları her zaman sıralı tuttuğu için add()/contains()'te HashSet'ten daha yavaştır.$$, FALSE, 0),
    ($$Dolaşma sırası önemli değilse HashSet en hızlı seçenektir.$$, TRUE, 1),
    ($$TreeSet'in add()/contains()/remove() işlemleri O(log n)'dir, HashSet'in O(1)'inden daha yavaştır.$$, TRUE, 2),
    ($$Sıralı dolaşmaya ihtiyaç olmasa bile TreeSet varsayılan seçim olmalıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sets'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

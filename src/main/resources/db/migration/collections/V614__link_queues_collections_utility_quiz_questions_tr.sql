-- Promotion-style migration linking TR queues-collections-utility quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$Queue<String> kuyruk = new ArrayDeque<>();
System.out.println(kuyruk.poll());
System.out.println(kuyruk.peek());
kuyruk.element();$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$Queue<String> kuyruk = new ArrayDeque<>();
System.out.println(kuyruk.poll());
System.out.println(kuyruk.peek());
kuyruk.element();$$, $$java$$,
           $$Her Queue işlemi için iki paralel metot vardır: biri başarısızlıkta istisna fırlatır (add/remove/element), diğeri özel bir değer döner (offer/poll/peek). Boş bir kuyrukta poll() ve peek() null döner, ama element() NoSuchElementException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$null, null yazdırır, sonra NoSuchElementException fırlatır.$$, TRUE, 1),
    ($$kuyruk.poll()'da hemen NoSuchElementException fırlatır.$$, FALSE, 2),
    ($$İstisna olmadan null, null, null yazdırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Deque<String> yigin = new ArrayDeque<>();
yigin.push("bir");
yigin.push("iki");
yigin.push("uc");
System.out.println(yigin.pop());
System.out.println(yigin.pop());$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Deque<String> yigin = new ArrayDeque<>();
yigin.push("bir");
yigin.push("iki");
yigin.push("uc");
System.out.println(yigin.pop());
System.out.println(yigin.pop());$$, $$java$$,
           $$Deque, push()/pop() ile bir yığın (LIFO) gibi kullanılabilir. "bir", "iki", "uc" sırasıyla push edildiğinde, pop() önce "uc"yü, sonra "iki"yi döner -- en son push edilen eleman ilk çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$bir
iki$$, FALSE, 0),
    ($$uc
bir$$, FALSE, 1),
    ($$bir
uc$$, FALSE, 2),
    ($$uc
iki$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `java.util.Stack` sınıfının kendi javadoc'u neden onun yerine `Deque`/`ArrayDeque` kullanılmasını önerir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `java.util.Stack` sınıfının kendi javadoc'u neden onun yerine `Deque`/`ArrayDeque` kullanılmasını önerir?$$,
           NULL, NULL,
           $$Stack, Vector'ı genişletir, bu yüzden gereksiz senkronizasyon yükünü ve bir yığın kavramına uymayan index tabanlı metotları (insertElementAt() gibi) miras alır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$Çünkü Stack resmi olarak deprecated'dır ve artık derlenmez.$$, FALSE, 0),
    ($$Çünkü Stack, Vector'ı genişletir ve bu yüzden gereksiz senkronizasyon yükünü ve bir yığın kavramına uymayan index tabanlı metotları miras alır.$$, TRUE, 1),
    ($$Çünkü Stack generic'lerle kullanılamaz.$$, FALSE, 2),
    ($$Çünkü Stack push()/pop()'u hiç desteklemez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre `ArrayDeque` ile `LinkedList` performansı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `ArrayDeque` ile `LinkedList` performansı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Aynı Deque işlemleri için ikisi de teorik olarak O(1)'dir, ama sabit faktörleri farklıdır: LinkedList her eleman için ayrı bir node nesnesi tahsis eder, ArrayDeque dairesel bir dizi kullanarak bu ek yükten kaçınır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$LinkedList her eleman için ayrı bir node nesnesi tahsis eder, ArrayDeque bundan kaçınır.$$, TRUE, 0),
    ($$Dersin ölçümünde LinkedList her tek çalıştırmada ArrayDeque'dan daha hızlı ölçüldü.$$, FALSE, 1),
    ($$ArrayDeque yalnızca Queue olarak kullanılabilir, Deque olarak kullanılamaz.$$, FALSE, 2),
    ($$Aynı Deque işlemleri için ikisi de teorik olarak O(1)'dir, ama sabit faktörleri farklıdır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Queue<Integer> oncelikliKuyruk = new PriorityQueue<>();
oncelikliKuyruk.add(15);
oncelikliKuyruk.add(5);
oncelikliKuyruk.add(10);
System.out.println(oncelikliKuyruk);
System.out.println(oncelikliKuyruk.poll());$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Queue<Integer> oncelikliKuyruk = new PriorityQueue<>();
oncelikliKuyruk.add(15);
oncelikliKuyruk.add(5);
oncelikliKuyruk.add(10);
System.out.println(oncelikliKuyruk);
System.out.println(oncelikliKuyruk.poll());$$, $$java$$,
           $$PriorityQueue içeride bir heap kullanır -- yalnızca kökün en küçük olması garantidir. Doğrudan yazdırmak sıralı sırayı GÖSTERMEZ; yalnızca poll() en küçük elemanı döndürmeyi garanti eder. Burada iç heap dizisi [5, 15, 10] olarak sonuçlanır, poll() ise doğru şekilde 5'i döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$[5, 15, 10]
15$$, FALSE, 0),
    ($$[5, 15, 10]
5$$, TRUE, 1),
    ($$[5, 10, 15]
5$$, FALSE, 2),
    ($$[15, 5, 10]
5$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<Integer> sayilar = new ArrayList<>(List.of(9, 2, 9, 4, 9));
Collections.sort(sayilar);
System.out.println(sayilar);
System.out.println(Collections.frequency(sayilar, 9));
System.out.println(Collections.min(sayilar));$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> sayilar = new ArrayList<>(List.of(9, 2, 9, 4, 9));
Collections.sort(sayilar);
System.out.println(sayilar);
System.out.println(Collections.frequency(sayilar, 9));
System.out.println(Collections.min(sayilar));$$, $$java$$,
           $$Collections.sort(), yerinde sıralar: [2, 4, 9, 9, 9]. Collections.frequency(), 9'un kaç kez geçtiğini sayar (3 kez). Collections.min(), en küçük elemanı bulur (2).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$[9, 2, 9, 4, 9]
3
2$$, FALSE, 0),
    ($$[2, 4, 9, 9, 9]
2
2$$, FALSE, 1),
    ($$[2, 4, 9, 9, 9]
3
9$$, FALSE, 2),
    ($$[2, 4, 9, 9, 9]
3
2$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'queues-collections-utility')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Collections.binarySearch()`, SIRALANMAMIŞ bir liste üzerinde çağrıldığında ne olur?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`Collections.binarySearch()`, SIRALANMAMIŞ bir liste üzerinde çağrıldığında ne olur?$$,
           NULL, NULL,
           $$Collections.binarySearch()'ün doğru çalışması için listenin önceden sıralanmış olması şarttır -- sıralanmamış bir listede çağırmak istisna fırlatmaz ama yanlış bir sonuç döner, sessiz bir hata.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'queues-collections-utility'
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
    ($$Eleman var olsa da olmasa da her zaman -1 döner.$$, FALSE, 0),
    ($$İstisna fırlatmaz, ama yanlış bir sonuç dönebilir -- sessiz bir hata.$$, TRUE, 1),
    ($$Hemen IllegalStateException fırlatır.$$, FALSE, 2),
    ($$Önce listeyi otomatik olarak sıralar, sonra arar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'queues-collections-utility'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Promotion batch
-- Topic: queues-collections-utility (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V574-V594 (generics) and V553-V569 (exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/queues-collections-utility.md and content/tr/queues-collections-utility.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first) -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
-- Here the rotation is applied directly during authoring, not as a follow-up fix.
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$Queue<Integer> queue = new ArrayDeque<>();
System.out.println(queue.poll());
System.out.println(queue.peek());
queue.remove();$$, $$java$$,
           $$Every Queue operation has two parallel methods: one throws an exception on failure (add/remove/element), the other returns a special value (offer/poll/peek). On an empty queue, poll() and peek() return null, but remove() throws NoSuchElementException.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Prints null, then null, then throws NoSuchElementException.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Throws NoSuchElementException immediately at queue.poll().$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Prints null, null, null with no exception.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$Queue<String> kuyruk = new ArrayDeque<>();
System.out.println(kuyruk.poll());
System.out.println(kuyruk.peek());
kuyruk.element();$$, $$java$$,
           $$Her Queue işlemi için iki paralel metot vardır: biri başarısızlıkta istisna fırlatır (add/remove/element), diğeri özel bir değer döner (offer/poll/peek). Boş bir kuyrukta poll() ve peek() null döner, ama element() NoSuchElementException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$null, null yazdırır, sonra NoSuchElementException fırlatır.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$kuyruk.poll()'da hemen NoSuchElementException fırlatır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İstisna olmadan null, null, null yazdırır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Deque<Integer> stack = new ArrayDeque<>();
stack.push(1);
stack.push(2);
stack.push(3);
System.out.println(stack.pop());
System.out.println(stack.pop());$$, $$java$$,
           $$Deque can be used as a stack (LIFO) via push()/pop(). Pushing 1, 2, 3 in that order means pop() returns 3 first, then 2 -- the most recently pushed element comes out first.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$3
1$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$1
3$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$3
2$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$1
2$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Deque<String> yigin = new ArrayDeque<>();
yigin.push("bir");
yigin.push("iki");
yigin.push("uc");
System.out.println(yigin.pop());
System.out.println(yigin.pop());$$, $$java$$,
           $$Deque, push()/pop() ile bir yığın (LIFO) gibi kullanılabilir. "bir", "iki", "uc" sırasıyla push edildiğinde, pop() önce "uc"yü, sonra "iki"yi döner -- en son push edilen eleman ilk çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$bir
iki$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$uc
bir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$bir
uc$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$uc
iki$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why does `java.util.Stack`'s own javadoc recommend using `Deque`/`ArrayDeque` instead?$$,
           NULL, NULL,
           $$Stack extends Vector, which means it inherits unnecessary synchronization overhead and index-based methods that don't fit the concept of a stack (like insertElementAt()).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Stack extends Vector, inheriting unnecessary synchronization overhead and index-based methods that don't fit a stack.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because Stack cannot be used with generics.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because Stack doesn't support push()/pop() at all.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because Stack has been formally deprecated and no longer compiles.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `java.util.Stack` sınıfının kendi javadoc'u neden onun yerine `Deque`/`ArrayDeque` kullanılmasını önerir?$$,
           NULL, NULL,
           $$Stack, Vector'ı genişletir, bu yüzden gereksiz senkronizasyon yükünü ve bir yığın kavramına uymayan index tabanlı metotları (insertElementAt() gibi) miras alır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Stack resmi olarak deprecated'dır ve artık derlenmez.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü Stack, Vector'ı genişletir ve bu yüzden gereksiz senkronizasyon yükünü ve bir yığın kavramına uymayan index tabanlı metotları miras alır.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü Stack generic'lerle kullanılamaz.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü Stack push()/pop()'u hiç desteklemez.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `ArrayDeque` vs. `LinkedList` performance, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Both are theoretically O(1) for the same Deque operations, but their constant factors differ: LinkedList allocates a separate node object for every element, while ArrayDeque uses a circular array and avoids that overhead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$LinkedList was measured faster than ArrayDeque in every single run of the lesson's benchmark.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$ArrayDeque cannot be used as a Deque, only as a Queue.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Both are theoretically O(1) for the same Deque operations, but their constant factors differ.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$LinkedList allocates a separate node object for every element, which ArrayDeque avoids.$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `ArrayDeque` ile `LinkedList` performansı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Aynı Deque işlemleri için ikisi de teorik olarak O(1)'dir, ama sabit faktörleri farklıdır: LinkedList her eleman için ayrı bir node nesnesi tahsis eder, ArrayDeque dairesel bir dizi kullanarak bu ek yükten kaçınır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$LinkedList her eleman için ayrı bir node nesnesi tahsis eder, ArrayDeque bundan kaçınır.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Dersin ölçümünde LinkedList her tek çalıştırmada ArrayDeque'dan daha hızlı ölçüldü.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$ArrayDeque yalnızca Queue olarak kullanılabilir, Deque olarak kullanılamaz.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Aynı Deque işlemleri için ikisi de teorik olarak O(1)'dir, ama sabit faktörleri farklıdır.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Queue<Integer> pq = new PriorityQueue<>();
pq.add(30);
pq.add(10);
pq.add(20);
System.out.println(pq);
System.out.println(pq.poll());$$, $$java$$,
           $$PriorityQueue uses a heap internally -- only the root is guaranteed to be the smallest. Printing it directly does NOT show sorted order; only poll() guarantees returning the smallest element. Here the internal heap array ends up as [10, 30, 20], and poll() correctly returns 10.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[10, 30, 20]
10$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$[10, 20, 30]
10$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$[30, 10, 20]
10$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$[10, 30, 20]
30$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Queue<Integer> oncelikliKuyruk = new PriorityQueue<>();
oncelikliKuyruk.add(15);
oncelikliKuyruk.add(5);
oncelikliKuyruk.add(10);
System.out.println(oncelikliKuyruk);
System.out.println(oncelikliKuyruk.poll());$$, $$java$$,
           $$PriorityQueue içeride bir heap kullanır -- yalnızca kökün en küçük olması garantidir. Doğrudan yazdırmak sıralı sırayı GÖSTERMEZ; yalnızca poll() en küçük elemanı döndürmeyi garanti eder. Burada iç heap dizisi [5, 15, 10] olarak sonuçlanır, poll() ise doğru şekilde 5'i döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[5, 15, 10]
15$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$[5, 15, 10]
5$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$[5, 10, 15]
5$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$[15, 5, 10]
5$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<Integer> nums = new ArrayList<>(List.of(5, 3, 8, 3, 1));
Collections.sort(nums);
System.out.println(nums);
System.out.println(Collections.frequency(nums, 3));
System.out.println(Collections.max(nums));$$, $$java$$,
           $$Collections.sort() sorts in place: [1, 3, 3, 5, 8]. Collections.frequency() counts how many times 3 occurs (2 times). Collections.max() finds the largest element (8).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[1, 3, 3, 5, 8]
1
8$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$[1, 3, 3, 5, 8]
2
5$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$[1, 3, 3, 5, 8]
2
8$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$[5, 3, 8, 3, 1]
2
8$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> sayilar = new ArrayList<>(List.of(9, 2, 9, 4, 9));
Collections.sort(sayilar);
System.out.println(sayilar);
System.out.println(Collections.frequency(sayilar, 9));
System.out.println(Collections.min(sayilar));$$, $$java$$,
           $$Collections.sort(), yerinde sıralar: [2, 4, 9, 9, 9]. Collections.frequency(), 9'un kaç kez geçtiğini sayar (3 kez). Collections.min(), en küçük elemanı bulur (2).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[9, 2, 9, 4, 9]
3
2$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$[2, 4, 9, 9, 9]
2
2$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$[2, 4, 9, 9, 9]
3
9$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$[2, 4, 9, 9, 9]
3
2$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when `Collections.binarySearch()` is called on a list that is NOT sorted?$$,
           NULL, NULL,
           $$For Collections.binarySearch() to work correctly, the list must be sorted beforehand -- calling it on an unsorted list doesn't throw an exception but returns a wrong result, a silent bug.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It doesn't throw an exception, but it can return a wrong result -- a silent bug.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It throws IllegalStateException immediately.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It automatically sorts the list first, then searches.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It always returns -1 regardless of whether the element is present.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`Collections.binarySearch()`, SIRALANMAMIŞ bir liste üzerinde çağrıldığında ne olur?$$,
           NULL, NULL,
           $$Collections.binarySearch()'ün doğru çalışması için listenin önceden sıralanmış olması şarttır -- sıralanmamış bir listede çağırmak istisna fırlatmaz ama yanlış bir sonuç döner, sessiz bir hata.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'queues-collections-utility'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Eleman var olsa da olmasa da her zaman -1 döner.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$İstisna fırlatmaz, ama yanlış bir sonuç dönebilir -- sessiz bir hata.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Hemen IllegalStateException fırlatır.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Önce listeyi otomatik olarak sıralar, sonra arar.$$, FALSE, 3 FROM new_question_tr7;

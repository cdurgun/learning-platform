-- Promotion batch
-- Topic: lists (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V574-V594 (generics) and V553-V569 (exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/lists.md and content/tr/lists.md.
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
           $$What does this print?$$,
           $$List<Integer> list = new ArrayList<>(List.of(10, 20, 30, 40));
list.remove(2);
System.out.println(list);$$, $$java$$,
           $$On a List<Integer>, remove(2) resolves to the int overload remove(int index), not remove(Object) -- 2 is not auto-boxed here, so the element at index 2 (value 30) is removed.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[10, 20, 40]$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$[10, 20, 30, 40]$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Compile error -- the call is ambiguous.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$[20, 30, 40]$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> sayilar = new ArrayList<>(List.of(5, 15, 25, 35));
sayilar.remove(1);
System.out.println(sayilar);$$, $$java$$,
           $$Bir List<Integer> üzerinde remove(1), int overload'ı olan remove(int index)'e çözümlenir, remove(Object)'e değil -- 1 burada otomatik kutulanmaz, bu yüzden index 1'deki eleman (değer 15) silinir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[15, 25, 35]$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$[5, 25, 35]$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$[5, 15, 25, 35]$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Derleme hatası -- çağrı belirsizdir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly compares ArrayList and LinkedList performance for get(index)?$$,
           NULL, NULL,
           $$ArrayList is backed by a growable array, so get(index) jumps straight to a memory address -- O(1). LinkedList is a doubly-linked list, so reaching a given index requires walking one element at a time -- O(n).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both have O(1) get(index), but LinkedList uses more memory per call.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Both have O(n) get(index), since both must traverse from the start.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$ArrayList's get(index) is O(1); LinkedList's get(index) is O(n).$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$LinkedList's get(index) is O(1); ArrayList's get(index) is O(n).$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`ArrayList`'in başına (index 0) eleman eklemenin karmaşıklığı ile `LinkedList`'in başına eklemenin karmaşıklığı için hangisi doğrudur?$$,
           NULL, NULL,
           $$ArrayList'in başına eleman eklemek, sonraki tüm elemanları bir sağa kaydırmayı gerektirir -- O(n). LinkedList'in başına eklemek ise sadece birkaç referansı güncellemektir -- O(1).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ArrayList O(1)'dir, LinkedList O(n)'dir.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$İkisi de O(1)'dir.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$İkisi de O(n)'dir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$ArrayList O(n)'dir (sonraki elemanları kaydırmak gerekir), LinkedList O(1)'dir.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about Java's immutable list tools? (Select all that apply)$$,
           NULL, NULL,
           $$List.of(...) builds a brand-new unmodifiable list from scratch. Collections.unmodifiableList(list) returns an unmodifiable VIEW of an existing list -- if the original changes, the view changes too. List.copyOf(list) creates a completely independent, separate immutable copy.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$List.of(...) builds a brand-new unmodifiable list from scratch.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Collections.unmodifiableList(list) returns a view -- changes to the original list are reflected in it.$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$List.copyOf(list) returns a view tied to the original list.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Collections.unmodifiableList(list) creates an independent copy, unaffected by changes to the original.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Java'nın immutable liste araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$List.of(...) sıfırdan değiştirilemez yeni bir liste oluşturur. Collections.unmodifiableList(list), var olan bir listenin değiştirilemez bir GÖRÜNÜMÜNÜ döner -- orijinal değişirse görünüm de değişir. List.copyOf(list) ise tamamen bağımsız, ayrı bir immutable kopya oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Collections.unmodifiableList(list), orijinaldeki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$List.of(...) sıfırdan değiştirilemez yeni bir liste oluşturur.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Collections.unmodifiableList(list) bir görünüm döner -- orijinal liste değişirse bu da değişir.$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$List.copyOf(list), orijinale bağlı bir görünüm döner.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$List<String> items = new ArrayList<>(List.of("a", "b", "c"));
for (String item : items) {
    if (item.equals("b")) {
        items.remove(item);
    }
}$$, $$java$$,
           $$A for-each loop uses an Iterator under the hood. Calling List.remove() directly on the list while iterating throws ConcurrentModificationException, because the Iterator detects the list changed "unexpectedly".$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It runs fine and items is unchanged: [a, b, c].$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws IndexOutOfBoundsException.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It throws ConcurrentModificationException.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It runs fine and items ends up as [a, c].$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$List<String> renkler = new ArrayList<>(List.of("kirmizi", "mavi", "yesil"));
for (String renk : renkler) {
    if (renk.equals("mavi")) {
        renkler.remove(renk);
    }
}$$, $$java$$,
           $$for-each döngüsü arka planda bir Iterator kullanır. Dolaşırken listenin üzerinde doğrudan List.remove() çağırmak ConcurrentModificationException fırlatır, çünkü Iterator listenin "beklenmedik" şekilde değiştiğini fark eder.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sorunsuz çalışır ve renkler [kirmizi, yesil] olur.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorunsuz çalışır ve renkler değişmez: [kirmizi, mavi, yesil].$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$IndexOutOfBoundsException fırlatır.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$ConcurrentModificationException fırlatır.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<String> names = new ArrayList<>(List.of("Charlie", "Al", "Bob"));
names.sort(Comparator.comparing(String::length).thenComparing(Comparator.naturalOrder()));
System.out.println(names);$$, $$java$$,
           $$List.sort(Comparator) sorts in place. Comparing by length first: Al(2), Bob(3), Charlie(7) -- no ties, so thenComparing never actually applies here, but the primary length ordering fully determines the result.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[Al, Bob, Charlie]$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$[Charlie, Bob, Al]$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$[Al, Charlie, Bob]$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$[Bob, Al, Charlie]$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> kelimeler = new ArrayList<>(List.of("elma", "kivi", "uzum", "armut"));
kelimeler.sort(Comparator.comparing(String::length).thenComparing(Comparator.naturalOrder()));
System.out.println(kelimeler);$$, $$java$$,
           $$Önce uzunluğa göre karşılaştırılır: elma/kivi/uzum 4 harf, armut 5 harf -- armut her zaman son sırada olur. Üç eş-uzunluklu kelime arasında thenComparing devreye girer ve doğal (alfabetik) sıraya göre ayırır: elma < kivi < uzum.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[kivi, elma, uzum, armut]$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$[elma, kivi, uzum, armut]$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$[armut, elma, kivi, uzum]$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$[elma, armut, kivi, uzum]$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<Integer> numbers = new ArrayList<>(List.of(1, 2, 3, 4, 5, 6));
List<Integer> view = numbers.subList(1, 4);
view.clear();
System.out.println(numbers);$$, $$java$$,
           $$subList(from, to) returns a VIEW of the original list, not an independent copy. Calling clear() on the view also removes that range (index 1 to 3: values 2, 3, 4) from the original list.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[2, 3, 4]$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It throws UnsupportedOperationException.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$[1, 5, 6]$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$[1, 2, 3, 4, 5, 6]$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> harfler = new ArrayList<>(List.of("a", "b", "c", "d", "e"));
List<String> altListe = harfler.subList(1, 3);
altListe.clear();
System.out.println(harfler);$$, $$java$$,
           $$subList(from, to), orijinal listenin bağımsız bir kopyası değil, bir GÖRÜNÜMÜDÜR. Görünüm üzerinde clear() çağırmak, orijinal listedeki o aralığı da (index 1-2: "b", "c") siler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[a, b, c, d, e]$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$[b, c]$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$UnsupportedOperationException fırlatır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$[a, d, e]$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which call to `toArray()` on a `List<String>` correctly produces a `String[]` rather than an `Object[]`?$$,
           NULL, NULL,
           $$The no-argument toArray() returns an Object[] that loses type information, while toArray(new String[0]) (or toArray(String[]::new) in Java 11+) produces a correctly typed array.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$list.toArray(new String[0])$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$list.toArray()$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$(String[]) list.toArray()$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$list.toArray(Object.class)$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir `List<String>` üzerinde çağrılan hangi `toArray()` kullanımı doğru şekilde bir `Object[]` yerine bir `String[]` üretir?$$,
           NULL, NULL,
           $$Argümansız toArray(), tip bilgisini kaybeden bir Object[] döner; toArray(new String[0]) (ya da Java 11+'ta toArray(String[]::new)) ise doğru tipte bir dizi üretir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lists'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$list.toArray(Object.class)$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$list.toArray(new String[0])$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$list.toArray()$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$(String[]) list.toArray()$$, FALSE, 3 FROM new_question_tr7;

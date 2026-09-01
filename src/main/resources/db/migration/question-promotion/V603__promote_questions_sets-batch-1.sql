-- Promotion batch
-- Topic: sets (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V574-V594 (generics) and V553-V569 (exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/sets.md and content/tr/sets.md.
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

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What happens when `add(x)` is called on a `Set` that already contains an element equal to `x`?$$,
           NULL, NULL,
           $$add() silently returns false (rather than throwing) if you try to add an element that's already present -- the set itself is left unchanged.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It returns false and the set is unchanged -- no exception is thrown.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It throws IllegalArgumentException.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It replaces the existing element and returns true.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It throws IllegalStateException.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir `Set`'te zaten bulunan bir elemana eşit bir eleman için `add(x)` çağrıldığında ne olur?$$,
           NULL, NULL,
           $$add(), zaten var olan bir elemanı eklemeye çalışırsan sessizce false döner (istisna fırlatmaz) -- set'in kendisi değişmeden kalır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$IllegalStateException fırlatır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$false döner ve set değişmez -- hiçbir istisna fırlatılmaz.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$IllegalArgumentException fırlatır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Var olan elemanı değiştirir ve true döner.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes `HashSet`'s iteration order?$$,
           NULL, NULL,
           $$HashSet's iteration order is unrelated to insertion order -- it's determined by the elements' positions in the internal hash table, and that order can vary across JDK versions or even between runs.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's always sorted in natural order.$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It's always the reverse of insertion order.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It's unrelated to insertion order, determined by internal hash table positions, and can vary across JDK versions or runs.$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It always matches insertion order, just like LinkedHashSet.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`HashSet`'in dolaşma (iteration) sırası için hangisi doğrudur?$$,
           NULL, NULL,
           $$HashSet'in dolaşma sırası, elemanların eklenme sırasıyla ilgisizdir -- iç hash tablosundaki konumlarına göre belirlenir ve bu sıra JDK sürümüne, hatta çalışma zamanına göre değişebilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her zaman LinkedHashSet gibi eklenme sırasıyla aynıdır.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her zaman doğal sıraya göre sıralıdır.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Her zaman ters eklenme sırasıdır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Eklenme sırasıyla ilgisizdir, iç hash tablosundaki konumlara göre belirlenir ve JDK sürümüne ya da çalışma zamanına göre değişebilir.$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Set<String> set = new LinkedHashSet<>();
set.add("banana");
set.add("apple");
set.add("cherry");
set.add("apple");
System.out.println(set);$$, $$java$$,
           $$LinkedHashSet preserves all of HashSet's behavior (duplicates are silently ignored) while adding a linked list on top that remembers insertion order.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[banana, apple, cherry]$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$[apple, banana, cherry]$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$[banana, apple, cherry, apple]$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$[cherry, apple, banana]$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Set<String> sirali = new LinkedHashSet<>();
sirali.add("kedi");
sirali.add("kus");
sirali.add("balik");
sirali.add("kedi");
System.out.println(sirali);$$, $$java$$,
           $$LinkedHashSet, HashSet'in tüm davranışını korur (yinelenenler sessizce yok sayılır) ve üzerine eklenme sırasını hatırlayan bir bağlı liste ekler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[kus, kedi, balik]$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$[kedi, kus, balik]$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$[balik, kedi, kus]$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$[kedi, kus, balik, kedi]$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$TreeSet<Integer> set = new TreeSet<>(Set.of(50, 10, 30, 20, 40));
System.out.println(set);
System.out.println(set.higher(20));$$, $$java$$,
           $$TreeSet always keeps its elements sorted regardless of insertion order, so it prints [10, 20, 30, 40, 50]. higher(20) returns the strictly-greater-than element, which is 30 (not 20 itself).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[10, 20, 30, 40, 50]
20$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$[10, 20, 30, 40, 50]
40$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$[10, 20, 30, 40, 50]
30$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$[50, 10, 30, 20, 40]
30$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$TreeSet<Integer> kume = new TreeSet<>(Set.of(7, 3, 9, 1, 5));
System.out.println(kume);
System.out.println(kume.floor(6));$$, $$java$$,
           $$TreeSet, elemanları eklenme sırasından bağımsız olarak her zaman sıralı tutar: [1, 3, 5, 7, 9]. floor(6), 6'ya eşit ya da 6'dan küçük en büyük elemanı döner, bu da 5'tir (6 kümede yok).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[7, 3, 9, 1, 5]
5$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$[1, 3, 5, 7, 9]
7$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$[1, 3, 5, 7, 9]
6$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$[1, 3, 5, 7, 9]
5$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Point {
    int x, y;
    Point(int x, int y) { this.x = x; this.y = y; }
}

Set<Point> points = new HashSet<>();
points.add(new Point(1, 2));
points.add(new Point(1, 2));
System.out.println(points.size());$$, $$java$$,
           $$Point doesn't override equals()/hashCode(), so Object's default is used -- "equality" collapses to just same reference (==). The two Point instances are different objects, so HashSet treats them as different elements and adds both.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$1$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$0$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$2$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$1$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Set<Integer> a = new HashSet<>(Set.of(1, 2, 3, 4));
Set<Integer> b = new HashSet<>(Set.of(3, 4, 5, 6));
a.retainAll(b);
System.out.println(a.size());$$, $$java$$,
           $$retainAll() computes the intersection, keeping only elements present in both sets -- {1,2,3,4} intersected with {3,4,5,6} leaves {3, 4}, so a.size() is 2.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$6$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$0$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$2$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$4$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Set<Integer> a = new HashSet<>(Set.of(10, 20, 30, 40));
Set<Integer> b = new HashSet<>(Set.of(30, 40));
a.removeAll(b);
System.out.println(a.size());$$, $$java$$,
           $$removeAll(), fark (difference) hesaplar -- diğer kümede olanları çıkarır. {10,20,30,40}'tan {30,40} çıkarılınca {10,20} kalır, bu yüzden a.size() 2'dir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$4$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$0$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$6$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$2$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true, according to this lesson's guidance? (Select all that apply)$$,
           NULL, NULL,
           $$HashSet is the fastest choice when order doesn't matter. TreeSet's add()/contains()/remove() are O(log n), slower than HashSet's O(1) -- so it should only be used when sorted iteration is genuinely needed.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HashSet is the fastest choice when iteration order doesn't matter.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$TreeSet's add()/contains()/remove() are O(log n), slower than HashSet's O(1).$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$TreeSet should be the default choice even when sorted iteration isn't needed.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$LinkedHashSet is slower than HashSet at add()/contains() because it always keeps elements sorted.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Dolaşma sırası önemli değilse HashSet en hızlı seçenektir. TreeSet'in add()/contains()/remove() işlemleri O(log n)'dir, HashSet'in O(1)'inden daha yavaştır -- bu yüzden yalnızca sıralı dolaşmaya gerçekten ihtiyaç varsa tercih edilmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sets'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$LinkedHashSet, elemanları her zaman sıralı tuttuğu için add()/contains()'te HashSet'ten daha yavaştır.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Dolaşma sırası önemli değilse HashSet en hızlı seçenektir.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$TreeSet'in add()/contains()/remove() işlemleri O(log n)'dir, HashSet'in O(1)'inden daha yavaştır.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Sıralı dolaşmaya ihtiyaç olmasa bile TreeSet varsayılan seçim olmalıdır.$$, FALSE, 3 FROM new_question_tr7;

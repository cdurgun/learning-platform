-- Promotion batch
-- Topic: maps (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V574-V594 (generics) and V553-V569 (exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/maps.md and content/tr/maps.md.
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
           $$Which statement correctly describes the relationship between `Map` and `Collection`?$$,
           NULL, NULL,
           $$Map does NOT extend Collection -- it's a separate branch of the Collections Framework, since it needs a two-parameter shape (Map<K,V>) rather than Iterable<E>.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Map does NOT extend Collection -- it's a separate branch of the Collections Framework.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Map extends Collection, just like List and Set.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Map extends Set, since keys must be unique.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Collection extends Map.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`Map` ile `Collection` arasındaki ilişki için hangisi doğrudur?$$,
           NULL, NULL,
           $$Map, Collection'ı genişletmez -- Collections Framework'ün ayrı bir dalıdır, çünkü Iterable<E> yerine iki parametreli bir yapıya (Map<K,V>) ihtiyaç duyar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Collection, Map'i genişletir.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Map, Collection'ı GENİŞLETMEZ -- Collections Framework'ün ayrı bir dalıdır.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Map, tıpkı List ve Set gibi Collection'ı genişletir.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Map, anahtarlar benzersiz olduğu için Set'i genişletir.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 30);
Integer bobAge = ages.get("Bob");
System.out.println(bobAge);$$, $$java$$,
           $$get(key) returns null when the key is missing -- it doesn't throw. "Bob" was never put into the map, so bobAge is null.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It throws NullPointerException.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$null$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It throws NoSuchElementException.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<String, String> baskentler = new HashMap<>();
baskentler.put("Turkiye", "Ankara");
String baskent = baskentler.get("Almanya");
System.out.println(baskent);$$, $$java$$,
           $$get(key), anahtar yoksa null döner -- istisna fırlatmaz. "Almanya" hiç put edilmediği için baskent null olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$NoSuchElementException fırlatır.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$"" (boş string)$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$NullPointerException fırlatır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$null$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about iterating a `Map` when you need both the key and the value? (Select all that apply)$$,
           NULL, NULL,
           $$Iterating keySet() and calling get(key) at each step performs an unnecessary second lookup per element. entrySet() gives both the key and value in a single step, with a single lookup.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Iterating keySet() and calling get(key) at each step performs an unnecessary second lookup.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$entrySet() gives both the key and value in a single step, with a single lookup.$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$keySet() + get() is always faster than entrySet() because keySet() is a smaller collection.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$entrySet() cannot be used with a for-each loop.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Hem anahtara hem değere ihtiyaç duyduğunda bir `Map`'i dolaşmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$keySet() üzerinde dolaşıp her adımda get(key) çağırmak gereksiz bir ikinci arama yapar. entrySet(), anahtarı ve değeri tek bir adımda, tek bir aramayla verir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$entrySet(), bir for-each döngüsüyle kullanılamaz.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$keySet() üzerinde dolaşıp her adımda get(key) çağırmak gereksiz bir ikinci arama yapar.$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$entrySet(), anahtarı ve değeri tek bir adımda, tek bir aramayla verir.$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$keySet() + get(), keySet() daha küçük bir koleksiyon olduğu için her zaman entrySet()'ten daha hızlıdır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Map<String, Integer> map = new TreeMap<>();
map.put("banana", 2);
map.put("apple", 1);
map.put("cherry", 3);
System.out.println(map.keySet());$$, $$java$$,
           $$TreeMap always keeps its keys sorted, regardless of insertion order -- so the keys print in alphabetical order.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[cherry, banana, apple]$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$An unpredictable order that can vary between runs.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$[apple, banana, cherry]$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$[banana, apple, cherry]$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<String, Integer> harita = new LinkedHashMap<>();
harita.put("z", 1);
harita.put("a", 2);
harita.put("m", 3);
System.out.println(harita.keySet());$$, $$java$$,
           $$LinkedHashMap, HashMap'in tüm davranışını korur ve üzerine eklenme sırasını hatırlayan bir bağlı liste ekler -- bu yüzden anahtarlar eklenme sırasıyla yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[a, m, z]$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$[m, a, z]$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Çalıştırmalar arasında değişebilen, öngörülemez bir sıra.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$[z, a, m]$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about Java's immutable `Map` tools? (Select all that apply)$$,
           NULL, NULL,
           $$Collections.unmodifiableMap(map) returns a view -- if the original map changes, the view changes too. Map.copyOf(map) creates an independent copy, unaffected by later changes to the original.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Collections.unmodifiableMap(map) returns a view -- changes to the original map are reflected in it.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Map.copyOf(map) creates an independent copy, unaffected by later changes to the original.$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Map.of(...) can hold an unlimited number of key-value pairs with no alternative ever needed.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Map.copyOf(map) returns a view tied to the original map.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Java'nın immutable `Map` araçlarıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Collections.unmodifiableMap(map) bir görünüm döner -- orijinal map değişirse görünüm de değişir. Map.copyOf(map), orijinaldeki sonraki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Map.copyOf(map), orijinale bağlı bir görünüm döner.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Collections.unmodifiableMap(map) bir görünüm döner -- orijinal map değişirse bu da değişir.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Map.copyOf(map), orijinaldeki sonraki değişikliklerden etkilenmeyen bağımsız bir kopya oluşturur.$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Map.of(...), başka bir alternatife hiç gerek kalmadan sınırsız sayıda anahtar-değer çifti tutabilir.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$Map<String, Integer> counts = new HashMap<>();
String[] words = {"cat", "dog", "cat", "cat", "dog"};
for (String w : words) {
    counts.merge(w, 1, Integer::sum);
}
System.out.println(counts.get("cat") + " " + counts.get("dog"));$$, $$java$$,
           $$merge() uses a starting value (1) if the key is missing, or combines it with the given function (Integer::sum) if it exists -- this is the classic counting pattern. "cat" appears 3 times, "dog" appears 2 times.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2 2$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$3 2$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$1 1$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Map<Integer, List<String>> gruplar = new HashMap<>();
String[] kelimeler = {"elma", "armut", "kiraz", "uzum"};
for (String k : kelimeler) {
    gruplar.computeIfAbsent(k.length(), key -> new ArrayList<>()).add(k);
}
System.out.println(gruplar.get(4));$$, $$java$$,
           $$computeIfAbsent(), anahtar yoksa yeni bir konteyner oluşturur -- klasik gruplama deseni. "elma" ve "uzum" 4 harflidir, "armut" ve "kiraz" 5 harflidir, bu yüzden 4 anahtarının değeri [elma, uzum] olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[armut, kiraz]$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$null$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$[elma, armut, kiraz, uzum]$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$[elma, uzum]$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Id {
    int value;
    Id(int value) { this.value = value; }
}

Map<Id, String> map = new HashMap<>();
map.put(new Id(1), "first");
map.put(new Id(1), "second");
System.out.println(map.size());$$, $$java$$,
           $$Id doesn't override equals()/hashCode(), so HashMap treats the two Id instances as different keys (different references), even though their value field is the same -- both entries are added separately.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$1$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$0$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'maps'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$2$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$1$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$0$$, FALSE, 3 FROM new_question_tr7;

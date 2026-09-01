-- Promotion batch
-- Topic: generics-with-collections (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V541 (records) through V569 (custom-exceptions),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/generics-with-collections.md and content/tr/generics-with-collections.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
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
           $$Which statement correctly describes `List<T>`, `Set<T>`, and `Map<K, V>`?$$,
           NULL, NULL,
           $$List<T>, Set<T>, and Map<K, V> are themselves ordinary generic types, built with exactly the same mechanism covered in "Introduction to Generics" -- List has one type parameter for its elements, Map has two, one for keys and one for values.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They are ordinary generic types, built with the same mechanism as any custom generic class.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$They are special language constructs that use a different mechanism than user-defined generic classes.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Only Map is actually generic; List and Set store raw Object references internally.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$List<T> and Set<T> share the exact same type parameter T across all collections.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`List<T>`, `Set<T>` ve `Map<K, V>` için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$List<T>, Set<T> ve Map<K, V>, "Generics'e Giriş"te işlenen tam olarak aynı mekanizmayla inşa edilmiş, kendileri de sıradan generic türlerdir -- List'in elemanları için bir tür parametresi vardır, Map'in ise ikisi vardır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir özel generic sınıfla aynı mekanizmayla inşa edilmiş, sıradan generic türlerdir.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Kullanıcı tanımlı generic sınıflardan farklı bir mekanizma kullanan özel dil yapılarıdır.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca Map gerçekten generic'tir; List ve Set içeride raw Object referansları saklar.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$List<T> ve Set<T>, tüm koleksiyonlar arasında tam olarak aynı T tür parametresini paylaşır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A `Map<String, Integer>` is declared, and code tries `map.put("Bob", "thirty")`, passing a String where an Integer value is expected. Which of the following are true? (Select all that apply)$$,
           NULL, NULL,
           $$The compile-time checking from "Introduction to Generics" applies to every collection operation -- add, put, get -- not just to construction. Passing "thirty" where an Integer is expected is rejected at compile time, since Map<String, Integer>'s put expects an Integer value.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The call fails to compile, since put(String, Integer) expects an Integer for the value.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile-time checking applies to every collection operation, not just construction.$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The call compiles, and the mismatch would only surface later as a ClassCastException.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Map.put always accepts a plain Object for its value regardless of the declared type arguments.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir `Map<String, Integer>` bildiriliyor ve kod, bir Integer value beklenirken bir String geçirerek `map.put("defter", "elli")` çağırmayı deniyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$"Generics'e Giriş"teki derleme-zamanı kontrolü, her koleksiyon işlemine -- add, put, get -- uygulanır, yalnızca oluşturmaya değil. Bir Integer beklenirken "elli" geçirmek derleme zamanında reddedilir, çünkü Map<String, Integer>'ın put'u bir Integer value bekler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çağrı derlenmez, çünkü put(String, Integer) value için bir Integer bekler.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme-zamanı kontrolü yalnızca oluşturmaya değil, her koleksiyon işlemine uygulanır.$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Çağrı derlenir, ve uyuşmazlık ancak daha sonra bir ClassCastException olarak ortaya çıkar.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Map.put, bildirilen tür argümanlarından bağımsız olarak value için her zaman düz bir Object kabul eder.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static void addNumber(List<Object> list) {
    list.add(42);
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        addNumber(names);
    }
}$$, $$java$$,
           $$If List<String> WERE allowed to be passed where a List<Object> is expected, addNumber(...) could insert an Integer into what its caller believes is purely a list of Strings -- a broken promise the type system has no way to catch later. Invariance is precisely what prevents that: addNumber(names) is rejected at compile time.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- addNumber(names) is rejected, since List<String> is not a List<Object>.$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles and inserts 42 into names, mixing an Integer into a List<String>.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles but throws ClassCastException when addNumber runs.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It compiles because String and Object are related through inheritance.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static void sayiEkle(List<Object> liste) {
    liste.add(99);
}

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = new ArrayList<>();
        sayiEkle(kelimeler);
    }
}$$, $$java$$,
           $$List<String>'in bir List<Object> beklenen yerde geçirilmesine izin verilseydi, sayiEkle(...), çağıranın yalnızca String'lerden oluştuğuna inandığı bir listeye bir Integer ekleyebilirdi -- tür sisteminin daha sonra yakalamanın hiçbir yolu olmayan, bozulmuş bir söz. Değişmezlik tam olarak bunu önler: sayiEkle(kelimeler) derleme zamanında reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- sayiEkle(kelimeler) reddedilir, çünkü List<String>, List<Object> değildir.$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ve kelimeler'e 99'u ekler, bir List<String>'e bir Integer karıştırır.$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir ama sayiEkle çalıştığında ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Derlenir çünkü String ve Object kalıtım yoluyla ilişkilidir.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<String> names = new ArrayList<>();
names.add("Sam");
System.out.println(names.getClass().getSimpleName());$$, $$java$$,
           $$The diamond operator, <>, infers a constructor's type argument from the variable it's being assigned to -- new ArrayList<>() assigned to a List<String> variable becomes an ArrayList<String>. At runtime, the class is simply ArrayList (erasure means the type argument doesn't appear in getSimpleName()).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ArrayList$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$ArrayList<String>$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$List$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- the diamond operator requires an explicit type argument on the left.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> puanlar = new ArrayList<>();
puanlar.add(100);
System.out.println(puanlar.getClass().getSimpleName());$$, $$java$$,
           $$Diamond operatörü, <>, bir constructor'ın tür argümanını atandığı değişkenden çıkarır -- bir List<Integer> değişkenine atanan new ArrayList<>(), bir ArrayList<Integer> olur. Çalışma zamanında sınıf yalnızca ArrayList'tir (erasure, tür argümanının getSimpleName()'de görünmemesi demektir).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ArrayList$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$ArrayList<Integer>$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$List$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- diamond operatörü sol tarafta açık bir tür argümanı gerektirir.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What type does `scores` have in `var scores = List.of(90, 85, 78);`?$$,
           NULL, NULL,
           $$var infers the variable's own type from whatever's on the right-hand side -- var scores = List.of(90, 85, 78) gives scores the type List<Integer>, deduced entirely from List.of(...)'s arguments.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$List<Integer>, deduced entirely from List.of(...)'s arguments.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$List<Object>, since var always widens to the most general type.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$var itself, a genuinely untyped variable that accepts any assignment later.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$List<int[]>, since var treats numeric literals as an array.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`var isimler = List.of("Ada", "Mert");` ifadesinde `isimler` hangi türe sahiptir?$$,
           NULL, NULL,
           $$var, değişkenin kendi türünü sağ taraftaki her neyse ondan çıkarır -- var isimler = List.of("Ada", "Mert"), isimler'e, tamamen List.of(...)'un argümanlarından çıkarılan List<String> türünü verir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$List<String>, tamamen List.of(...)'un argümanlarından çıkarılır.$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$List<Object>, çünkü var her zaman en genel türe genişler.$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$var'ın kendisi, sonradan herhangi bir atamayı kabul eden, gerçekten türsüz bir değişken.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$List<char[]>, çünkü var metin literallerini bir dizi olarak ele alır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 30);
ages.put(42, 25);$$, $$java$$,
           $$A Map<K, V>'s type safety covers keys and values independently -- put(...) is checked against both its own key type and value type. ages.put(42, 25) fails because 42 (an int) isn't a valid key for a Map<String, Integer>, even though 25 is a valid value.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile -- 42 isn't a valid key type for Map<String, Integer>.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles, since 42 autoboxes to a valid key of any type.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles but throws ClassCastException at runtime.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles because Map only checks the value type, not the key type.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$Map<Integer, String> ogrenciler = new HashMap<>();
ogrenciler.put(101, "Elif");
ogrenciler.put("102", "Can");$$, $$java$$,
           $$Bir Map<K, V>'nin tür güvenliği key'leri ve value'ları birbirinden bağımsız olarak kapsar -- put(...), hem kendi key türüne hem value türüne göre kontrol edilir. ogrenciler.put("102", "Can") başarısız olur çünkü "102" (bir String), Map<Integer, String> için geçerli bir key değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derlenmez -- "102", Map<Integer, String> için geçerli bir key türü değildir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir, çünkü "102" herhangi bir tür için geçerli bir key'e otomatik dönüşür.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir çünkü Map yalnızca value türünü kontrol eder, key türünü değil.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `var`, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$var infers a variable's entire declared type from its initializer -- it only removes the need to WRITE the type; the compiler still enforces it exactly as if it had been spelled out. It does not make the variable less strictly typed.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It only removes the need to write the type explicitly -- the compiler still enforces it fully.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It infers the variable's entire type from its initializer at compile time.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It makes the variable's type less strict, allowing more values to be assigned later.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It removes compile-time type checking for that variable entirely.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `var` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$var, bir değişkenin tüm bildirilen türünü başlatıcısından çıkarır -- yalnızca türü YAZMA ihtiyacını kaldırır; derleyici, sanki açıkça yazılmış gibi onu aynen zorlamaya devam eder. Değişkenin türünü daha az sıkı yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generics-with-collections'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca türü açıkça yazma ihtiyacını kaldırır -- derleyici onu aynen zorlamaya devam eder.$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Değişkenin tüm türünü derleme zamanında başlatıcısından çıkarır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Değişkenin türünü daha az sıkı yapar, sonradan daha fazla değerin atanmasına izin verir.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$O değişken için derleme-zamanı tür kontrolünü tamamen kaldırır.$$, FALSE, 3 FROM new_question_tr7;

-- Promotion batch
-- Topic: stream-fundamentals (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/stream-fundamentals.md and content/tr/stream-fundamentals.md.
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
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
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
           $$Which statement correctly describes what a `Stream<T>` actually is?$$,
           NULL, NULL,
           $$A Stream is a single-use pipeline that processes elements from a source in sequence -- it doesn't store data itself, unlike a data structure such as a List or a Set.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A single-use pipeline that processes elements from a source in sequence -- it doesn't store data itself.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A data structure, similar to a List, that stores its elements internally.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A reusable pipeline that can be traversed multiple times via separate terminal operations.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A synchronized wrapper around a Collection for thread-safe access.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir `Stream<T>`'in gerçekte ne olduğunu doğru şekilde tanımlayan ifade hangisidir?$$,
           NULL, NULL,
           $$Bir Stream, bir kaynaktan elemanları sırayla işleyen, tek kullanımlık bir pipeline'dır -- List ya da Set gibi bir veri yapısının aksine, verinin kendisini saklamaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir Collection'ın thread-safe erişim için senkronize edilmiş bir sarmalayıcısıdır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir kaynaktan elemanları sırayla işleyen, tek kullanımlık bir pipeline'dır -- verinin kendisini saklamaz.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$List'e benzer, elemanlarını içeride saklayan bir veri yapısıdır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Ayrı terminal operation'lar aracılığıyla birden fazla kez dolaşılabilen, yeniden kullanılabilir bir pipeline'dır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Ann", "Bob", "Cara", "Dan");
        List<String> result = names.stream()
                .filter(n -> n.length() > 3)
                .map(String::toUpperCase)
                .toList();
        System.out.println(result);
    }
}$$, $$java$$,
           $$filter() keeps only elements matching the predicate -- of Ann(3), Bob(3), Cara(4), Dan(3), only "Cara" has length > 3. map() then transforms the surviving element to uppercase.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[]$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$[CARA]$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$[ANN, BOB, CARA, DAN]$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[ALI, VELI, AYSE, CAN]$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$[]$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$[VELI, AYSE]$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<List<Integer>> nested = List.of(List.of(1, 2), List.of(3, 4), List.of(5));
        List<Integer> flat = nested.stream()
                .flatMap(List::stream)
                .collect(Collectors.toList());
        System.out.println(flat);
    }
}$$, $$java$$,
           $$flatMap() turns each inner List into a stream and merges those streams into a single flat stream, avoiding the "stream of streams" problem map() would produce.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[1, 2, 3, 4, 5]$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$[[1, 2], [3, 4], [5]]$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$[1, 2]$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$[a, b, c, d, e]$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$[[a, b], [c], [d, e]]$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$[a, b]$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does `distinct()` use to determine whether two stream elements are duplicates?$$,
           NULL, NULL,
           $$distinct() removes duplicate elements based on equals().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`hashCode()` alone, without calling equals()$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$`compareTo()` from Comparable$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$`equals()`$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$`==` reference identity only$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`distinct()`, iki stream elemanının birbirinin yinelenen kopyası olup olmadığını neye göre belirler?$$,
           NULL, NULL,
           $$distinct(), yinelenen elemanları equals()'e göre kaldırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca `==` referans eşitliği$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$equals() çağırmadan yalnızca `hashCode()`$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Comparable'dan gelen `compareTo()`$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$`equals()`$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(10, 20, 30, 40, 50, 60);
        List<Integer> page = nums.stream()
                .skip(2)
                .limit(2)
                .toList();
        System.out.println(page);
    }
}$$, $$java$$,
           $$skip(2) discards the first two elements, leaving [30, 40, 50, 60]. limit(2) then keeps only the first two of those: [30, 40].$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[30, 40]$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$[10, 20]$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$[50, 60]$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$[20, 30]$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[c, d]$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$[d, e]$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$[a, b]$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$[e, f]$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about intermediate operations like `filter()` and `map()`? (Select all that apply)$$,
           NULL, NULL,
           $$Intermediate operations are lazy -- calling them doesn't run anything yet, it just adds a step to the pipeline's description. Real work only starts once a terminal operation is called.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Each intermediate operation processes the entire source collection to completion before the next operation starts.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$An intermediate operation returns void, so it can't be chained further.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$They are lazy -- calling them doesn't run anything yet, it just adds a step to the pipeline's description.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Real work only starts once a terminal operation is called.$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`filter()` ve `map()` gibi intermediate operation'lar hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Intermediate operation'lar lazy'dir -- çağrılmaları henüz hiçbir şey çalıştırmaz, yalnızca pipeline'ın tanımına bir adım ekler. Gerçek iş ancak bir terminal operation çağrıldığında başlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek iş ancak bir terminal operation çağrıldığında başlar.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Her intermediate operation, bir sonraki operation başlamadan önce tüm kaynak koleksiyonu tamamen işler.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir intermediate operation void döner, bu yüzden daha fazla zincirlenemez.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Lazy'dirler -- çağrılmaları henüz hiçbir şey çalıştırmaz, yalnızca pipeline'ın tanımına bir adım ekler.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;
import java.util.stream.Stream;

public class Demo {
    public static void main(String[] args) {
        Stream<String> stream = List.of("a", "b", "c").stream();
        long count = stream.count();
        System.out.println(count);
        stream.forEach(System.out::println);
    }
}$$, $$java$$,
           $$A stream is single-use: once a terminal operation like count() runs, the stream is closed, and trying to reuse the same stream reference throws IllegalStateException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It prints 3, then throws IllegalStateException on the second use.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It prints 3, then a, b, c.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It fails to compile -- a Stream reference can't be reused at all, even syntactically.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It prints 3 and silently does nothing on the second call.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'stream-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$3 yazdırır ve ikinci çağrıda sessizce hiçbir şey yapmaz.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$3 yazdırır, sonra ikinci kullanımda IllegalStateException fırlatır.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$3, sonra 1, 2, 3 yazdırır.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Derlenmez -- bir Stream referansı sözdizimsel olarak bile yeniden kullanılamaz.$$, FALSE, 3 FROM new_question_tr7;

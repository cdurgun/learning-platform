-- Promotion batch
-- Topic: terminal-operations (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/terminal-operations.md and content/tr/terminal-operations.md.
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
           $$Why can `forEach(Consumer<T>)` only end a stream pipeline, never continue it?$$,
           NULL, NULL,
           $$forEach() returns void -- there's no result to chain another operation onto.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because it returns void -- there's no result to chain another operation onto.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because it's the only lazy operation in the Stream API.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because Consumer objects can't be reused after one call.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because forEach() always throws an exception if chained further.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`forEach(Consumer<T>)` neden bir stream pipeline'ını yalnızca sonlandırabilir, asla devam ettiremez?$$,
           NULL, NULL,
           $$forEach() void döner -- üzerine başka bir operation zincirleyebileceğin bir sonuç yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü forEach(), daha fazla zincirlenirse her zaman bir istisna fırlatır.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü void döner -- üzerine başka bir operation zincirleyebileceğin bir sonuç yoktur.$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Stream API'deki tek lazy operation'dır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Consumer nesneleri bir çağrıdan sonra yeniden kullanılamaz.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 3, 4);
        int sum = nums.stream().reduce(0, Integer::sum);
        Optional<Integer> product = nums.stream().reduce((a, b) -> a * b);
        System.out.println(sum);
        System.out.println(product.get());
    }
}$$, $$java$$,
           $$reduce(identity, accumulator) always returns a plain value, starting from 0: 0+2+3+4=9. reduce(accumulator) with no identity returns Optional<T> instead: 2*3*4=24.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$9
Optional[24]$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- reduce needs an identity every time.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$9
24$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$24
9$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(1, 2, 5);
        int toplam = sayilar.stream().reduce(0, Integer::sum);
        Optional<Integer> carpim = sayilar.stream().reduce((a, b) -> a * b);
        System.out.println(toplam);
        System.out.println(carpim.get());
    }
}$$, $$java$$,
           $$reduce(identity, accumulator), 0'dan başlayarak her zaman düz bir değer döner: 0+1+2+5=8. reduce(accumulator) ise başlangıç değeri olmadan Optional<T> döner: 1*2*5=10.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10
8$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$8
Optional[10]$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Derleme hatası -- reduce her zaman bir identity gerektirir.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$8
10$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("pear", "fig", "banana");
        Optional<String> longest = words.stream().max(Comparator.comparing(String::length));
        System.out.println(longest.orElse("none"));
    }
}$$, $$java$$,
           $$max() requires a Comparator, since a stream's element type isn't guaranteed to be Comparable. Comparing by length: pear(4), fig(3), banana(6) -- banana is longest.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$banana$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$fig$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$none$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- max() requires no arguments for Comparable elements.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "uzum", "karpuz");
        Optional<String> enUzun = kelimeler.stream().max(Comparator.comparing(String::length));
        System.out.println(enUzun.orElse("yok"));
    }
}$$, $$java$$,
           $$max(), bir Comparator gerektirir, çünkü bir stream'in eleman türünün Comparable olacağı garanti edilmez. Uzunluğa göre karşılaştırınca: elma(4), uzum(4), karpuz(6) -- en uzun karpuz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- max(), Comparable elemanlar için argümansız çağrılmalıdır.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$karpuz$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$elma$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$yok$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$On a sequential stream, how do `findFirst()` and `findAny()` typically behave, according to this lesson?$$,
           NULL, NULL,
           $$On a sequential stream they behave identically -- the difference between them only shows up with parallel streams.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$findFirst() throws an exception if called on a sequential stream.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$findAny() is not available on sequential streams at all.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$They behave identically -- the difference between them only shows up with parallel streams.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$findAny() always returns a different element than findFirst().$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Sıralı (sequential) bir stream'de, bu derse göre `findFirst()` ve `findAny()` genellikle nasıl davranır?$$,
           NULL, NULL,
           $$Sequential bir stream'de aynı şekilde davranırlar -- aralarındaki fark yalnızca parallel stream'lerde ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$findAny() her zaman findFirst()'ten farklı bir eleman döner.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$findFirst(), sequential bir stream'de çağrılırsa istisna fırlatır.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$findAny(), sequential stream'lerde hiç kullanılamaz.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Aynı şekilde davranırlar -- aralarındaki fark yalnızca parallel stream'lerde ortaya çıkar.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 4, 6, 8);
        System.out.println(nums.stream().allMatch(n -> n % 2 == 0));
        System.out.println(nums.stream().anyMatch(n -> n > 7));
        System.out.println(nums.stream().noneMatch(n -> n < 0));
    }
}$$, $$java$$,
           $$allMatch checks every element is even -- true. anyMatch checks if at least one element is greater than 7 -- 8 qualifies, true. noneMatch checks no element is negative -- true.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true
true
true$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$true
false
true$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$false
true
true$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$true
true
false$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> sayilar = List.of(3, 6, 9, 12);
        System.out.println(sayilar.stream().allMatch(n -> n % 3 == 0));
        System.out.println(sayilar.stream().anyMatch(n -> n > 10));
        System.out.println(sayilar.stream().noneMatch(n -> n < 0));
    }
}$$, $$java$$,
           $$allMatch, her elemanın 3'e bölünüp bölünmediğini kontrol eder -- true. anyMatch, en az bir elemanın 10'dan büyük olup olmadığını kontrol eder -- 12 uyar, true. noneMatch, hiçbir elemanın negatif olmadığını kontrol eder -- true.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true
true
false$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$true
true
true$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$true
false
true$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$false
true
true$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().toList();
        nums.add(4);
    }
}$$, $$java$$,
           $$Stream.toList() returns an unmodifiable list -- unlike collect(Collectors.toList()), which is mutable. Calling add() on it throws UnsupportedOperationException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It fails to compile.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It throws ConcurrentModificationException.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It throws UnsupportedOperationException.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles and runs fine, adding 4.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.List;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("a", "b").stream().toList();
        harfler.add("c");
    }
}$$, $$java$$,
           $$Stream.toList(), collect(Collectors.toList())'in aksine, değiştirilemez (unmodifiable) bir liste döner. Üzerinde add() çağırmak UnsupportedOperationException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sorunsuz çalışır ve "c"yi ekler.$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenmez.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$ConcurrentModificationException fırlatır.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$UnsupportedOperationException fırlatır.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `count()`'s behavior, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$In some situations, the JDK can compute the count directly from the source's known size and skip running the pipeline entirely. When that optimization applies, even a peek() call earlier in the pipeline is never invoked.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$In some situations, the JDK can compute the count directly from the source's known size and skip running the pipeline entirely.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$When that optimization applies, even a `peek()` call earlier in the pipeline is never invoked.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$count() always processes every element of the pipeline, with no exceptions.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$This behavior is a bug that will be fixed in a future Java release.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `count()`'un davranışı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bazı durumlarda JDK, sayıyı doğrudan kaynağın bilinen boyutundan hesaplayabilir ve pipeline'ı hiç çalıştırmayabilir. Bu optimizasyon uygulandığında, pipeline'daki daha önceki bir peek() çağrısı bile hiç tetiklenmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'terminal-operations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu davranış, gelecekteki bir Java sürümünde düzeltilecek bir hatadır.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bazı durumlarda JDK, sayıyı doğrudan kaynağın bilinen boyutundan hesaplayabilir ve pipeline'ı hiç çalıştırmayabilir.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu optimizasyon uygulandığında, pipeline'daki daha önceki bir `peek()` çağrısı bile hiç tetiklenmez.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$count(), hiçbir istisna olmadan her zaman pipeline'daki her elemanı işler.$$, FALSE, 3 FROM new_question_tr7;

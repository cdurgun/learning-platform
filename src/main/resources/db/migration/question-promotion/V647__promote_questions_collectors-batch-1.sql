-- Promotion batch
-- Topic: collectors (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/collectors.md and content/tr/collectors.md.
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

-- Pair 1 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().collect(Collectors.toList());
        nums.add(4);
        System.out.println(nums);
    }
}$$, $$java$$,
           $$Unlike Stream.toList(), the list collect(Collectors.toList()) returns is mutable -- add() works fine.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[1, 2, 3, 4]$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It throws UnsupportedOperationException.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$[1, 2, 3]$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Compile error.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> harfler = List.of("x", "y").stream().collect(Collectors.toList());
        harfler.add("z");
        System.out.println(harfler);
    }
}$$, $$java$$,
           $$Stream.toList()'in aksine, collect(Collectors.toList())'in döndürdüğü liste mutable'dır -- add() sorunsuz çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası.$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$[x, y, z]$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$UnsupportedOperationException fırlatır.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$[x, y]$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following is NOT a valid overload of `Collectors.joining()`?$$,
           NULL, NULL,
           $$Collectors.joining() has exactly three overloads: no arguments, a delimiter, and a delimiter with a prefix and suffix. There is no four-argument form with a limit.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`joining(delimiter)`$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$`joining(delimiter, prefix, suffix)`$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$`joining(delimiter, prefix, suffix, limit)`$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$`joining()` with no arguments$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangisi `Collectors.joining()`'in geçerli bir overload'u DEĞİLDİR?$$,
           NULL, NULL,
           $$Collectors.joining()'in tam olarak üç overload'u vardır: argümansız, bir delimiter, ve bir delimiter ile prefix/suffix. limit alan dört argümanlı bir form yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Argümansız `joining()`$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$`joining(delimiter)`$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`joining(delimiter, prefix, suffix)`$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$`joining(delimiter, prefix, suffix, limit)`$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door");
        Map<Character, List<String>> byFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0)));
        System.out.println(byFirst.get('c'));
        System.out.println(byFirst.get('d'));
    }
}$$, $$java$$,
           $$groupingBy() derives a key from each element (its first character here) and groups elements sharing that key into a List, producing a Map<K, List<T>>.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[cat, car]
[dog, door]$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$[dog, door]
[cat, car]$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$[cat, car, dog, door]
null$$, FALSE, 2 FROM new_question_en3
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
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "kopek", "araba");
        Map<Character, List<String>> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0)));
        System.out.println(ilkHarfeGore.get('k'));
        System.out.println(ilkHarfeGore.get('a'));
    }
}$$, $$java$$,
           $$groupingBy(), her elemandan bir anahtar türetir (burada ilk karakter) ve aynı anahtara sahip elemanları bir List'te gruplar, bir Map<K, List<T>> üretir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası.$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$[kedi, kus, kopek]
[araba]$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$[araba]
[kedi, kus, kopek]$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$[kedi, kus, kopek, araba]
null$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door", "duck");
        Map<Character, Long> countByFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0), Collectors.counting()));
        System.out.println(countByFirst.get('c'));
        System.out.println(countByFirst.get('d'));
    }
}$$, $$java$$,
           $$A downstream collector determines what happens to each group's elements instead of the default List. Collectors.counting() reduces each group directly to its size.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[cat, car]
[dog, door, duck]$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Compile error -- groupingBy() only accepts one argument.$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$2
3$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$3
2$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("elma", "elbise", "uzum", "erik");
        Map<Character, Long> sayimIlkHarfeGore = kelimeler.stream()
                .collect(Collectors.groupingBy(k -> k.charAt(0), Collectors.counting()));
        System.out.println(sayimIlkHarfeGore.get('e'));
        System.out.println(sayimIlkHarfeGore.get('u'));
    }
}$$, $$java$$,
           $$Bir downstream collector, her grubun elemanlarına varsayılan List yerine ne olacağını belirler. Collectors.counting(), her grubu doğrudan boyutuna indirger.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$1
3$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$[elma, elbise, erik]
[uzum]$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Derleme hatası -- groupingBy() yalnızca bir argüman kabul eder.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$3
1$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does `Collectors.partitioningBy(predicate)` differ from `Collectors.groupingBy()` in terms of guaranteed map keys?$$,
           NULL, NULL,
           $$partitioningBy() always produces both a true and a false key in the result Map, even if one group is empty; groupingBy() only includes keys that actually had matching elements.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$partitioningBy() always produces both a true and a false key, even if one group is empty; groupingBy() only includes keys that actually had matching elements.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$groupingBy() always produces exactly two keys, just like partitioningBy().$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$partitioningBy() omits a key entirely if that group is empty, exactly like groupingBy().$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Neither guarantees any particular set of keys in the result.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`Collectors.partitioningBy(predicate)`, garanti edilen map anahtarları açısından `Collectors.groupingBy()`'dan nasıl farklıdır?$$,
           NULL, NULL,
           $$partitioningBy(), bir grup boş olsa bile sonuç Map'inde her zaman hem true hem false anahtarını üretir; groupingBy() ise yalnızca gerçekten eşleşen elemanı olan anahtarları içerir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi de sonuçta belirli bir anahtar kümesini garanti etmez.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$partitioningBy(), bir grup boş olsa bile her zaman hem true hem false anahtarını üretir; groupingBy() yalnızca gerçekten eşleşen elemanı olan anahtarları içerir.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$groupingBy(), tıpkı partitioningBy() gibi her zaman tam olarak iki anahtar üretir.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$partitioningBy(), tıpkı groupingBy() gibi, bir grup boşsa o anahtarı tamamen atlar.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog");
        Map<Character, String> byFirst = words.stream()
                .collect(Collectors.toMap(w -> w.charAt(0), w -> w));
        System.out.println(byFirst);
    }
}$$, $$java$$,
           $$Collectors.toMap()'s sharpest edge: if two different elements produce the same key, it throws IllegalStateException by default. Here "cat" and "car" both map to the key 'c'.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The map keeps only "cat" (first one wins).$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It compiles but silently produces an empty map.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It throws IllegalStateException, since "cat" and "car" both map to the key 'c'.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The map keeps only "car" (last one wins).$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = List.of("kedi", "kus", "araba");
        Map<Character, String> ilkHarfeGore = kelimeler.stream()
                .collect(Collectors.toMap(k -> k.charAt(0), k -> k));
        System.out.println(ilkHarfeGore);
    }
}$$, $$java$$,
           $$Collectors.toMap()'in en sivri noktası: iki farklı eleman aynı anahtarı üretirse, varsayılan olarak IllegalStateException fırlatır. Burada "kedi" ve "kus" ikisi de 'k' anahtarına eşlenir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Map yalnızca "kus"u tutar (son kazanır).$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Map yalnızca "kedi"yi tutar (ilk kazanır).$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Derlenir ama sessizce boş bir map üretir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$IllegalStateException fırlatır, çünkü "kedi" ve "kus" ikisi de 'k' anahtarına eşlenir.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the three functions that make up a `Collector`? (Select all that apply)$$,
           NULL, NULL,
           $$A supplier creates an empty container to hold the result, like an empty ArrayList. An accumulator adds each element into that container.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A supplier creates an empty container to hold the result, like an empty ArrayList.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$An accumulator adds each element into that container.$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A combiner is only ever used for sequential streams, never for parallel ones.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Every static method in the Collectors class requires you to define all three functions yourself.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir `Collector`'ı oluşturan üç fonksiyonu doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir supplier, sonucu tutacak boş bir konteyner oluşturur, boş bir ArrayList gibi. Bir accumulator, her elemanı o konteynere ekler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'collectors'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Collectors sınıfındaki her static metot, bu üç fonksiyonu kendi başına tanımlamanı gerektirir.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir supplier, sonucu tutacak boş bir konteyner oluşturur, boş bir ArrayList gibi.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir accumulator, her elemanı o konteynere ekler.$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir combiner yalnızca sequential stream'ler için kullanılır, parallel olanlar için asla kullanılmaz.$$, FALSE, 3 FROM new_question_tr7;

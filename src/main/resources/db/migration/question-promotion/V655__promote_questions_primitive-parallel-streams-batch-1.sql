-- Promotion batch
-- Topic: primitive-parallel-streams (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V615-V627 (OOP) and V599-V611 (collections),
-- these 14 questions were NOT produced by the n8n generation pipeline, NOT
-- judged by the AI Judge, and NOT ingested via /api/internal/questions/ingest --
-- per explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/primitive-parallel-streams.md and content/tr/primitive-parallel-streams.md.
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
           $$import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 5).sum());
        System.out.println(IntStream.rangeClosed(1, 5).sum());
    }
}$$, $$java$$,
           $$IntStream.range(start, end) excludes the end: 1+2+3+4=10. IntStream.rangeClosed(start, end) includes it: 1+2+3+4+5=15.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10
15$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$15
10$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$10
10$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$15
15$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 4).sum());
        System.out.println(IntStream.rangeClosed(1, 4).sum());
    }
}$$, $$java$$,
           $$IntStream.range(baslangic, bitis), bitisi hariç tutar: 1+2+3=6. IntStream.rangeClosed(baslangic, bitis) ise dahil eder: 1+2+3+4=10.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$10
10$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$6
10$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$10
6$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$6
6$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        IntStream empty = IntStream.of();
        System.out.println(empty.sum());
        OptionalDouble avg = IntStream.of().average();
        System.out.println(avg.isPresent());
    }
}$$, $$java$$,
           $$sum() returns a plain int directly, 0 for an empty stream. average() returns OptionalDouble instead -- for an empty stream, it's empty, so isPresent() is false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0
true$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It throws NoSuchElementException on sum().$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$0
false$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Compile error -- IntStream.of() needs at least one argument.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        IntStream bosStream = IntStream.of();
        System.out.println(bosStream.sum());
        OptionalDouble ortalama = IntStream.of().average();
        System.out.println(ortalama.isPresent());
    }
}$$, $$java$$,
           $$sum(), boş bir stream için doğrudan 0 döner. average() ise OptionalDouble döner -- boş bir stream için bu boştur, bu yüzden isPresent() false'tur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme hatası -- IntStream.of() en az bir argüman gerektirir.$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$0
true$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$sum()'da NoSuchElementException fırlatır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$0
false$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        List<Integer> list = IntStream.rangeClosed(1, 3)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(list);
    }
}$$, $$java$$,
           $$boxed() converts an IntStream directly into a Stream<Integer>, wrapping each primitive value into its corresponding boxed type -- needed here since collect()/Collectors only works with object streams.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$[1, 2, 3]$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Compile error -- IntStream can't be collected into a List<Integer>.$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$[1, 2, 3, 4]$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$6$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Ornek {
    public static void main(String[] args) {
        List<Integer> liste = IntStream.rangeClosed(5, 7)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(liste);
    }
}$$, $$java$$,
           $$boxed(), bir IntStream'i doğrudan bir Stream<Integer>'a dönüştürür, her primitive değeri kendi kutulanmış türüne sarar -- collect()/Collectors yalnızca object stream'lerle çalıştığı için burada gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$18$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$[5, 6, 7]$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Derleme hatası -- IntStream bir List<Integer>'a collect edilemez.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$[5, 6, 7, 8]$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$For an associative operation, what changes when you use `parallelStream()` instead of `stream()`?$$,
           NULL, NULL,
           $$Only the execution strategy changes -- the result is identical, but the work is split across multiple threads in the common ForkJoinPool.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$parallelStream() only works with primitive streams, never with object streams.$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$parallelStream() always produces a sorted result, unlike stream().$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Only the execution strategy changes -- the result is identical, but the work is split across multiple threads.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The result becomes different because elements are processed in a different mathematical order.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Assosiyatif (associative) bir işlem için, `stream()` yerine `parallelStream()` kullandığında ne değişir?$$,
           NULL, NULL,
           $$Yalnızca çalıştırma stratejisi değişir -- sonuç aynıdır, ama iş ortak ForkJoinPool içinde birden fazla thread'e bölünür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Elemanlar farklı bir matematiksel sırayla işlendiği için sonuç farklı olur.$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$parallelStream() yalnızca primitive stream'lerle çalışır, object stream'lerle asla çalışmaz.$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$parallelStream(), stream()'den farklı olarak her zaman sıralı bir sonuç üretir.$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca çalıştırma stratejisi değişir -- sonuç aynıdır, ama iş birden fazla thread'e bölünür.$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$On a parallel stream, what is the key difference between `forEach()` and `forEachOrdered()`?$$,
           NULL, NULL,
           $$forEach() processes elements in whatever order each thread picks them up, with no ordering guarantee; forEachOrdered() forces the result back into encounter order, at the cost of most of the parallelism benefit.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$forEach() has no ordering guarantee; forEachOrdered() forces encounter order, at the cost of most of the parallelism benefit.$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$forEach() always preserves encounter order; forEachOrdered() does not.$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$forEachOrdered() runs faster than forEach() because it skips thread coordination.$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The two are functionally identical on a parallel stream.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir parallel stream'de, `forEach()` ile `forEachOrdered()` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$forEach(), elemanları her thread'in ele geçirdiği sırayla işler, hiçbir sıra garantisi yoktur; forEachOrdered() ise sonucu encounter order'a geri zorlar, ama paralelliğin sağladığı hız avantajının çoğunu kaybettirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi bir parallel stream'de işlevsel olarak birebir aynıdır.$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$forEach()'in sıra garantisi yoktur; forEachOrdered() encounter order'ı zorlar, ama paralellik avantajının çoğunu kaybettirir.$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$forEach() her zaman encounter order'ı korur; forEachOrdered() korumaz.$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$forEachOrdered(), thread koordinasyonunu atladığı için forEach()'ten daha hızlı çalışır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about writing into a plain `ArrayList` from inside a parallel `forEach()`? (Select all that apply)$$,
           NULL, NULL,
           $$It creates a genuine data race that can silently produce fewer elements than expected, with no exception thrown. The correct fix is collect(Collectors.toList()), which handles thread-safety internally.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The bug is guaranteed to occur identically on every single run, making it easy to catch in testing.$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Java automatically synchronizes ArrayList.add() calls made from a parallel stream.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It creates a genuine data race that can silently produce fewer elements than expected, with no exception thrown.$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The correct fix is to use collect(Collectors.toList()) instead, which handles thread-safety internally.$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir parallel `forEach()` içinden düz bir `ArrayList`'e yazmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Hiçbir istisna fırlatmadan, beklenenden daha az eleman sessizce üretebilen gerçek bir data race yaratır. Doğru çözüm, thread-safety'yi içeride kendisi halleden collect(Collectors.toList())'i kullanmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Doğru çözüm, thread-safety'yi içeride kendisi halleden collect(Collectors.toList())'i kullanmaktır.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu hata her tek çalıştırmada birebir aynı şekilde ortaya çıkar, bu da test etmeyi kolaylaştırır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Java, bir parallel stream'den yapılan ArrayList.add() çağrılarını otomatik olarak senkronize eder.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir istisna fırlatmadan, beklenenden daha az eleman sessizce üretebilen gerçek bir data race yaratır.$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which condition must hold for a parallel stream to be worth using?$$,
           NULL, NULL,
           $$Parallel streams pay off when all conditions hold together: the dataset is large, the operation is CPU-intensive, and the operation is associative/stateless.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The dataset must be large, the operation must be CPU-intensive, and the operation must be associative/stateless -- all three together.$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Any dataset size benefits from parallelStream(), as long as the operation has no side effects.$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Parallel streams are always faster regardless of dataset size or operation cost.$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Parallel streams should be used whenever the elements are primitive types like int or long.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir parallel stream'in kullanmaya değer olması için hangi koşul(lar) sağlanmalıdır?$$,
           NULL, NULL,
           $$Parallel stream'ler, tüm koşullar birlikte sağlandığında karşılığını verir: veri kümesi büyük olmalı, işlem CPU-yoğun olmalı, ve işlem assosiyatif/stateless olmalı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'primitive-parallel-streams'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Parallel stream'ler, elemanlar int ya da long gibi primitive türler olduğunda her zaman kullanılmalıdır.$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Veri kümesi büyük olmalı, işlem CPU-yoğun olmalı, ve işlem assosiyatif/stateless olmalı -- üçü birlikte.$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$İşlemin yan etkisi olmadığı sürece, her veri kümesi boyutu parallelStream()'den fayda görür.$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Parallel stream'ler, veri kümesi boyutundan ya da işlem maliyetinden bağımsız olarak her zaman daha hızlıdır.$$, FALSE, 3 FROM new_question_tr7;
